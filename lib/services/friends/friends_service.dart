import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firestore service for DisstApp friends and friend requests.
///
/// Firestore Security Rules must independently authorize every operation.
class FriendsService {
  FriendsService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const String _users = 'users';
  static const String _requests = 'friendRequests';
  static const String _friends = 'friends';
  static const String _settings = 'friendSettings';
  static const String _follows = 'follows';

  String get _currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('You must sign in to use Friends.');
    }
    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> _requestRef(
    String senderId,
    String recipientId,
  ) {
    return _firestore
        .collection(_requests)
        .doc('${senderId}_$recipientId');
  }

  DocumentReference<Map<String, dynamic>> _friendRef(
    String userId,
    String otherId,
  ) {
    return _firestore.collection(_friends).doc('${userId}_$otherId');
  }

  DocumentReference<Map<String, dynamic>> _followRef(
    String followerId,
    String followedId,
  ) {
    return _firestore.collection(_follows).doc('${followerId}_$followedId');
  }

  /// Sends a new request or retries a previously declined/cancelled request.
  Future<void> sendFriendRequest(String recipientId) async {
    final senderId = _currentUserId;
    final targetId = recipientId.trim();

    if (targetId.isEmpty || targetId == senderId) {
      throw ArgumentError('Invalid friend request recipient.');
    }

    final recipientRef = _firestore.collection(_users).doc(targetId);
    final settingRef = _firestore.collection(_settings).doc(targetId);
    final requestRef = _requestRef(senderId, targetId);
    final reverseRequestRef = _requestRef(targetId, senderId);
    final forwardFriendRef = _friendRef(senderId, targetId);
    final reverseFriendRef = _friendRef(targetId, senderId);

    await _firestore.runTransaction((transaction) async {
      // Read all documents before writing.
      final recipient = await transaction.get(recipientRef);
      final setting = await transaction.get(settingRef);
      final existingRequest = await transaction.get(requestRef);
      final reverseRequest = await transaction.get(reverseRequestRef);
      final forwardFriend = await transaction.get(forwardFriendRef);
      final reverseFriend = await transaction.get(reverseFriendRef);

      if (!recipient.exists) {
        throw StateError('This user could not be found.');
      }

      if (setting.exists &&
          setting.data()?['allowFriendRequests'] != true) {
        throw StateError('This user is not accepting friend requests.');
      }

      if (forwardFriend.exists || reverseFriend.exists) {
        throw StateError('You are already connected as friends.');
      }

      if (reverseRequest.exists &&
          reverseRequest.data()?['status'] == 'pending') {
        throw StateError(
          'This user has already sent you a request. Accept it instead.',
        );
      }

      if (existingRequest.exists) {
        final status = existingRequest.data()?['status'];

        if (status == 'pending') {
          throw StateError('Your friend request is already pending.');
        }

        if (status == 'accepted') {
          throw StateError('This request has already been accepted.');
        }

        if (status != 'declined' && status != 'cancelled') {
          throw StateError('This request cannot be sent again.');
        }

        transaction.update(requestRef, {
          'status': 'pending',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.set(requestRef, {
          'senderId': senderId,
          'recipientId': targetId,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// Accepts an incoming request and creates both friendship documents
  /// in the same transaction.
  Future<void> acceptFriendRequest(String senderId) async {
    final userId = _currentUserId;
    final otherId = senderId.trim();

    if (otherId.isEmpty || otherId == userId) {
      throw ArgumentError('Invalid friend request sender.');
    }

    final requestRef = _requestRef(otherId, userId);
    final forwardRef = _friendRef(userId, otherId);
    final reverseRef = _friendRef(otherId, userId);

    await _firestore.runTransaction((transaction) async {
      final request = await transaction.get(requestRef);
      final forwardFriend = await transaction.get(forwardRef);
      final reverseFriend = await transaction.get(reverseRef);

      if (!request.exists ||
          request.data()?['status'] != 'pending' ||
          request.data()?['recipientId'] != userId) {
        throw StateError('This incoming request is no longer available.');
      }

      if (forwardFriend.exists || reverseFriend.exists) {
        throw StateError('Friendship documents already exist.');
      }

      final timestamp = FieldValue.serverTimestamp();

      transaction.set(forwardRef, {
        'userIds': [otherId, userId],
        'friendRequestId': requestRef.id,
        'createdAt': timestamp,
      });

      transaction.set(reverseRef, {
        'userIds': [otherId, userId],
        'friendRequestId': requestRef.id,
        'createdAt': timestamp,
      });

      transaction.update(requestRef, {
        'status': 'accepted',
        'updatedAt': timestamp,
      });
    });
  }

  /// Declines an incoming pending request.
  Future<void> declineFriendRequest(String senderId) async {
    final userId = _currentUserId;
    final otherId = senderId.trim();

    if (otherId.isEmpty || otherId == userId) {
      throw ArgumentError('Invalid friend request sender.');
    }

    final ref = _requestRef(otherId, userId);

    await _firestore.runTransaction((transaction) async {
      final request = await transaction.get(ref);
      final data = request.data();

      if (!request.exists ||
          data?['status'] != 'pending' ||
          data?['recipientId'] != userId) {
        throw StateError('This incoming request is no longer available.');
      }

      transaction.update(ref, {
        'status': 'declined',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Cancels a pending request sent by the current user.
  Future<void> cancelFriendRequest(String recipientId) async {
    final userId = _currentUserId;
    final otherId = recipientId.trim();

    if (otherId.isEmpty || otherId == userId) {
      throw ArgumentError('Invalid friend request recipient.');
    }

    final ref = _requestRef(userId, otherId);

    await _firestore.runTransaction((transaction) async {
      final request = await transaction.get(ref);
      final data = request.data();

      if (!request.exists ||
          data?['status'] != 'pending' ||
          data?['senderId'] != userId) {
        throw StateError('Your pending request could not be found.');
      }

      transaction.update(ref, {
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Removes both directional friendship documents atomically.
  Future<void> removeFriend(String otherUserId) async {
    final userId = _currentUserId;
    final otherId = otherUserId.trim();

    if (otherId.isEmpty || otherId == userId) {
      throw ArgumentError('Invalid friend.');
    }

    final forwardRef = _friendRef(userId, otherId);
    final reverseRef = _friendRef(otherId, userId);

    await _firestore.runTransaction((transaction) async {
      final forward = await transaction.get(forwardRef);
      final reverse = await transaction.get(reverseRef);

      if (!forward.exists && !reverse.exists) {
        throw StateError('This friendship could not be found.');
      }

      if (forward.exists &&
          !(forward.data()?['userIds'] as List? ?? []).contains(userId)) {
        throw StateError('You cannot remove this friendship.');
      }

      if (reverse.exists &&
          !(reverse.data()?['userIds'] as List? ?? []).contains(userId)) {
        throw StateError('You cannot remove this friendship.');
      }

      if (forward.exists) transaction.delete(forwardRef);
      if (reverse.exists) transaction.delete(reverseRef);
    });
  }

  /// Streams incoming pending requests.
  Stream<QuerySnapshot<Map<String, dynamic>>> incomingRequests() {
    final userId = _currentUserId;

    return _firestore
        .collection(_requests)
        .where('recipientId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  /// Streams outgoing pending requests.
  Stream<QuerySnapshot<Map<String, dynamic>>> outgoingRequests() {
    final userId = _currentUserId;

    return _firestore
        .collection(_requests)
        .where('senderId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  /// Streams the current user's friendship documents.
  Stream<QuerySnapshot<Map<String, dynamic>>> myFriends() {
    final userId = _currentUserId;

    return _firestore
        .collection(_friends)
        .where('userIds', arrayContains: userId)
        .snapshots();
  }

  /// Number of incoming pending requests.
  Stream<int> incomingRequestCount() {
    return incomingRequests().map((snapshot) => snapshot.size);
  }

  /// Watches whether the current user accepts new friend requests.
  Stream<bool> watchFriendRequestSetting() {
    final userId = _currentUserId;

    return _firestore
        .collection(_settings)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return true;
      return snapshot.data()?['allowFriendRequests'] == true;
    });
  }

  /// Updates the current user's friend-request preference.
  Future<void> setAllowFriendRequests(bool allow) async {
    final userId = _currentUserId;

    await _firestore.collection(_settings).doc(userId).set({
      'allowFriendRequests': allow,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Follows another user independently of friendship.
  Future<void> followUser(String followedUserId) async {
    final userId = _currentUserId;
    final targetId = followedUserId.trim();

    if (targetId.isEmpty || targetId == userId) {
      throw ArgumentError('Invalid user to follow.');
    }

    final targetRef = _firestore.collection(_users).doc(targetId);
    final followRef = _followRef(userId, targetId);

    await _firestore.runTransaction((transaction) async {
      final target = await transaction.get(targetRef);
      final follow = await transaction.get(followRef);

      if (!target.exists) {
        throw StateError('This user could not be found.');
      }

      if (follow.exists) {
        throw StateError('You are already following this user.');
      }

      transaction.set(followRef, {
        'followerId': userId,
        'followedId': targetId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Unfollows a user without changing friendship.
  Future<void> unfollowUser(String followedUserId) async {
    final userId = _currentUserId;
    final targetId = followedUserId.trim();

    if (targetId.isEmpty || targetId == userId) {
      throw ArgumentError('Invalid user to unfollow.');
    }

    final ref = _followRef(userId, targetId);

    await _firestore.runTransaction((transaction) async {
      final follow = await transaction.get(ref);

      if (!follow.exists) return;

      if (follow.data()?['followerId'] != userId) {
        throw StateError('You cannot remove another user’s follow.');
      }

      transaction.delete(ref);
    });
  }

  /// Streams users followed by the current user.
  Stream<QuerySnapshot<Map<String, dynamic>>> following() {
    final userId = _currentUserId;

    return _firestore
        .collection(_follows)
        .where('followerId', isEqualTo: userId)
        .snapshots();
  }

  /// Streams users who follow the current user.
  Stream<QuerySnapshot<Map<String, dynamic>>> followers() {
    final userId = _currentUserId;

    return _firestore
        .collection(_follows)
        .where('followedId', isEqualTo: userId)
        .snapshots();
  }
}
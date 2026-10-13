import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/friends/friends_service.dart';

class FriendsHomeScreen extends StatefulWidget {
  const FriendsHomeScreen({super.key});

  @override
  State<FriendsHomeScreen> createState() => _FriendsHomeScreenState();
}

class _FriendsHomeScreenState extends State<FriendsHomeScreen> {
  static const Color purple = Color(0xFF6C3BFF);
  static const Color blue = Color(0xFF2D9CFF);
  static const Color black = Color(0xFF121212);
  static const Color secondary = Color(0xFF667085);

  static const Color background = Color(0xFFF5F6FA);
  static const Color borderColor = Color(0xFFE8EAF0);

  final FriendsService _service = FriendsService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _friendsStream;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _incomingStream;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _outgoingStream;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream;

  String _query = '';
  final Set<String> _busyUserIds = <String>{};

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();

    _friendsStream = _service.myFriends();
    _incomingStream = _service.incomingRequests();
    _outgoingStream = _service.outgoingRequests();

    // Ana amfani da iyaka domin kada shafin ya karanta dukkan users.
    _usersStream = _firestore
        .collection('users')
        .limit(50)
        .snapshots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _runAction(
    String userId,
    Future<void> Function() action, {
    required String successMessage,
  }) async {
    if (_busyUserIds.contains(userId)) return;

    setState(() {
      _busyUserIds.add(userId);
    });

    try {
      await action();

      if (mounted) {
        _showMessage(successMessage);
      }
    } catch (error) {
      if (mounted) {
        _showMessage(_friendlyError(error));
      }
    } finally {
      if (mounted) {
        setState(() {
          _busyUserIds.remove(userId);
        });
      }
    }
  }

  String _friendlyError(Object error) {
    if (error is StateError || error is ArgumentError) {
      return error.toString().replaceFirst(
            RegExp(r'^(Bad state: |Invalid argument\(s\): )'),
            '',
          );
    }

    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Ba a ba da izinin wannan aiki ba. A duba Firestore Rules.';
        case 'unavailable':
          return 'An samu matsalar haɗin intanet. Ka sake gwadawa.';
        case 'unauthenticated':
          return 'Da fatan za ka sake shiga asusunka.';
        case 'failed-precondition':
          return 'Ana buƙatar gyaran tsarin Firestore kafin wannan aikin.';
        default:
          return 'An samu matsala. Ka sake gwadawa.';
      }
    }

    return 'An samu kuskure. Ka sake gwadawa.';
  }

  String _displayName(Map<String, dynamic> data) {
    final displayName = (data['displayName'] ?? '').toString().trim();
    final username = (data['username'] ?? '').toString().trim();

    if (displayName.isNotEmpty) return displayName;
    if (username.isNotEmpty) return username.replaceFirst('@', '');

    return 'DisstApp User';
  }

  String _username(Map<String, dynamic> data) {
    final username = (data['username'] ?? '').toString().trim();

    if (username.isEmpty) return '';

    return username.startsWith('@') ? username : '@$username';
  }

  String _photoUrl(Map<String, dynamic> data) {
    return (data['photoUrl'] ?? '').toString().trim();
  }

  bool _matchesSearch(Map<String, dynamic> data) {
    final query = _query.trim().toLowerCase();

    if (query.isEmpty) return true;

    final name = _displayName(data).toLowerCase();
    final username = _username(data).toLowerCase();

    return name.contains(query) || username.contains(query);
  }

  String? _otherUserId(Map<String, dynamic> data) {
    final ids = data['userIds'];

    if (ids is! List) return null;

    for (final id in ids) {
      if (id is String && id != _currentUserId) {
        return id;
      }
    }

    return null;
  }

  Set<String> _friendIds(
    QuerySnapshot<Map<String, dynamic>>? snapshot,
  ) {
    final ids = <String>{};

    for (final document in snapshot?.docs ?? []) {
      final otherId = _otherUserId(document.data());

      if (otherId != null) {
        ids.add(otherId);
      }
    }

    // Service ɗinmu yana adana takardun friendship biyu.
    // Set yana hana mutum ɗaya bayyana sau biyu.
    return ids;
  }

  Set<String> _requestUserIds(
    QuerySnapshot<Map<String, dynamic>>? snapshot, {
    required bool incoming,
  }) {
    final ids = <String>{};

    for (final document in snapshot?.docs ?? []) {
      final data = document.data();
      final id = incoming ? data['senderId'] : data['recipientId'];

      if (id is String && id.isNotEmpty) {
        ids.add(id);
      }
    }

    return ids;
  }

  Widget _buildAvatar({
    required String name,
    required Color color,
    String photoUrl = '',
    double radius = 24,
  }) {
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim().substring(0, 1).toUpperCase();

    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      backgroundImage: photoUrl.startsWith('https://')
          ? NetworkImage(photoUrl)
          : null,
      onBackgroundImageError: photoUrl.startsWith('https://')
          ? (Object exception, StackTrace? stackTrace) {}
          : null,
      child: photoUrl.startsWith('https://')
          ? null
          : Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(
        child: CircularProgressIndicator(
          color: purple,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: secondary,
            size: 30,
          ),
          const SizedBox(height: 8),
          const Text(
            'An kasa loda bayanai',
            style: TextStyle(
              color: black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Ka duba intanet da Firestore Rules.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondary,
              fontSize: 13,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh, color: purple),
            label: const Text(
              'Sake gwadawa',
              style: TextStyle(color: purple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      alignment: Alignment.center,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: secondary,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: black,
          elevation: 0,
          title: const Text(
            'Friends',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: _buildEmptyState(
          'Da fatan ka shiga asusunka domin amfani da Friends.',
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: black,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Friends',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {
              _searchFocusNode.requestFocus();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Add Friends',
            onPressed: () {
              _searchFocusNode.requestFocus();
              _showMessage(
                'Nemi mutum ta akwatin Search domin aika Friend Request.',
              );
            },
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _buildSearchField(),
          const SizedBox(height: 20),
          _buildFriendRequestsCard(),
          const SizedBox(height: 24),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _friendsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return _buildErrorState();
              if (!snapshot.hasData) return _buildLoading();

              final friendIds = _friendIds(snapshot.data);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    title: 'My Friends',
                    trailing: '${friendIds.length}',
                  ),
                  const SizedBox(height: 10),
                  if (friendIds.isEmpty)
                    _buildEmptyState('Ba ka da abokai tukuna.')
                  else
                    ...friendIds
                        .where((id) => id.isNotEmpty)
                        .map(_buildFriendTile),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          _buildSectionTitle(
            title: 'Find Friends',
            trailing: null,
          ),
          const SizedBox(height: 10),
          _buildFindFriendsCard(),
          const SizedBox(height: 24),
          _buildSectionTitle(
            title: 'People You May Know',
            trailing: null,
          ),
          const SizedBox(height: 10),
          _buildSuggestions(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      onChanged: (value) {
        setState(() {
          _query = value;
        });
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search friends',
        hintStyle: const TextStyle(color: secondary),
        prefixIcon: const Icon(
          Icons.search,
          color: secondary,
        ),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear',
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _query = '';
                  });
                },
                icon: const Icon(Icons.close),
              ),
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildFriendRequestsCard() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _incomingStream,
      builder: (context, snapshot) {
        final count = snapshot.data?.size ?? 0;

        return InkWell(
          onTap: _openFriendRequests,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [purple, blue],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Friend Requests',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        snapshot.hasError
                            ? 'Ba a iya loda buƙatu ba'
                            : count == 1
                                ? 'Kana da buƙatar abota 1'
                                : 'Kana da buƙatun abota $count',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: purple,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openFriendRequests() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetContext).size.height * 0.72,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Friend Requests',
                          style: TextStyle(
                            color: black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: StreamBuilder<
                      QuerySnapshot<Map<String, dynamic>>>(
                    stream: _incomingStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return _buildErrorState();
                      if (!snapshot.hasData) return _buildLoading();

                      final requests = snapshot.data!.docs;

                      if (requests.isEmpty) {
                        return _buildEmptyState(
                          'Babu sabbin Friend Requests a yanzu.',
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: requests.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          final data = request.data();
                          final senderId = data['senderId'];

                          if (senderId is! String ||
                              senderId.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return _buildIncomingRequestTile(
                            senderId,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncomingRequestTile(String senderId) {
    return FutureBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      future: _firestore.collection('users').doc(senderId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ListTile(
            leading: CircleAvatar(
              backgroundColor: background,
              child: Icon(Icons.person, color: secondary),
            ),
            title: Text('Ba a iya loda profile ba'),
          );
        }

        if (!snapshot.hasData) {
          return const ListTile(
            leading: CircleAvatar(
              backgroundColor: background,
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: purple,
                ),
              ),
            ),
            title: Text('Ana loda profile...'),
          );
        }

        final user = snapshot.data!.data();

        if (user == null) {
          return const SizedBox.shrink();
        }

        final name = _displayName(user);
        final username = _username(user);
        final busy = _busyUserIds.contains(senderId);

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildAvatar(
                    name: name,
                    color: purple,
                    photoUrl: _photoUrl(user),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (username.isNotEmpty)
                          Text(
                            username,
                            style: const TextStyle(
                              color: secondary,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: busy
                          ? null
                          : () {
                              _runAction(
                                senderId,
                                () => _service.acceptFriendRequest(
                                  senderId,
                                ),
                                successMessage:
                                    'Yanzu kun zama abokai!',
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: busy
                          ? null
                          : () {
                              _runAction(
                                senderId,
                                () => _service.declineFriendRequest(
                                  senderId,
                                ),
                                successMessage:
                                    'An ƙi Friend Request.',
                              );
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: secondary,
                        side: const BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String? trailing,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(
              color: secondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildFriendTile(String friendId) {
    return FutureBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      future: _firestore.collection('users').doc(friendId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        if (!snapshot.hasData) {
          return const ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4),
            leading: CircleAvatar(
              backgroundColor: background,
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: purple,
                  strokeWidth: 2,
                ),
              ),
            ),
            title: Text(
              'Ana loda...',
              style: TextStyle(color: secondary, fontSize: 13),
            ),
          );
        }

        final user = snapshot.data!.data();

        if (user == null) {
          return const SizedBox.shrink();
        }

        final name = _displayName(user);
        final username = _username(user);

        if (!_matchesSearch(user)) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            leading: _buildAvatar(
              name: name,
              color: purple,
              photoUrl: _photoUrl(user),
            ),
            title: Text(
              name,
              style: const TextStyle(
                color: black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              username.isEmpty ? 'DisstApp User' : username,
              style: const TextStyle(
                color: secondary,
                fontSize: 13,
              ),
            ),
            trailing: IconButton(
              tooltip: 'View profile',
              onPressed: () {
                _showMessage(
                  'An haɗa bayanan abokin. Buɗe Profile zai buƙaci haɗin navigation.',
                );
              },
              icon: const Icon(
                Icons.chevron_right,
                color: secondary,
              ),
            ),
            onTap: () {
              _showMessage(
                'An haɗa bayanan abokin. Za mu haɗa buɗe Profile a mataki na gaba.',
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFindFriendsCard() {
    return Row(
      children: [
        Expanded(
          child: _buildFindFriendsAction(
            icon: Icons.person_add_alt_1_outlined,
            title: 'Add Friends',
            onTap: () {
              _searchFocusNode.requestFocus();
              _showMessage(
                'Yi amfani da Search domin nemo mai amfani.',
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildFindFriendsAction(
            icon: Icons.contacts_outlined,
            title: 'Contacts',
            onTap: () {
              _showMessage(
                'Haɗa Contacts zai buƙaci izinin mai amfani. Ba a kunna shi tukuna.',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFindFriendsAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: purple,
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: black,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _usersStream,
      builder: (context, usersSnapshot) {
        if (usersSnapshot.hasError) return _buildErrorState();
        if (!usersSnapshot.hasData) return _buildLoading();

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _friendsStream,
          builder: (context, friendsSnapshot) {
            if (friendsSnapshot.hasError) return _buildErrorState();
            if (!friendsSnapshot.hasData) return _buildLoading();

            return StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream: _outgoingStream,
              builder: (context, outgoingSnapshot) {
                if (outgoingSnapshot.hasError) {
                  return _buildErrorState();
                }
                if (!outgoingSnapshot.hasData) {
                  return _buildLoading();
                }

                return StreamBuilder<
                    QuerySnapshot<Map<String, dynamic>>>(
                  stream: _incomingStream,
                  builder: (context, incomingSnapshot) {
                    if (incomingSnapshot.hasError) {
                      return _buildErrorState();
                    }
                    if (!incomingSnapshot.hasData) {
                      return _buildLoading();
                    }

                    final friendIds = _friendIds(friendsSnapshot.data);
                    final outgoingIds = _requestUserIds(
                      outgoingSnapshot.data,
                      incoming: false,
                    );
                    final incomingIds = _requestUserIds(
                      incomingSnapshot.data,
                      incoming: true,
                    );

                    final people = usersSnapshot.data!.docs.where((doc) {
                      final data = doc.data();
                      final id = doc.id;

                      if (id == _currentUserId) return false;
                      if (friendIds.contains(id)) return false;
                      if (outgoingIds.contains(id)) return false;
                      if (incomingIds.contains(id)) return false;

                      return _matchesSearch(data);
                    }).toList();

                    if (people.isEmpty) {
                      return _buildEmptyState(
                        _query.trim().isEmpty
                            ? 'Ba a samu sabbin mutane a wannan jerin ba.'
                            : 'Ba a sami mutum mai wannan suna ba cikin sakamakon da aka loda.',
                      );
                    }

                    return Column(
                      children: people.map((doc) {
                        final data = doc.data();

                        return _buildSuggestionTile(
                          userId: doc.id,
                          data: data,
                        );
                      }).toList(),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSuggestionTile({
    required String userId,
    required Map<String, dynamic> data,
  }) {
    final name = _displayName(data);
    final username = _username(data);
    final busy = _busyUserIds.contains(userId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        leading: _buildAvatar(
          name: name,
          color: blue,
          photoUrl: _photoUrl(data),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: black,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          username.isEmpty ? 'DisstApp User' : username,
          style: const TextStyle(
            color: secondary,
            fontSize: 13,
          ),
        ),
        trailing: OutlinedButton(
          onPressed: busy
              ? null
              : () {
                  _runAction(
                    userId,
                    () => _service.sendFriendRequest(userId),
                    successMessage: 'An aika Friend Request!',
                  );
                },
          style: OutlinedButton.styleFrom(
            foregroundColor: purple,
            side: const BorderSide(color: purple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: busy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: purple,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
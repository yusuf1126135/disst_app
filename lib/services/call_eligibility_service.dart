class CallEligibilityResult {
  final bool hasPhoneNumber;
  final bool isOnDisstApp;
  final bool callsAllowed;

  const CallEligibilityResult({
    required this.hasPhoneNumber,
    required this.isOnDisstApp,
    required this.callsAllowed,
  });

  bool get canCall =>
      hasPhoneNumber &&
      isOnDisstApp &&
      callsAllowed;
}

class CallEligibilityService {
  const CallEligibilityService();

  Future<CallEligibilityResult> check({
    required String friendName,
  }) async {
    // Temporary local result.
    // Real phone-number, account and privacy checks
    // will be connected to Firebase later.

    return const CallEligibilityResult(
      hasPhoneNumber: true,
      isOnDisstApp: true,
      callsAllowed: true,
    );
  }
}
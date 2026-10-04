import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home/home_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;

  // ============================================================
  // DISSTAPP BRAND COLORS
  // ============================================================

  static const Color brandPurple = Color(0xFF5146D8);

  static const Color darkText = Color(0xFF18204A);
  static const Color secondaryText = Color(0xFF667085);

  static const Color background = Color(0xFFFCF9FF);
  static const Color borderColor = Color(0xFFD9DDEA);

  // ============================================================
  // EMAIL / PASSWORD LOGIN
  // ============================================================

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter your email and password.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = 'Something went wrong while signing in.';

      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'Incorrect email or password.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      }

      _showMessage(message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ============================================================
  // GOOGLE SIGN-IN
  // ============================================================

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } on GoogleSignInException catch (e) {
      if (!mounted) return;

      _showMessage(
        'Google Sign-In failed: ${e.code}',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      _showMessage(
        'Firebase could not complete Google Sign-In: ${e.code}',
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'There was a problem with Google Sign-In.',
      );
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: secondaryText,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(
        icon,
        color: brandPurple,
        size: 22,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: borderColor,
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: brandPurple,
          width: 1.8,
        ),
      ),
    );
  }

  // ============================================================
  // DISSTAPP LOGO
  // ============================================================

  Widget _disstAppLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: brandPurple,
          ),
          alignment: Alignment.center,
          child: const Text(
            'D',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'DisstApp',
          style: TextStyle(
            color: darkText,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GOOGLE "G" MARK
  // ============================================================

  Widget _googleIcon() {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _GoogleGMarkPainter(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 22),

              // --------------------------------------------------
              // SMALL DISSTAPP LOGO — LEFT
              // --------------------------------------------------

              Align(
                alignment: Alignment.centerLeft,
                child: _disstAppLogo(),
              ),

              const SizedBox(height: 54),

              // --------------------------------------------------
              // CENTERED TITLE
              // --------------------------------------------------

              const Center(
                child: Text(
                  'Sign in to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkText,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ),

              const SizedBox(height: 34),

              // --------------------------------------------------
              // EMAIL / PHONE
              // --------------------------------------------------

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: _fieldDecoration(
                  hint: 'Email or phone number',
                  icon: Icons.mail_outline_rounded,
                ),
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // PASSWORD
              // --------------------------------------------------

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!_isLoading) {
                    _login();
                  }
                },
                decoration: _fieldDecoration(
                  hint: 'Password',
                  icon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword
                        ? 'Show password'
                        : 'Hide password',
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: secondaryText,
                      size: 22,
                    ),
                  ),
                ),
              ),

              // --------------------------------------------------
              // FORGOT PASSWORD
              // --------------------------------------------------

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      left: 8,
                    ),
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: brandPurple,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // LOGIN BUTTON
              // --------------------------------------------------

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandPurple,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        brandPurple.withValues(alpha: 0.55),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.3,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 21,
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // OR
              // --------------------------------------------------

              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: borderColor,
                      thickness: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: borderColor,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // GOOGLE SIGN-IN
              // --------------------------------------------------

              SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: _isGoogleLoading
                      ? null
                      : _signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: darkText,
                    side: const BorderSide(
                      color: borderColor,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isGoogleLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: brandPurple,
                          ),
                        )
                      : Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            _googleIcon(),
                            const SizedBox(width: 12),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: darkText,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 25),

              // --------------------------------------------------
              // SIGN UP
              // --------------------------------------------------

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 14.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign-Up',
                        style: TextStyle(
                          color: brandPurple,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // LANGUAGES
              // --------------------------------------------------

              Center(
                child: TextButton.icon(
                  onPressed: () {
                    _showMessage(
                      'Language selection coming soon.',
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: brandPurple,
                  ),
                  icon: const Icon(
                    Icons.language_rounded,
                    color: brandPurple,
                    size: 21,
                  ),
                  label: const Text(
                    'Languages',
                    style: TextStyle(
                      color: brandPurple,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ================================================================
// GOOGLE G CUSTOM MARK
// ================================================================

class _GoogleGMarkPainter extends CustomPainter {
  const _GoogleGMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width * 0.37;

    final strokeWidth = size.width * 0.17;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Blue
    paint.color = const Color(0xFF4285F4);

    canvas.drawArc(
      rect,
      -0.78,
      1.55,
      false,
      paint,
    );

    // Red
    paint.color = const Color(0xFFEA4335);

    canvas.drawArc(
      rect,
      -3.14,
      1.30,
      false,
      paint,
    );

    // Yellow
    paint.color = const Color(0xFFFBBC05);

    canvas.drawArc(
      rect,
      2.25,
      1.20,
      false,
      paint,
    );

    // Green
    paint.color = const Color(0xFF34A853);

    canvas.drawArc(
      rect,
      1.00,
      1.25,
      false,
      paint,
    );

    // Google G horizontal bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.50,
        size.height * 0.43,
        size.width * 0.39,
        strokeWidth,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}
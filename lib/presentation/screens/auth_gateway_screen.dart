import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:julian_medical_center/presentation/theme/app_theme.dart';
import 'package:julian_medical_center/providers/auth_provider.dart';
import 'package:julian_medical_center/presentation/screens/admin_dashboard_screen.dart';

class AuthGatewayScreen extends ConsumerStatefulWidget {
  final bool initialSignUp;
  final VoidCallback? onClose;
  final VoidCallback? onSuccess;

  const AuthGatewayScreen({
    super.key,
    this.initialSignUp = false,
    this.onClose,
    this.onSuccess,
  });

  @override
  ConsumerState<AuthGatewayScreen> createState() => _AuthGatewayScreenState();
}

class _AuthGatewayScreenState extends ConsumerState<AuthGatewayScreen> {
  late bool _isSignUp;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialSignUp;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() => _localError = null);
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authProvider.notifier);

    if (_isSignUp) {
      if (!_agreeToTerms) {
        setState(() => _localError = "Please accept the Terms of Service to continue.");
        return;
      }
      await authNotifier.register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      await authNotifier.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }

    // 1. FIXED: Safely fetch the structural value after async gap from the current state container
    final authState = ref.read(authProvider).value;

    if (authState != null) {
      if (authState.errorMessage != null) {
        setState(() => _localError = authState.errorMessage);
      } else if (authState.isAuthenticated) {
        if (widget.onClose != null) widget.onClose!();
        if (widget.onSuccess != null) widget.onSuccess!();

        // 2. FIXED: Wrapped inside a framework-safe frame queue callback to avoid routing layout exceptions
        Future.microtask(() {
          if (!mounted) return;
          if (authState.user?.role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Welcome back, ${authState.user?.fullName}!"),
                backgroundColor: AppTheme.stableGreen,
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStateAsync = ref.watch(authProvider);
    final isLoading = authStateAsync.isLoading;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.highlightBlue, AppTheme.highlightTeal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text("J", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Julian Medical Center",
                          style: GoogleFonts.outfit(fontSize: 13, color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                    if (widget.onClose != null)
                      IconButton(
                        icon: const Icon(LucideIcons.x, color: Colors.white, size: 16),
                        onPressed: widget.onClose,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.15),
                          padding: const EdgeInsets.all(6),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  _isSignUp ? "Create your account" : "Welcome back",
                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  _isSignUp
                      ? "Join thousands of patients who trust Julian Medical Center."
                      : "Sign in to your patient or admin account.",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.7)),
                ),
                const SizedBox(height: 12),
                // Admin credentials hints
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.shieldAlert, color: Colors.white60, size: 13),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Admin? Use: admin@julianmedical.com / Admin@2026",
                          style: GoogleFonts.inter(fontSize: 9, color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Switcher
          Transform.translate(
            offset: const Offset(0, -16),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))
                ],
                border: Border.all(color: AppTheme.softBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _isSignUp = false;
                        _localError = null;
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !_isSignUp ? AppTheme.highlightBlue : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(11)),
                        ),
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: !_isSignUp ? Colors.white : AppTheme.textGray,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _isSignUp = true;
                        _localError = null;
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _isSignUp ? AppTheme.highlightBlue : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(11)),
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _isSignUp ? Colors.white : AppTheme.textGray,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Form fields and buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_isSignUp) ...[
                    // Social Sign In
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.chrome, color: Colors.blue, size: 16),
                      label: Text("Continue with Google", style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textDark)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppTheme.softBorder),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Container(height: 1, color: AppTheme.softBorder)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("or continue with email", style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textGray)),
                        ),
                        Expanded(child: Container(height: 1, color: AppTheme.softBorder)),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Errors Box
                  if (_localError != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.alertCircle, color: AppTheme.criticalRed, size: 14),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _localError!,
                              style: GoogleFonts.inter(fontSize: 11, color: AppTheme.criticalRed, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Sign Up Fields
                  if (_isSignUp) ...[
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(LucideIcons.user, size: 16),
                        hintText: "Full Name",
                      ),
                      validator: (v) => v == null || v.isEmpty ? "Please enter your full name" : null,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(LucideIcons.mail, size: 16),
                      hintText: "Email Address",
                    ),
                    validator: (v) => v == null || !v.contains('@') ? "Please enter a valid email" : null,
                  ),
                  const SizedBox(height: 12),

                  // Phone (Sign Up only)
                  if (_isSignUp) ...[
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(LucideIcons.phone, size: 16),
                        hintText: "Phone Number",
                      ),
                      validator: (v) => v == null || v.isEmpty ? "Please enter your phone number" : null,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.lock, size: 16),
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff, size: 16),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) => v == null || v.length < 6 ? "Password must be at least 6 characters" : null,
                  ),
                  const SizedBox(height: 12),

                  // Confirm Password
                  if (_isSignUp) ...[
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LucideIcons.lock, size: 16),
                        hintText: "Confirm Password",
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? LucideIcons.eye : LucideIcons.eyeOff, size: 16),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      validator: (v) => v != _passwordController.text ? "Passwords do not match" : null,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Forgot Password link
                  if (!_isSignUp)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Forgot Password?", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.highlightBlue)),
                      ),
                    ),

                  // Terms Box
                  if (_isSignUp)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                          activeColor: AppTheme.highlightBlue,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: RichText(
                              text: TextSpan(
                                text: "I agree to the ",
                                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textGray),
                                children: [
                                  TextSpan(text: "Terms of Service", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.highlightBlue)),
                                  const TextSpan(text: " and "),
                                  TextSpan(text: "Privacy Policy", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.highlightBlue)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.highlightBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(_isSignUp ? "Create Account" : "Sign In", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mode Toggle
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                          _localError = null;
                        });
                      },
                      child: Text(
                        _isSignUp ? "Already have an account? Sign in" : "Don't have an account? Sign up for free",
                        style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textGray),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
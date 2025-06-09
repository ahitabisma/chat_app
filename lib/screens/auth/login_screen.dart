import 'package:chat_app/themes/theme_extension.dart';
import 'package:chat_app/widgets/app_button.dart';
import 'package:chat_app/widgets/app_textfield.dart';
import 'package:chat_app/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // Field-specific error messages
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    // Clear error messages
    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

    super.dispose();
  }

  // Parse error message to separate field errors
  void _parseErrorMessages(String errorMessage) {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;

      // Check if the error contains field-specific messages
      if (errorMessage.toLowerCase().contains('email:')) {
        final emailErrorRegex = RegExp(
          r'email:(.*?)(?=\n|$)',
          caseSensitive: false,
        );
        final match = emailErrorRegex.firstMatch(errorMessage);
        if (match != null) {
          _emailError = match.group(1)?.trim();
          errorMessage = errorMessage.replaceAll(match.group(0)!, '').trim();
        }
      }

      if (errorMessage.toLowerCase().contains('password:')) {
        final passwordErrorRegex = RegExp(
          r'password:(.*?)(?=\n|$)',
          caseSensitive: false,
        );
        final match = passwordErrorRegex.firstMatch(errorMessage);
        if (match != null) {
          _passwordError = match.group(1)?.trim();
          errorMessage = errorMessage.replaceAll(match.group(0)!, '').trim();
        }
      }

      // If there's still some error text left, it's a general error
      if (errorMessage.isNotEmpty) {
        _generalError = errorMessage.toString().replaceFirst('error: ', '');
      }
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Clear previous error messages
      setState(() {
        _emailError = null;
        _passwordError = null;
        _generalError = null;
      });

      // Get email and password
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Call login function from provider
      ref.read(authProvider.notifier).login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = ResponsiveHelper.getScreenWidth(context);
    // Watch the auth state
    final authState = ref.watch(authProvider);
    final isLoading = authState['status'] == AuthState.loading;
    final error = authState['error'];

    // Only parse error when status is error and error is not null
    if (authState['status'] == AuthState.error && error != null) {
      _parseErrorMessages(error.toString());
    }

    if (authState['status'] == AuthState.authenticated) {
      // If already authenticated, navigate to home screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }

    return Scaffold(
      backgroundColor: context.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ChatApp',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome back!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              // General Error Message (if any)
              if (_generalError != null)
                Container(
                  width: width > 600 ? 500 : double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _generalError!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                width: width > 600 ? 500 : double.infinity,
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.email_outlined),
                        errorText: _emailError, // Field-specific error
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        hintText: 'Password',
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.lock_outline),
                        errorText: _passwordError, // Field-specific error
                        suffixIcon: IconButton(
                          icon: _isPasswordVisible
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'Login',
                        onPressed: _handleLogin,
                        isLoading: isLoading,
                        backgroundColor: context.primary,
                        textColor: context.scaffoldBackground,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref.read(authProvider.notifier).clearError();
                                // Navigate to register screen
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed('/register');
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: context.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

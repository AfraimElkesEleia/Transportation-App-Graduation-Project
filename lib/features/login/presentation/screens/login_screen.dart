import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_gradient_button.dart';
import 'package:transportation_app/core/widgets/app_text_form_field.dart';
import 'package:transportation_app/core/widgets/auth_background.dart';
import 'package:transportation_app/features/login/presentation/widgets/auth_headline.dart';
import 'package:transportation_app/features/login/presentation/widgets/remember_me_row.dart';
import 'package:transportation_app/features/login/presentation/widgets/sign_up_redirect.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.pushNamed(AppRoutes.homeScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // ── Accent bar ───────────────────────
            const AuthAccentBar(),
            const SizedBox(height: 10),

            // ── Headline ─────────────────────────
            const AuthHeadline(
              title: 'Welcome \nBack.',
              subtitle: 'Enter the future of travel',
            ),
            const SizedBox(height: 50),

            // ── Form ─────────────────────────────
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextFormField(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.email,
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            // ── Remember me / Forgot password ────
            RememberMeRow(
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v ?? false),
            ),
            const SizedBox(height: 20),

            // ── Sign In button ───────────────────
            AppGradientButton(
              label: 'Sign In',
              onPressed: _handleLogin,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),

            // ── Sign Up redirect ─────────────────
            SignUpRedirect(
              onTap: () => context.pushNamed(AppRoutes.signUpScreen),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

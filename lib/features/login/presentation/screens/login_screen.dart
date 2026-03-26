import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_gradient_button.dart';
import 'package:transportation_app/core/widgets/app_text_form_field.dart';
import 'package:transportation_app/core/widgets/auth_background.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_states.dart';
import 'package:transportation_app/features/login/presentation/widgets/auth_headline.dart';
import 'package:transportation_app/features/login/presentation/widgets/remember_me_row.dart';
import 'package:transportation_app/features/login/presentation/widgets/sign_up_redirect.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey           = GlobalKey<FormState>();
  final _emailController   = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe         = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── No more fake Future.delayed — cubit handles everything ──
  void _handleLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<LoginCubit>().login(
      email:      _emailController.text.trim(),
      password:   _passwordController.text,
      deviceInfo: 'Flutter App',
      rememberMe:_rememberMe
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.pushNamedAndRemoveuntil(
              AppRoutes.homeScreen,
              predicate: (_) => false,
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),           // Text() wraps the string
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const AuthAccentBar(),
              const SizedBox(height: 10),
              const AuthHeadline(
                title: 'Welcome \nBack.',
                subtitle: 'Enter the future of travel',
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      label:           'Email Address',
                      hint:            'Enter your email',
                      prefixIcon:      Icons.email,
                      keyboardType:    TextInputType.emailAddress,
                      controller:      _emailController,
                      textInputAction: TextInputAction.next,
                      validator:       AppValidators.email,
                    ),
                    const SizedBox(height: 20),
                    AppTextFormField(
                      label:           'Password',
                      hint:            'Enter your password',
                      prefixIcon:      Icons.lock,
                      obscureText:     true,
                      controller:      _passwordController,
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
              RememberMeRow(
                value:     _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
              ),
              const SizedBox(height: 20),
              AppGradientButton(
                label:     'Sign In',
                onPressed: _handleLogin,
                isLoading: state is LoginLoading,
              ),
              const SizedBox(height: 16),
              SignUpRedirect(
                onTap: () => context.pushNamed(AppRoutes.signUpScreen),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
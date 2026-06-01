import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_text_form_field.dart';
import 'package:transportation_app/core/widgets/auth_background.dart';
import 'package:transportation_app/features/login/presentation/cubit/password_cubit/password_cubit.dart';
import 'package:transportation_app/features/login/presentation/cubit/password_cubit/password_states.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<PasswordCubit>().forgotPassword(
          email: _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthBackground(
      child: BlocConsumer<PasswordCubit, PasswordStates>(
        listener: (context, state) {
          if (state is PasswordSuccess || state is PasswordFailure) {
            _bounceCtrl.forward(from: 0);
          }
        },
        builder: (context, state) {
          final isLoading = state is PasswordLoading;
          final isSuccess = state is PasswordSuccess;
          final isFailure = state is PasswordFailure;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Header icon + title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              ColorsManager.accentCyan.withValues(alpha: 0.3),
                              ColorsManager.cyanBlue.withValues(alpha: 0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: ColorsManager.accentCyan.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.envelopeOpenText,
                            color: ColorsManager.accentCyan,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.forgotPassword.replaceAll('?', ''),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.forgotPasswordSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ── Success state ──────────────────────────────────────────
                if (isSuccess)
                  ScaleTransition(
                    scale: _bounceAnim,
                    child: _FeedbackCard(
                      icon: FontAwesomeIcons.circleCheck,
                      iconColor: ColorsManager.successGreen,
                      borderColor: ColorsManager.successGreen,
                      bgColor: ColorsManager.successGreen.withValues(alpha: 0.08),
                      title: l10n.emailSentTitle,
                      message: l10n.emailSentMessage,
                    ),
                  ),

                // ── Error state ────────────────────────────────────────────
                if (state case final PasswordFailure f)
                  ScaleTransition(
                    scale: _bounceAnim,
                    child: _FeedbackCard(
                      icon: FontAwesomeIcons.circleExclamation,
                      iconColor: Colors.redAccent,
                      borderColor: Colors.redAccent,
                      bgColor: Colors.red.withValues(alpha: 0.08),
                      title: l10n.emailSendError,
                      message: f.message,
                    ),
                  ),

                // ── Form (hidden after success) ────────────────────────────
                if (!isSuccess) ...[
                  Form(
                    key: _formKey,
                    child: AppTextFormField(
                      label: l10n.emailLabel,
                      hint: l10n.emailHint,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: AppValidators.email,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.cyanBlue,
                        disabledBackgroundColor:
                            ColorsManager.cyanBlue.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.paperPlane,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  l10n.sendResetLink,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],

                // "Back to login" link (always shown after success)
                if (isSuccess) ...[
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: ColorsManager.accentCyan,
                        size: 16,
                      ),
                      label: Text(
                        l10n.backToLogin,
                        style: const TextStyle(
                          color: ColorsManager.accentCyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Feedback card widget ───────────────────────────────────────────────────────
class _FeedbackCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color bgColor;
  final String title;
  final String message;

  const _FeedbackCard({
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.bgColor,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, color: iconColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

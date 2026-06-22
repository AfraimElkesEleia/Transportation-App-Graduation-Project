import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/features/support/cubit/support_cubit.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // 1=Payment, 2=TripExperience, 3=AppBug, 4=AccountIssue, 5=Other
  int _selectedCategory = 1;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _animController.dispose();
    super.dispose();
  }

  List<_CategoryOption> _getCategories(AppLocalizations l10n) => [
    _CategoryOption(
      value: 1,
      label: l10n.issueCategoryPayment,
      icon: Icons.payment_outlined,
    ),
    _CategoryOption(
      value: 2,
      label: l10n.issueCategoryTrip,
      icon: Icons.directions_bus_outlined,
    ),
    _CategoryOption(
      value: 3,
      label: l10n.issueCategoryAppBug,
      icon: Icons.bug_report_outlined,
    ),
    _CategoryOption(
      value: 4,
      label: l10n.issueCategoryAccount,
      icon: Icons.manage_accounts_outlined,
    ),
    _CategoryOption(
      value: 5,
      label: l10n.issueCategoryOther,
      icon: Icons.help_outline,
    ),
  ];

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<SupportCubit>().submitTicket(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      issueCategory: _selectedCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = _getCategories(l10n);

    return BlocListener<SupportCubit, SupportState>(
      listener: (context, state) {
        if (state is SupportSuccess) {
          _showSuccessSheet(context, l10n);
        } else if (state is SupportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ErrorLocalizer.localize(context, state.message),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFD32F2F),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1628),
        appBar: _buildAppBar(l10n),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header illustration area
                  _buildHeader(l10n),
                  const SizedBox(height: 28),

                  // Category selector
                  _buildSectionLabel(l10n.issueCategoryLabel),
                  const SizedBox(height: 12),
                  _buildCategorySelector(categories),
                  const SizedBox(height: 24),

                  // Title field
                  _buildSectionLabel(l10n.issueTitleLabel),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _titleController,
                    hint: l10n.issueTitleHint,
                    icon: Icons.title_outlined,
                    maxLength: 200,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n.issueTitleRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Description field
                  _buildSectionLabel(l10n.issueDescriptionLabel),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _descController,
                    hint: l10n.issueDescriptionHint,
                    icon: Icons.description_outlined,
                    maxLines: 5,
                    maxLength: 1000,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n.issueDescriptionRequired;
                      }
                      if (v.trim().length < 10) {
                        return l10n.issueDescriptionTooShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  BlocBuilder<SupportCubit, SupportState>(
                    builder: (context, state) {
                      final isLoading = state is SupportLoading;
                      return _buildSubmitButton(l10n, isLoading);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: const Color(0xFF0A1628),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        l10n.reportIssueTitle,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2A3A), Color(0xFF0D2137)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withValues(alpha: 0.3),
                  Colors.cyan.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.cyan,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reportIssueHeaderTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.reportIssueHeaderSubtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildCategorySelector(List<_CategoryOption> categories) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {
        final isSelected = _selectedCategory == cat.value;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.cyan.withValues(alpha: 0.15)
                  : const Color(0xFF1A2A3A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.cyan : Colors.white12,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  cat.icon,
                  color: isSelected ? Colors.cyan : Colors.white54,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  cat.label,
                  style: TextStyle(
                    color: isSelected ? Colors.cyan : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: Colors.cyan.withValues(alpha: 0.7), size: 20)
            : null,
        counterStyle: const TextStyle(color: Colors.white38, fontSize: 11),
        filled: true,
        fillColor: const Color(0xFF1A2A3A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.cyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 14 : 0,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          disabledBackgroundColor: Colors.cyan.withValues(alpha: 0.4),
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
                  const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    l10n.issueSubmitBtn,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showSuccessSheet(BuildContext ctx, AppLocalizations l10n) {
    final navigator = Navigator.of(ctx);
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      builder: (_) => _SuccessSheet(l10n: l10n),
    ).then((_) => navigator.pop());
  }
}

// ── Success bottom sheet ───────────────────────────────────────────────────

class _SuccessSheet extends StatefulWidget {
  final AppLocalizations l10n;
  const _SuccessSheet({required this.l10n});

  @override
  State<_SuccessSheet> createState() => _SuccessSheetState();
}

class _SuccessSheetState extends State<_SuccessSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF112240),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.greenAccent,
                size: 56,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.issueSubmittedTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.issueSubmittedBody,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: Text(
                l10n.issueDone,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper model ───────────────────────────────────────────────────────────

class _CategoryOption {
  final int value;
  final String label;
  final IconData icon;
  const _CategoryOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}

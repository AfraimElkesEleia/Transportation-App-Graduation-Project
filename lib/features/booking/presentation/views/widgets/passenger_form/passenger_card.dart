import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_form_controllers.dart';

class PassengerCard extends StatefulWidget {
  const PassengerCard({
    super.key,
    required this.controllers,
    required this.isTrain,
    this.index,
    this.label,
    this.seatLabel,
    this.showEmail = true,
    this.requirePhone = true,
    this.showHeaderIcon = false,
    this.phoneInputFormatters,
    this.idInputFormatters,
  }) : assert(index != null || label != null);

  final PassengerFormControllers controllers;
  final bool isTrain;
  final int? index;
  final String? label;
  final String? seatLabel;
  final bool showEmail;
  final bool requirePhone;
  final bool showHeaderIcon;
  final List<TextInputFormatter>? phoneInputFormatters;
  final List<TextInputFormatter>? idInputFormatters;

  @override
  State<PassengerCard> createState() => _PassengerCardState();
}

class _PassengerCardState extends State<PassengerCard> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final title = widget.label ?? loc.passengerN('${widget.index}');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderDim, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PassengerCardHeader(
            title: title,
            seatLabel: widget.seatLabel,
            showIcon: widget.showHeaderIcon,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: widget.controllers.nameController,
            label: loc.fullName,
            icon: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? loc.requiredField : null,
          ),
          const SizedBox(height: 12),
          if (widget.isTrain) ...[
            DropdownButtonFormField<String>(
              initialValue: widget.controllers.selectedIdType,
              decoration: _inputDecoration(
                label: loc.idTypeLabel,
                icon: Icons.badge_outlined,
              ),
              dropdownColor: ColorsManager.surfaceDark,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: [
                DropdownMenuItem(
                  value: 'NationalId',
                  child: Text(loc.idTypeNationalId),
                ),
                DropdownMenuItem(
                  value: 'Passport',
                  child: Text(loc.idTypePassport),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    widget.controllers.selectedIdType = val;
                    widget.controllers.idController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: widget.controllers.idController,
              label: widget.controllers.selectedIdType == 'NationalId'
                  ? loc.idNumberLabel
                  : loc.passportNumberLabel,
              icon: Icons.credit_card_outlined,
              keyboardType: widget.controllers.selectedIdType == 'NationalId'
                  ? TextInputType.number
                  : TextInputType.text,
              inputFormatters: widget.idInputFormatters,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? loc.requiredField : null,
            ),
            const SizedBox(height: 12),
          ],
          _buildTextField(
            controller: widget.controllers.phoneController,
            label: loc.phoneNumberLabel,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: widget.phoneInputFormatters,
            validator: widget.requirePhone
                ? (v) =>
                      (v == null || v.trim().isEmpty) ? loc.requiredField : null
                : null,
          ),
          if (widget.showEmail) ...[
            const SizedBox(height: 12),
            _buildTextField(
              controller: widget.controllers.emailController,
              label: loc.emailOptional,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _inputDecoration(label: label, icon: icon),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: ColorsManager.textMuted, fontSize: 13),
      prefixIcon: Icon(icon, color: ColorsManager.textMuted, size: 20),
      filled: true,
      fillColor: ColorsManager.seatContainerBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorsManager.accentCyan),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _PassengerCardHeader extends StatelessWidget {
  const _PassengerCardHeader({
    required this.title,
    required this.showIcon,
    this.seatLabel,
  });

  final String title;
  final String? seatLabel;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
      style: const TextStyle(
        color: ColorsManager.accentCyan,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );

    if (showIcon) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorsManager.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: ColorsManager.accentCyan,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          titleWidget,
        ],
      );
    }

    if (seatLabel == null) return titleWidget;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        titleWidget,
        Text(
          seatLabel!,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

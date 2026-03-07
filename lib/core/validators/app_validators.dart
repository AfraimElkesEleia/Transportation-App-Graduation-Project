
class AppValidators {
  AppValidators._(); // Prevent instantiation

  // ─────────────────────────────────────────────
  // NAME FIELDS  (first / last / family)
  // ─────────────────────────────────────────────

  static String? _name(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required.';
    if (value.trim().length < 2) return '$fieldName must be at least 2 characters.';
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value.trim())) {
      return '$fieldName can only contain letters, spaces, hyphens, or apostrophes.';
    }
    return null;
  }

  static String? firstName(String? v)  => _name(v, fieldName: 'First name');
  static String? lastName(String? v)   => _name(v, fieldName: 'Last name');
  static String? familyName(String? v) => _name(v, fieldName: 'Family name');

  // ─────────────────────────────────────────────
  // EMAIL
  // ─────────────────────────────────────────────

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email address is required.';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Please enter a valid email address.';
    return null;
  }

  // ─────────────────────────────────────────────
  // PASSWORD
  // ─────────────────────────────────────────────

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Must contain an uppercase letter.';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Must contain a lowercase letter.';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Must contain a number.';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Must contain a special character (!@#\$%^&* …).';
    }
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) return 'Please confirm your password.';
    if (value != originalPassword) return 'Passwords do not match.';
    return null;
  }

  // ─────────────────────────────────────────────
  // PHONE NUMBER
  // ─────────────────────────────────────────────

  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required.';
    final stripped = value.replaceAll(RegExp(r'[\s\-().+]'), '');
    if (stripped.length < 7 || stripped.length > 15) {
      return 'Phone number must be between 7 and 15 digits.';
    }
    if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value.trim())) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  // ─────────────────────────────────────────────
  // NATIONAL ID  (optional — only validates if non-empty)
  // ─────────────────────────────────────────────

  /// Egyptian National ID: 14 digits starting with 2 or 3.
  /// Returns null (valid) when the field is left empty because it is optional.
  static String? nationalId(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!RegExp(r'^[23]\d{13}$').hasMatch(value.trim())) {
      return 'National ID must be 14 digits and start with 2 or 3.';
    }
    return null;
  }

  // ─────────────────────────────────────────────
  // DATE OF BIRTH
  // ─────────────────────────────────────────────

  static String? dateOfBirth(DateTime? value, {int minAge = 16}) {
    if (value == null) return 'Date of birth is required.';
    final today = DateTime.now();
    if (value.isAfter(today)) return 'Date of birth cannot be in the future.';
    final age = today.year - value.year -
        ((today.month < value.month ||
                (today.month == value.month && today.day < value.day))
            ? 1
            : 0);
    if (age < minAge) return 'You must be at least $minAge years old.';
    return null;
  }

  // ─────────────────────────────────────────────
  // GENERIC
  // ─────────────────────────────────────────────

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required.';
    return null;
  }

  // ─────────────────────────────────────────────
  // PASSWORD STRENGTH METER
  // ─────────────────────────────────────────────

  static PasswordStrength getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }
}

enum PasswordStrength { none, weak, medium, strong }

extension PasswordStrengthX on PasswordStrength {
  String get label {
    switch (this) {
      case PasswordStrength.none:   return '';
      case PasswordStrength.weak:   return 'Weak';
      case PasswordStrength.medium: return 'Medium';
      case PasswordStrength.strong: return 'Strong';
    }
  }

  int get colorValue {
    switch (this) {
      case PasswordStrength.none:   return 0x00000000;
      case PasswordStrength.weak:   return 0xFFE53935;
      case PasswordStrength.medium: return 0xFFFFA726;
      case PasswordStrength.strong: return 0xFF43A047;
    }
  }

  double get progress {
    switch (this) {
      case PasswordStrength.none:   return 0.0;
      case PasswordStrength.weak:   return 0.33;
      case PasswordStrength.medium: return 0.66;
      case PasswordStrength.strong: return 1.0;
    }
  }
}
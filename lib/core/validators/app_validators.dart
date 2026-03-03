
class AppValidators {
  AppValidators._(); // Prevent instantiation
  /// Validates standard email format.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required.';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }

    return null;
  }
  /// Validates password strength:
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  /// - At least one special character
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter.';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number.';
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  /// Validates that the confirm password matches the original.
  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != originalPassword) {
      return 'Passwords do not match.';
    }

    return null;
  }
  /// Validates international phone numbers.
  /// Supports formats: +201234567890 | 01234567890 | (123) 456-7890
  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }

    // Strip spaces, dashes, parentheses for raw digit check
    final stripped = value.replaceAll(RegExp(r'[\s\-().+]'), '');

    if (stripped.length < 7 || stripped.length > 15) {
      return 'Phone number must be between 7 and 15 digits.';
    }

    if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value.trim())) {
      return 'Please enter a valid phone number.';
    }

    return null;
  }
  /// Validates a full name (first + last, no numbers or special chars).
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required.';
    }

    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters.';
    }

    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens, or apostrophes.';
    }

    return null;
  }

  /// Validates that a required field is not empty.
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  /// Returns a [PasswordStrength] enum representing how strong the password is.
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
      case PasswordStrength.none:
        return '';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  /// Returns a color hex for UI display (use with Color(int)).
  int get colorValue {
    switch (this) {
      case PasswordStrength.none:
        return 0x00000000;
      case PasswordStrength.weak:
        return 0xFFE53935;   // Red
      case PasswordStrength.medium:
        return 0xFFFFA726;   // Orange
      case PasswordStrength.strong:
        return 0xFF43A047;   // Green
    }
  }

  /// Progress value from 0.0 to 1.0 for a LinearProgressIndicator.
  double get progress {
    switch (this) {
      case PasswordStrength.none:
        return 0.0;
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
    }
  }
}
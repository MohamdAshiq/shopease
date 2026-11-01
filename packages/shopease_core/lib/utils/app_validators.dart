// App Validators
abstract final class AppValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
  );

  // Validates email address
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validates password
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    if (value.trim().length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  // Validates confirm password
  static String? validateConfirmPassword(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Validates required text field
  static String? validateRequired(String? value, [String fieldName = 'field']) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  // Validates phone numbers
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  // Validates PIN code
  static String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a PIN / postal code';
    }
    final cleanCode = value.trim().replaceAll(' ', '');
    if (cleanCode.length < 5 || cleanCode.length > 10) {
      return 'Please enter a valid postal code';
    }
    return null;
  }

  // Validates minimum length for a named field
  static String? validateMinLength(
    String? value,
    int minLength, [
    String fieldName = 'field',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    if (value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  // Validates numeric values
  static String? validateNumber(String? value, [String fieldName = 'number']) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a $fieldName';
    }
    if (num.tryParse(value.trim()) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }
}

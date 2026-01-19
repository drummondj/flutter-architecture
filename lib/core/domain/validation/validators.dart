import 'package:validators/validators.dart' as v;

class Validators {
  // String validators
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? "This field"} is required';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value != null && !v.isLength(value, 0, max)) {
      return '${fieldName ?? "This field"} cannot exceed $max characters';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value != null && !v.isLength(value, min)) {
      return '${fieldName ?? "This field"} must be at least $min characters';
    }
    return null;
  }

  static String? lengthBetween(
    String? value,
    int min,
    int max, {
    String? fieldName,
  }) {
    if (value != null && !v.isLength(value, min, max)) {
      return '${fieldName ?? "This field"} must be between $min and $max characters';
    }
    return null;
  }

  // Numeric validators
  static String? greaterThan(num? value, num min, {String? fieldName}) {
    if (value != null && value <= min) {
      return '${fieldName ?? "This field"} must be greater than $min';
    }
    return null;
  }

  static String? lessThan(num? value, num max, {String? fieldName}) {
    if (value != null && value >= max) {
      return '${fieldName ?? "This field"} must be less than $max';
    }
    return null;
  }

  static String? range(num? value, num min, num max, {String? fieldName}) {
    if (value != null && (value < min || value > max)) {
      return '${fieldName ?? "This field"} must be between $min and $max';
    }
    return null;
  }

  // Collection validators
  static String? maxItems<T>(List<T>? items, int max, {String? fieldName}) {
    if (items != null && items.length > max) {
      return '${fieldName ?? "This field"} cannot have more than $max items';
    }
    return null;
  }

  static String? minItems<T>(List<T>? items, int min, {String? fieldName}) {
    if (items != null && items.length < min) {
      return '${fieldName ?? "This field"} must have at least $min items';
    }
    return null;
  }

  // Format validators (from validators package)
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!v.isEmail(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!v.isURL(value)) {
      return 'Invalid URL';
    }
    return null;
  }

  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    if (!v.isNumeric(value)) {
      return '${fieldName ?? "This field"} must be a number';
    }
    return null;
  }

  // Combinator
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }

  // Custom pattern
  static String? pattern(String? value, String pattern, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!v.matches(value, pattern)) {
      return message ?? 'Invalid format';
    }
    return null;
  }
}

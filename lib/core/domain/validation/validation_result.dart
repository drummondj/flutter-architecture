enum ValidationStatus { pass, fail }

class ValidationResult {
  final ValidationStatus status;
  List<String> errors;
  ValidationResult({required this.status, required this.errors});
}

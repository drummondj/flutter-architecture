import 'package:architecture/core/domain/validation/validation_result.dart';
import 'package:architecture/core/exceptions/user_exception.dart';

class ValidationException extends UserException {
  final ValidationResult validationResult;

  ValidationException({required super.message, required this.validationResult});
}

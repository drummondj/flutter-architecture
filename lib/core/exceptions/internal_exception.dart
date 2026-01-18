import 'package:architecture/core/exceptions/app_exception.dart';

class InternalException extends AppException {
  InternalException({required super.message, super.stackTrace, super.cause});
}

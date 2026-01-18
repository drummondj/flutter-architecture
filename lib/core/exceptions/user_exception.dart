import 'package:architecture/core/exceptions/app_exception.dart';

class UserException extends AppException {
  UserException({required super.message, super.stackTrace, super.cause});
}

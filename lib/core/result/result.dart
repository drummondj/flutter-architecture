import 'package:architecture/core/exceptions/app_exception.dart';
import 'package:architecture/core/exceptions/user_exception.dart';

/// Utility class that simplifies handling errors.
///
/// Return a [Result] from a function to indicate success or failure.
/// A [Result] is either an [Ok] with a value of type [T]
/// or an [Error] with an [AppException].
sealed class Result<T> {
  const Result();

  /// Creates an instance of Result containing a value
  factory Result.ok(T value) => Ok(value);

  /// Create an instance of Result containing an error
  factory Result.error(AppException error) => Error(error);
}

/// Subclass of Result for successful values
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  /// The returned value
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error(this.error);

  /// The returned error
  final AppException error;

  @override
  String toString() => 'Result<$T>.error($error)';

  String get sanitizedErrorMessage => (error is UserException)
      ? error.message
      : "Something went wrong, please try again";
}

extension ResultExtension<T> on Result<T> {
  /// Get the value or null
  T? getOrNull() => switch (this) {
    Ok(:final value) => value,
    Error() => null,
  };

  /// Get the exception or null
  Exception? exceptionOrNull() => switch (this) {
    Ok() => null,
    Error(:final error) => error,
  };

  /// Map over success value
  Result<U> map<U>(U Function(T) transform) => switch (this) {
    Ok(:final value) => Result.ok(transform(value)),
    Error(:final error) => Result.error(error),
  };

  /// Chain Results (flatMap)
  Future<Result<U>> flatMapAsync<U>(
    Future<Result<U>> Function(T) transform,
  ) async => switch (this) {
    Ok(:final value) => transform(value),
    Error(:final error) => Result.error(error),
  };
}

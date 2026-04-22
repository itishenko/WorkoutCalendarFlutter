class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

extension ReadableErrorMessage on Object {
  String get readableMessage {
    if (this is AppException) {
      return (this as AppException).message;
    }

    return 'Something went wrong. Please try again.';
  }
}

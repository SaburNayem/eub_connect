enum AppFailureType {
  backendNotConfigured,
  authentication,
  forbidden,
  notFound,
  validation,
  network,
  server,
  unknown,
}

class AppFailure {
  const AppFailure({
    required this.message,
    this.type = AppFailureType.unknown,
    this.detail,
  });

  final String message;
  final AppFailureType type;
  final Object? detail;

  @override
  String toString() => message;
}

class AppResult<T> {
  const AppResult._({this.data, this.failure});

  const AppResult.success(T data) : this._(data: data);

  const AppResult.failure(AppFailure failure) : this._(failure: failure);

  final T? data;
  final AppFailure? failure;

  bool get isSuccess => failure == null;

  T get requireData {
    final value = data;
    if (value == null) {
      throw StateError('Result does not contain data');
    }
    return value;
  }
}

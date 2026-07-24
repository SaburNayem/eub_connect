class AsyncValue<T> {
  const AsyncValue._({required this.isLoading, this.data, this.error});

  const AsyncValue.loading() : this._(isLoading: true);

  const AsyncValue.data(T data) : this._(isLoading: false, data: data);

  const AsyncValue.error(String error) : this._(isLoading: false, error: error);

  final bool isLoading;
  final T? data;
  final String? error;

  bool get hasError => error != null;
}

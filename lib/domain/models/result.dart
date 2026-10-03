/// Result wrapper representing either Success([data]) or Failure([error]).
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        Failure() => null,
      };

  String? get errorOrNull => switch (this) {
        Success() => null,
        Failure(message: final m) => m,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, dynamic error) failure,
  }) {
    return switch (this) {
      Success(data: final d) => success(d),
      Failure(message: final m, error: final e) => failure(m, e),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.message, [this.error]);
  final String message;
  final dynamic error;
}

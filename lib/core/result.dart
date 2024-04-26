sealed class Result<T, E> {}

class Success<T, E> extends Result<T, E> {
  Success(this.value);

  final T value;
}

class Err<T, E> extends Result<T, E> {
  Err(this.value);

  final E value;
}

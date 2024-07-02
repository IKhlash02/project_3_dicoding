abstract class UiState<T> {
  const UiState();
}

class Loading<T> extends UiState<T> {
  const Loading();
}

class Success<T> extends UiState<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends UiState<T> {
  final String errorMessage;
  const Error(this.errorMessage);
}

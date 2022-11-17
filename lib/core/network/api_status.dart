class Success<T> {
  T response;
  Success({required this.response});
}

class Failure {
  int code;
  String error;
  Failure({required this.code, required this.error});
}

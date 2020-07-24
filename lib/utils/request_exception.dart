class RequestException implements Exception {
  String errorKey;
  String message;
  RequestException(this.errorKey, this.message);
}

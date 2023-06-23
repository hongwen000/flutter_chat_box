class DartOpenaiException implements Exception {
  String cause;
  DartOpenaiException(this.cause);
}
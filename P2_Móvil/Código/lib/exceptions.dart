class ModelException implements Exception {
  final String message;

  ModelException(this.message);

  @override
  String toString() => "ModelException: $message";
}

class InvalidInputException implements Exception {
  final String message;
  InvalidInputException(this.message);

  @override
  String toString() => "InvalidInputException: $message";
}

 class OutOfTimeException implements Exception {
  final String message;
  OutOfTimeException(this.message);

  @override
  String toString() => "OutOfTimeException: $message";
}
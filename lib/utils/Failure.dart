/// This is a custom Exception class used for throwing excceptions with error messages that are human readable

class Failure {
  /// The message to be displayed to the user
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
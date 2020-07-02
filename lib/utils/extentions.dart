import 'package:dartz/dartz.dart';
import 'Failure.dart';

/// Converts the [Object] returned by attempt() of [Task] to an instance of [Failure], or propogates the exception as it is
extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return this.map(
      (either) => either.leftMap((obj) {
        try {
          return obj as Failure;
        } catch (e) {
          throw obj;
        }
      }),
    );
  }
}
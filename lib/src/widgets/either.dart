import '../generated/dart_bindings.dart' as sdk;

typedef EitherDirectoryObjOrSuggest = Either<sdk.DirectoryObject, sdk.Suggest>;
typedef DirectoryUIObj = Left<sdk.DirectoryObject, sdk.Suggest>;
typedef SuggestUIObj = Right<sdk.DirectoryObject, sdk.Suggest>;

abstract class Either<L, R> {
  const Either();

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);
}

class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onLeft(value);
  }
}

class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onRight(value);
  }
}

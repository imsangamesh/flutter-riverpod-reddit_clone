import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/errors/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureVoid = FutureEither<void>;

typedef DataMap = Map<String, dynamic>;

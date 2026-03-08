import 'package:transportation_app/core/utils/typedef.dart';

abstract class Usecase<T, Params> {
  ResultFuture<T> call(Params params);
}

class NoParams {}

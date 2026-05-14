import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';

class CancelCartItemUsecase {
  final BookingRemoteDatasource _datasource;

  CancelCartItemUsecase(this._datasource);

  Future<Either<Failure, void>> call(int bookingId) async {
    try {
      await _datasource.cancelCartItem(bookingId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection'));
    } catch (e) {
      return const Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }
}

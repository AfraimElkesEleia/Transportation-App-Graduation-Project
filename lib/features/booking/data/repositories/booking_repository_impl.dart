import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';
import 'package:transportation_app/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource remoteDatasource;

  BookingRepositoryImpl({required this.remoteDatasource});

  @override
  ResultFuture<CartEntity?> getCart() async {
    try {
      return Right(await remoteDatasource.getCart());
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    }
  }

  @override
  ResultFuture<SeatMapEntity> getSeatMap(int occurrenceId) async {
    try {
      return Right(await remoteDatasource.getSeatMap(occurrenceId));
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    }
  }

  @override
  ResultFuture<void> addToCart(Map<String, dynamic> payload) async {
    try {
      await remoteDatasource.addToCart(payload);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    }
  }

  @override
  ResultFuture<void> checkout({int pointsToRedeem = 0}) async {
    try {
      await remoteDatasource.checkout(pointsToRedeem: pointsToRedeem);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    }
  }

  @override
  ResultFuture<void> cancelCartItem(int bookingId) async {
    try {
      await remoteDatasource.cancelCartItem(bookingId);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    }
  }
}

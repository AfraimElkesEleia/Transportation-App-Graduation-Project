import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/my_tickets/data/datasources/my_tickets_remote_datasource.dart';
import 'package:transportation_app/features/my_tickets/domain/repositories/my_tickets_repository.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/features/profile/domain/entities/wallet_transaction_entity.dart';

class MyTicketsRepositoryImpl implements MyTicketsRepository {
  final MyTicketsRemoteDatasource remoteDatasource;
  MyTicketsRepositoryImpl({required this.remoteDatasource});

  @override
  ResultFuture<List<TicketEntity>> getMyTickets() async {
    try {
      return Right(await remoteDatasource.getMyTickets());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    }
  }

  @override
  ResultFuture<double> getWalletBalance() async {
    try {
      return Right(await remoteDatasource.getWalletBalance());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    }
  }

  @override
  ResultFuture<List<WalletTransactionEntity>> getWalletHistory() async {
    try {
      return Right(await remoteDatasource.getWalletHistory());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    }
  }

  @override
  ResultVoid depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    try {
      await remoteDatasource.depositToWallet(
        amount: amount,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    }
  }
}

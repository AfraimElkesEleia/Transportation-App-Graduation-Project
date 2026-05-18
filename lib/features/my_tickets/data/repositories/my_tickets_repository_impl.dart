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

  @override
  ResultFuture<Map<String, dynamic>> getActiveListings({
    int pageNumber = 1,
    int pageSize = 10,
    String? originGovernorate,
    String? destinationGovernorate,
    String? travelDate,
  }) async {
    try {
      return Right(await remoteDatasource.getActiveListings(
        pageNumber: pageNumber,
        pageSize: pageSize,
        originGovernorate: originGovernorate,
        destinationGovernorate: destinationGovernorate,
        travelDate: travelDate,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    }
  }

  @override
  ResultVoid listTicket({
    required int bookingId,
    required double askingPrice,
  }) async {
    try {
      await remoteDatasource.listTicket(
        bookingId: bookingId,
        askingPrice: askingPrice,
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

  @override
  ResultVoid buyTicket({required int listingId, required List<Map<String, dynamic>> passengers}) async {
    try {
      await remoteDatasource.buyTicket(listingId: listingId, passengers: passengers);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    }
  }

  @override
  ResultVoid cancelListing({required int listingId}) async {
    try {
      await remoteDatasource.cancelListing(listingId: listingId);
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

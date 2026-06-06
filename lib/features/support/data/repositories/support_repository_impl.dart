import 'package:dartz/dartz.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/support/data/datasources/support_remote_datasource.dart';
import 'package:transportation_app/features/support/domain/entities/support_ticket_entity.dart';
import 'package:transportation_app/features/support/domain/repositories/support_repository.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDatasource remoteDatasource;

  SupportRepositoryImpl({required this.remoteDatasource});

  @override
  ResultFuture<void> submitTicket({
    required String title,
    required String description,
    required int issueCategory,
  }) async {
    try {
      await remoteDatasource.submitTicket(
        title: title,
        description: description,
        issueCategory: issueCategory,
      );
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection. Please try again.'));
    } on UnauthorizedException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } catch (_) {
      return const Left(ServerFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  ResultFuture<List<SupportTicketEntity>> getTickets() async {
    try {
      return Right(await remoteDatasource.getTickets());
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection. Please try again.'));
    } on UnauthorizedException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, errors: e.errors));
    } catch (_) {
      return const Left(ServerFailure(message: 'An unexpected error occurred.'));
    }
  }
}

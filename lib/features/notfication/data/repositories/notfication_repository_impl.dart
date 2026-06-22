import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/notfication/data/datasources/notfication_remote_datasource.dart';
import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';
import 'package:transportation_app/features/notfication/domain/repositories/notfication_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotficationRemoteDatasource remoteDatasource;

  NotificationRepositoryImpl({required this.remoteDatasource});

  @override
  ResultFuture<List<AppNotification>> getNotifications() async {
    try {
      return Right(await remoteDatasource.getNotifications());
    } on DioException catch (e) {
      return Left(ServerFailure(message: _messageFromDio(e)));
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to load notifications'));
    }
  }

  @override
  ResultFuture<void> markRead(String id) async {
    try {
      await remoteDatasource.markRead(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: _messageFromDio(e)));
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to mark notification read'));
    }
  }

  @override
  ResultFuture<void> deleteNotification(String id) async {
    try {
      await remoteDatasource.deleteNotification(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: _messageFromDio(e)));
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to delete notification'));
    }
  }

  @override
  ResultFuture<void> markAllRead() async {
    try {
      await remoteDatasource.markAllRead();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: _messageFromDio(e)));
    } catch (_) {
      return const Left(ServerFailure(message: 'Failed to mark notifications read'));
    }
  }

  String _messageFromDio(DioException e) {
    final body = e.response?.data as Map<String, dynamic>?;
    return body?['message'] as String? ?? 'Server error. Please try again.';
  }
}

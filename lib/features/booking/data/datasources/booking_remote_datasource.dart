import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/booking/data/models/seat_model.dart';
import 'package:transportation_app/features/booking/data/models/cart_model.dart';

abstract class BookingRemoteDatasource {
  Future<CartResponseModel?> getCart();
  Future<SeatMapModel> getSeatMap(int occurrenceId);
  Future<void>         addToCart(Map<String, dynamic> payload);
  Future<void>         checkout({int pointsToRedeem = 0});
}

class BookingRemoteDatasourceImpl implements BookingRemoteDatasource {
  final Dio dio;
  BookingRemoteDatasourceImpl({required this.dio});

  @override
  Future<CartResponseModel?> getCart() async {
    try {
      final res = await dio.get('/Bookings/cart');
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Failed to load cart');
      }
      if (body['data'] == null) return null;
      return CartResponseModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<SeatMapModel> getSeatMap(int occurrenceId) async {
    try {
      final res  = await dio.get(ApiConstants.seatMap(occurrenceId));
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
            message: body['message'] ?? 'Failed to load seat map');
      }
      return SeatMapModel.fromJson(
          body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<void> addToCart(Map<String, dynamic> payload) async {
    try {
      final res  = await dio.post(ApiConstants.cartAdd, data: payload);
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        final errors = (body['errors'] as List<dynamic>?)
                ?.map((e) => e.toString()).toList() ?? [];
        throw ServerException(
            message: body['message'] ?? 'Failed to add to cart',
            errors:  errors);
      }
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<void> checkout({int pointsToRedeem = 0}) async {
    try {
      final res  = await dio.post(
        ApiConstants.checkout,
        data: {
          'paymentMethod': 'Wallet',
          'pointsToRedeem': pointsToRedeem,
        },
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
            message: body['message'] ?? 'Checkout failed');
      }
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  Never _handleDio(DioException e) {
    if (e.type == DioExceptionType.connectionError   ||
        e.type == DioExceptionType.receiveTimeout    ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException();
    }
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException(
          message: 'Please login to continue.');
    }
    final body   = e.response?.data as Map<String, dynamic>?;
    final errors = (body?['errors'] as List<dynamic>?)
            ?.map((e) => e.toString()).toList() ?? [];
    throw ServerException(
      message:    body?['message'] ?? 'Server error',
      errors:     errors,
      statusCode: e.response?.statusCode,
    );
  }
}
import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/profile/data/models/profile_model.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/features/profile/domain/entities/wallet_transaction_entity.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String familyName,
    required String email,
    required String phoneNumber,
  });
  Future<String> uploadProfilePicture({required String filePath});
  Future<void> revokeToken({required String refreshToken});
  Future<void> depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  });
  Future<List<TicketEntity>> getMyTickets();
  Future<List<WalletTransactionEntity>> getWalletHistory();
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio dio;
  ProfileRemoteDatasourceImpl({required this.dio});
  @override
  Future<ProfileModel> getProfile() async {
    try {
      final res = await dio.get(ApiConstants.userMe);
      final body = res.data as Map<String, dynamic>;
      print('📦 [Profile] raw data: ${body['data']}');
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to load profile',
        );
      }
      return ProfileModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String familyName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final res = await dio.put(
        ApiConstants.userMe,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'familyName': familyName,
          'email': email,
          'phoneNumber': phoneNumber,
        },
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        final errors =
            (body['errors'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        throw ServerException(
          message: body['message'] ?? 'Update failed',
          errors: errors,
        );
      }
      return await getProfile();
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<String> uploadProfilePicture({required String filePath}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final res = await dio.post(
        ApiConstants.userProfilePicture,
        data: formData,
      );

      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Upload failed');
      }

      final data = body['data'] as Map<String, dynamic>;
      final rawUrl = data['profilePictureUrl'] as String;
      final fullUrl = rawUrl.startsWith('http')
          ? rawUrl
          : 'http://rehlabussines-001-site1.anytempurl.com/$rawUrl';
      return fullUrl;
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<void> revokeToken({required String refreshToken}) async {
    try {
      await dio.post(ApiConstants.revoke, data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401)
        return;
      _handleDio(e);
    }
  }

  @override
  Future<void> depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    try {
      final res = await dio.post(
        ApiConstants.walletDeposit,
        data: {
          'amount': amount,
          'mockCardNumber': cardNumber,
          'expiryDate': expiryDate,
          'cvv': cvv,
        },
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Deposit failed');
      }
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<List<TicketEntity>> getMyTickets() async {
    try {
      final res = await dio.get(ApiConstants.myTickets);
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Failed to load tickets');
      }
      final list = (body['data'] as List<dynamic>? ?? []);
      return list.map((e) => _parseTicket(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  TicketEntity _parseTicket(Map<String, dynamic> json) {
    final passengers = (json['passengers'] as List<dynamic>? ?? [])
        .map((p) => TicketPassengerEntity(
              passengerId: p['passengerId'] as int? ?? p['id'] as int? ?? 0,
              name: p['name'] as String? ?? p['passengerName'] as String? ?? 'Unknown',
              idNumber: p['idNumber'] as String? ?? 'N/A',
              seatNumber: p['seatNumber']?.toString() ?? 'N/A',
            ))
        .toList();
    return TicketEntity(
      bookingId: json['bookingId'] as int,
      userId: json['userId'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      totalPrice: (json['totalPrice'] as num).toDouble(),
      seatsBooked: json['seatsBooked'] as int? ?? 1,
      bookingDate: DateTime.tryParse(json['bookingDate'] as String? ?? '') ?? DateTime.now(),
      agencyName: json['agencyName'] as String? ?? '',
      className: json['className'] as String? ?? '',
      isMarketplacePurchase: json['isMarketplacePurchase'] as bool? ?? false,
      originGovernorate: json['originGovernorate'] as String? ?? 'Cairo',
      originStation: json['originStation'] as String? ?? '',
      destinationGovernorate: json['destinationGovernorate'] as String? ?? 'Alexandria',
      destinationStation: json['destinationStation'] as String? ?? '',
      boardingTime: DateTime.tryParse(json['boardingTime'] as String? ?? '') ?? DateTime.now(),
      dropoffTime: DateTime.tryParse(json['dropoffTime'] as String? ?? '') ?? DateTime.now(),
      passengers: passengers,
    );
  }

  @override
  Future<List<WalletTransactionEntity>> getWalletHistory() async {
    try {
      final res = await dio.get('/Wallet/history');
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Failed to load history');
      }
      final list = (body['data'] as List<dynamic>? ?? []);
      return list.map((e) {
        final json = e as Map<String, dynamic>;
        return WalletTransactionEntity(
          id: json['id'] as int,
          amount: (json['amount'] as num).toDouble(),
          type: json['type'] as String? ?? '',
          description: json['description'] as String? ?? '',
          bookingId: json['bookingId'] as int?,
          createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        );
      }).toList();
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  Never _handleDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException();
    }
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException(
        message: 'Session expired. Please login again.',
      );
    }
    final body = e.response?.data as Map<String, dynamic>?;
    final errors =
        (body?['errors'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    throw ServerException(
      message: body?['message'] ?? 'Server error',
      errors: errors,
      statusCode: e.response?.statusCode,
    );
  }
}

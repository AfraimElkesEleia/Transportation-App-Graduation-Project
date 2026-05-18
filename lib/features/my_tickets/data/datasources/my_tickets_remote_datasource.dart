import 'package:dio/dio.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/features/profile/domain/entities/wallet_transaction_entity.dart';

abstract class MyTicketsRemoteDatasource {
  Future<List<TicketEntity>> getMyTickets();
  Future<double> getWalletBalance();
  Future<List<WalletTransactionEntity>> getWalletHistory();
  Future<void> depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  });
  Future<Map<String, dynamic>> getActiveListings({
    int pageNumber = 1,
    int pageSize = 10,
    String? originGovernorate,
    String? destinationGovernorate,
    String? travelDate,
  });
  Future<void> listTicket({
    required int bookingId,
    required double askingPrice,
  });
  Future<void> buyTicket({required int listingId, required List<Map<String, dynamic>> passengers});
  Future<void> cancelListing({required int listingId});
}

class MyTicketsRemoteDatasourceImpl implements MyTicketsRemoteDatasource {
  final Dio dio;
  MyTicketsRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<TicketEntity>> getMyTickets() async {
    try {
      final res = await dio.get(ApiConstants.myTickets);
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to load tickets',
        );
      }
      final list = (body['data'] as List<dynamic>? ?? []);
      return list.map((e) => _parseTicket(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<double> getWalletBalance() async {
    try {
      final res = await dio.get(ApiConstants.userMe);
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to load balance',
        );
      }
      final data = body['data'] as Map<String, dynamic>? ?? {};
      return (data['walletBalance'] as num? ?? 0).toDouble();
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<List<WalletTransactionEntity>> getWalletHistory() async {
    try {
      final res = await dio.get('/Wallet/history');
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to load history',
        );
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
          createdAt:
              DateTime.tryParse(json['createdAt'] as String? ?? '') ??
              DateTime.now(),
        );
      }).toList();
    } on DioException catch (e) {
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
  Future<Map<String, dynamic>> getActiveListings({
    int pageNumber = 1,
    int pageSize = 10,
    String? originGovernorate,
    String? destinationGovernorate,
    String? travelDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };
      if (originGovernorate != null && originGovernorate.isNotEmpty)
        queryParams['originGovernorate'] = originGovernorate;
      if (destinationGovernorate != null && destinationGovernorate.isNotEmpty)
        queryParams['destinationGovernorate'] = destinationGovernorate;
      if (travelDate != null && travelDate.isNotEmpty)
        queryParams['travelDate'] = travelDate;

      final res = await dio.get(
        ApiConstants.marketplaceActive,
        queryParameters: queryParams,
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to load listings',
        );
      }
      return body['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<void> listTicket({
    required int bookingId,
    required double askingPrice,
  }) async {
    try {
      final res = await dio.post(
        ApiConstants.marketplaceList,
        data: {'bookingId': bookingId, 'askingPrice': askingPrice},
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to list ticket',
        );
      }
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<void> buyTicket({required int listingId, required List<Map<String, dynamic>> passengers}) async {
    try {
      final res = await dio.post('${ApiConstants.marketplaceBuy}/$listingId', data: {'passengers': passengers});
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(message: body['message'] ?? 'Purchase failed');
      }
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  @override
  Future<void> cancelListing({required int listingId}) async {
    try {
      final res = await dio.post(
        '${ApiConstants.marketplaceCancel}/$listingId',
      );
      final body = res.data as Map<String, dynamic>;
      if (body['success'] != true) {
        throw ServerException(
          message: body['message'] ?? 'Failed to cancel listing',
        );
      }
    } on DioException catch (e) {
      _handleDio(e);
    }
  }

  TicketEntity _parseTicket(Map<String, dynamic> json) {
    final passengers = (json['passengers'] as List<dynamic>? ?? [])
        .map(
          (p) => TicketPassengerEntity(
            passengerId: p['passengerId'] as int? ?? p['id'] as int? ?? 0,
            name: p['name'] as String? ?? '',
            idNumber: p['idNumber'] as String? ?? '',
            seatNumber: p['seatNumber'] as String? ?? '',
          ),
        )
        .toList();
    return TicketEntity(
      bookingId: json['bookingId'] as int,
      userId: json['userId'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      totalPrice: (json['totalPrice'] as num).toDouble(),
      seatsBooked: json['seatsBooked'] as int? ?? 1,
      bookingDate:
          DateTime.tryParse(json['bookingDate'] as String? ?? '') ??
          DateTime.now(),
      agencyName: json['agencyName'] as String? ?? '',
      className: json['className'] as String? ?? '',
      originGovernorate: json['originGov'] as String? ?? 'Cairo',
      originStation: json['originStation'] as String? ?? '',
      destinationGovernorate: json['destinationGov'] as String? ?? 'Alexandria',
      destinationStation: json['destinationStation'] as String? ?? '',
      boardingTime:
          DateTime.tryParse(json['boardingTime'] as String? ?? '') ??
          DateTime.now(),
      dropoffTime:
          DateTime.tryParse(json['dropoffTime'] as String? ?? '') ??
          DateTime.now(),
      isMarketplacePurchase: json['isMarketplacePurchase'] as bool? ?? false,
      isOfferedForResale: json['isOfferedForResale'] as bool? ?? false,
      marketplaceListingId:
          json['activeListingId'] as int? ??
          json['marketplaceListingId'] as int? ??
          json['listingId'] as int?,
      passengers: passengers,
    );
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

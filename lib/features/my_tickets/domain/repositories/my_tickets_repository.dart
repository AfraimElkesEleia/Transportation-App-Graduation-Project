import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/features/profile/domain/entities/wallet_transaction_entity.dart';

abstract class MyTicketsRepository {
  ResultFuture<List<TicketEntity>> getMyTickets();
  ResultFuture<double> getWalletBalance();
  ResultFuture<List<WalletTransactionEntity>> getWalletHistory();
  ResultVoid depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  });

  ResultFuture<Map<String, dynamic>> getActiveListings({
    int pageNumber = 1,
    int pageSize = 10,
    String? originGovernorate,
    String? destinationGovernorate,
    String? travelDate,
  });
  ResultVoid listTicket({required int bookingId, required double askingPrice});
  ResultVoid buyTicket({required int listingId});
  ResultVoid cancelListing({required int listingId});
}

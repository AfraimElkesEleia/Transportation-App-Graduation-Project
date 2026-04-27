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
}

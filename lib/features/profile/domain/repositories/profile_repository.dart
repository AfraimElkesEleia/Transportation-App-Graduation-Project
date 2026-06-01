import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/features/profile/domain/entities/wallet_transaction_entity.dart';

abstract class ProfileRepository {
  ResultFuture<ProfileEntity> getProfile();
  ResultFuture<ProfileEntity> updateProfile({
    required String firstName,
    required String lastName,
    required String familyName,
    required String email,
    required String phoneNumber,
  });
  ResultFuture<String> uploadProfilePicture({required String filePath});
  ResultVoid depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  });
  ResultFuture<List<TicketEntity>> getMyTickets();
  ResultFuture<List<WalletTransactionEntity>> getWalletHistory();
  ResultVoid logout();
  ResultVoid updateLanguage({required String languageCode});
}
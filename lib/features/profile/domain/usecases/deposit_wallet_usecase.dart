import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';

class DepositWalletParams {
  final double amount;
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  DepositWalletParams({
    required this.amount,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });
}

class DepositWalletUseCase implements Usecase<void, DepositWalletParams> {
  final ProfileRepository repository;

  DepositWalletUseCase(this.repository);

  @override
  ResultFuture<void> call(DepositWalletParams params) async {
    return await repository.depositToWallet(
      amount: params.amount,
      cardNumber: params.cardNumber,
      expiryDate: params.expiryDate,
      cvv: params.cvv,
    );
  }
}

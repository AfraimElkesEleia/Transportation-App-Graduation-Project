import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/my_tickets/domain/repositories/my_tickets_repository.dart';
import 'my_tickets_states.dart';

class MyTicketsCubit extends Cubit<MyTicketsState> {
  final MyTicketsRepository repository;

  // Cached values so the UI can always show something while loading
  double _cachedBalance = 0.0;
  double get cachedBalance => _cachedBalance;

  MyTicketsCubit({required this.repository}) : super(MyTicketsInitial());

  // ── Load everything at once on screen open ────────────────────────
  Future<void> loadAll() async {
    await Future.wait([fetchTickets(), fetchWalletBalance()]);
  }

  // ── Tickets ───────────────────────────────────────────────────────
  Future<void> fetchTickets() async {
    emit(TicketsLoadingState());
    final result = await repository.getMyTickets();
    result.fold(
      (failure) => emit(TicketsErrorState(failure.message)),
      (tickets) => emit(TicketsLoadedState(tickets)),
    );
  }

  // ── Wallet balance ────────────────────────────────────────────────
  Future<void> fetchWalletBalance() async {
    emit(WalletBalanceLoadingState());
    final result = await repository.getWalletBalance();
    result.fold(
      (failure) => emit(WalletBalanceErrorState(failure.message)),
      (balance) {
        _cachedBalance = balance;
        emit(WalletBalanceLoadedState(balance));
      },
    );
  }

  // ── Wallet history ────────────────────────────────────────────────
  Future<void> fetchWalletHistory() async {
    emit(WalletHistoryLoadingState());
    final result = await repository.getWalletHistory();
    result.fold(
      (failure) => emit(WalletHistoryErrorState(failure.message)),
      (txns) => emit(WalletHistoryLoadedState(txns)),
    );
  }

  // ── Deposit ───────────────────────────────────────────────────────
  Future<void> depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    emit(WalletDepositingState());
    final result = await repository.depositToWallet(
      amount: amount,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
    );
    result.fold(
      (failure) => emit(WalletDepositErrorState(failure.message)),
      (_) async {
        // Reload balance after successful deposit
        final balResult = await repository.getWalletBalance();
        final newBal = balResult.fold((_) => _cachedBalance + amount, (b) {
          _cachedBalance = b;
          return b;
        });
        emit(WalletDepositedState(newBal));
      },
    );
  }
}

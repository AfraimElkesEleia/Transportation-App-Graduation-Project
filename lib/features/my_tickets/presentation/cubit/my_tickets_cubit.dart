import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/my_tickets/domain/repositories/my_tickets_repository.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'my_tickets_states.dart';

class MyTicketsCubit extends Cubit<MyTicketsState> {
  final MyTicketsRepository repository;

  // Cached values so the UI can always show something while loading
  double _cachedBalance = 0.0;
  double get cachedBalance => _cachedBalance;

  // Cache the last successfully loaded tickets so intermediate states
  // (e.g. marketplace listing) don't wipe the ticket list from the UI.
  List<TicketEntity> _cachedTickets = [];
  List<TicketEntity> get cachedTickets => _cachedTickets;

  MyTicketsCubit({required this.repository}) : super(MyTicketsInitial());

  // ── Load everything at once on screen open ────────────────────────
  Future<void> loadAll() async {
    await Future.wait([fetchTickets(), fetchWalletBalance()]);
  }

  // ── Tickets ───────────────────────────────────────────────────────
  Future<void> fetchTickets() async {
    emit(TicketsLoadingState());
    final result = await repository.getMyTickets();
    if (isClosed) return;
    result.fold(
      (failure) => emit(TicketsErrorState(failure.message)),
      (tickets) {
        _cachedTickets = tickets;
        emit(TicketsLoadedState(tickets));
      },
    );
  }

  // ── Wallet balance ────────────────────────────────────────────────
  Future<void> fetchWalletBalance() async {
    emit(WalletBalanceLoadingState());
    final result = await repository.getWalletBalance();
    if (isClosed) return;
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
    if (isClosed) return;
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
    if (isClosed) return;
    result.fold(
      (failure) => emit(WalletDepositErrorState(failure.message)),
      (_) async {
        // Reload balance after successful deposit
        final balResult = await repository.getWalletBalance();
        if (isClosed) return;
        final newBal = balResult.fold((_) => _cachedBalance + amount, (b) {
          _cachedBalance = b;
          return b;
        });
        emit(WalletDepositedState(newBal));
      },
    );
  }

  // ── Refund ────────────────────────────────────────────────────────
  Future<void> requestRefund({required int bookingId}) async {
    emit(RefundRequestingState());
    final result = await repository.requestRefund(bookingId: bookingId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(RefundRequestErrorState(failure.message)),
      (_) => emit(RefundRequestedState()),
    );
  }
}

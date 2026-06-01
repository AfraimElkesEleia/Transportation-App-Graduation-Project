import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/features/profile/domain/entities/wallet_transaction_entity.dart';

abstract class MyTicketsState extends Equatable {
  const MyTicketsState();
  @override
  List<Object?> get props => [];
}

class MyTicketsInitial extends MyTicketsState {}

// ── Tickets states ───────────────────────────────────────────────────
class TicketsLoadingState extends MyTicketsState {}

class TicketsLoadedState extends MyTicketsState {
  final List<TicketEntity> tickets;
  const TicketsLoadedState(this.tickets);
  @override
  List<Object?> get props => [tickets];
}

class TicketsErrorState extends MyTicketsState {
  final String message;
  const TicketsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Wallet balance states ─────────────────────────────────────────────
class WalletBalanceLoadingState extends MyTicketsState {}

class WalletBalanceLoadedState extends MyTicketsState {
  final double balance;
  const WalletBalanceLoadedState(this.balance);
  @override
  List<Object?> get props => [balance];
}

class WalletBalanceErrorState extends MyTicketsState {
  final String message;
  const WalletBalanceErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Wallet history states ─────────────────────────────────────────────
class WalletHistoryLoadingState extends MyTicketsState {}

class WalletHistoryLoadedState extends MyTicketsState {
  final List<WalletTransactionEntity> transactions;
  const WalletHistoryLoadedState(this.transactions);
  @override
  List<Object?> get props => [transactions];
}

class WalletHistoryErrorState extends MyTicketsState {
  final String message;
  const WalletHistoryErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Deposit states ────────────────────────────────────────────────────
class WalletDepositingState extends MyTicketsState {}

class WalletDepositedState extends MyTicketsState {
  final double newBalance;
  const WalletDepositedState(this.newBalance);
  @override
  List<Object?> get props => [newBalance];
}

class WalletDepositErrorState extends MyTicketsState {
  final String message;
  const WalletDepositErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Refund states ─────────────────────────────────────────────────────
class RefundRequestingState extends MyTicketsState {}

class RefundRequestedState extends MyTicketsState {}

class RefundRequestErrorState extends MyTicketsState {
  final String message;
  const RefundRequestErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

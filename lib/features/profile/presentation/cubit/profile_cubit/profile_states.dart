import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/features/profile/domain/entities/wallet_transaction_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial  extends ProfileState {}
class ProfileLoading  extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  const ProfileLoaded(this.profile);
  @override
  List<Object> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object> get props => [message];
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;
  const ProfileUpdateSuccess(this.profile);
  @override
  List<Object> get props => [profile];
}

class ProfileUpdateFailure extends ProfileState {
  final String       message;
  final List<String> errors;
  const ProfileUpdateFailure({required this.message, this.errors = const []});
  @override
  List<Object> get props => [message, errors];
}

class ProfilePictureUploading extends ProfileState {}

class ProfilePictureUploadSuccess extends ProfileState {
  final String newUrl;
  const ProfilePictureUploadSuccess(this.newUrl);
  @override
  List<Object> get props => [newUrl];
}

class ProfilePictureUploadFailure extends ProfileState {
  final String message;
  const ProfilePictureUploadFailure(this.message);
  @override
  List<Object> get props => [message];
}

// ── Wallet Deposit ───────────────────────────────────────────────────
class WalletDepositLoading extends ProfileState {}
class WalletDepositSuccess extends ProfileState {}
class WalletDepositFailure extends ProfileState {
  final String message;
  const WalletDepositFailure(this.message);
  @override
  List<Object> get props => [message];
}

// ── Tickets ──────────────────────────────────────────────────────────
class TicketsLoading extends ProfileState {}

class TicketsLoaded extends ProfileState {
  final List<TicketEntity> tickets;
  const TicketsLoaded(this.tickets);
  @override
  List<Object> get props => [tickets];
}

class TicketsError extends ProfileState {
  final String message;
  const TicketsError(this.message);
  @override
  List<Object> get props => [message];
}

// ── Wallet History ───────────────────────────────────────────────────
class WalletHistoryLoading extends ProfileState {}

class WalletHistoryLoaded extends ProfileState {
  final List<WalletTransactionEntity> transactions;
  const WalletHistoryLoaded(this.transactions);
  @override
  List<Object> get props => [transactions];
}

class WalletHistoryError extends ProfileState {
  final String message;
  const WalletHistoryError(this.message);
  @override
  List<Object> get props => [message];
}

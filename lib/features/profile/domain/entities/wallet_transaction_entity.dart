import 'package:equatable/equatable.dart';

class WalletTransactionEntity extends Equatable {
  final int id;
  final double amount;
  final String type;
  final String description;
  final String? descriptionAr;
  final int? bookingId;
  final DateTime createdAt;

  const WalletTransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    this.descriptionAr,
    this.bookingId,
    required this.createdAt,
  });

  bool get isCredit => amount > 0;

  @override
  List<Object?> get props => [id, amount, type, createdAt];
}

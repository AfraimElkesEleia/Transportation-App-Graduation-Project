import 'package:transportation_app/features/profile/domain/entities/point_transaction.dart';

class PointTransactionModel extends PointTransaction {
  const PointTransactionModel({
    required super.transactionId,
    required super.amount,
    required super.description,
    required super.source,
    required super.status,
    required super.createdAt,
  });

  factory PointTransactionModel.fromJson(Map<String, dynamic> json) {
    return PointTransactionModel(
      transactionId: json['transactionId'] ?? 0,
      amount: json['amount'] ?? 0,
      description: json['description'] ?? '',
      source: json['source'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']).toLocal() : DateTime.now(),
    );
  }
}

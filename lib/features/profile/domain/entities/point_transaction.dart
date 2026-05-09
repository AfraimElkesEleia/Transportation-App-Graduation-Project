class PointTransaction {
  final int transactionId;
  final int amount;         // negative for spent/expired
  final String description;
  final String source;
  final String status;      // "Available" | "Spent" | "Expired"
  final DateTime createdAt;

  const PointTransaction({
    required this.transactionId,
    required this.amount,
    required this.description,
    required this.source,
    required this.status,
    required this.createdAt,
  });

  bool get isEarned => amount > 0;
}

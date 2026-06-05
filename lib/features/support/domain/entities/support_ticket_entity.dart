import 'package:equatable/equatable.dart';

class SupportTicketEntity extends Equatable {
  final int ticketId;
  final String title;
  final String? titleAr;
  final String description;
  final String? descriptionAr;
  final String category;
  final String? categoryAr;
  final String status;
  final String? statusAr;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SupportTicketEntity({
    required this.ticketId,
    required this.title,
    this.titleAr,
    required this.description,
    this.descriptionAr,
    required this.category,
    this.categoryAr,
    required this.status,
    this.statusAr,
    required this.createdAt,
    this.updatedAt,
  });

  factory SupportTicketEntity.fromJson(Map<String, dynamic> json) {
    return SupportTicketEntity(
      ticketId: json['ticketId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['titleAr'] as String?,
      description: json['description'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String?,
      category: json['category'] as String? ?? 'Other',
      categoryAr: json['categoryAr'] as String?,
      status: json['status'] as String? ?? 'Open',
      statusAr: json['statusAr'] as String?,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }

  @override
  List<Object?> get props => [
    ticketId,
    title,
    titleAr,
    description,
    descriptionAr,
    category,
    categoryAr,
    status,
    statusAr,
    createdAt,
    updatedAt,
  ];
}

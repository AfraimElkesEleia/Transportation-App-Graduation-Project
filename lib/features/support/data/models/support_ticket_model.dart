import 'package:transportation_app/features/support/domain/entities/support_ticket_entity.dart';

class SupportTicketModel extends SupportTicketEntity {
  const SupportTicketModel({
    required super.ticketId,
    required super.title,
    super.titleAr,
    required super.description,
    super.descriptionAr,
    required super.category,
    super.categoryAr,
    required super.status,
    super.statusAr,
    required super.createdAt,
    super.updatedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      ticketId: json['ticketId'] as int? ?? json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['titleAr'] as String?,
      description: json['description'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String?,
      category: json['category'] as String? ?? 'Other',
      categoryAr: json['categoryAr'] as String?,
      status: json['status'] as String? ?? 'Open',
      statusAr: json['statusAr'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }
}

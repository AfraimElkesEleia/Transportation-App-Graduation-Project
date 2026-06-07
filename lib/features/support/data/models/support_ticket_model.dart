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
    required super.categoryKey,
    required super.status,
    super.statusAr,
    required super.statusKey,
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
      category: json['category']?.toString() ?? 'Other',
      categoryAr: json['categoryAr'] as String?,
      categoryKey: supportCategoryKeyFromJson(json),
      status: json['status']?.toString() ?? 'Open',
      statusAr: json['statusAr'] as String?,
      statusKey: supportStatusKeyFromJson(json),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }
}

import 'package:equatable/equatable.dart';

class SupportTicketEntity extends Equatable {
  final int ticketId;
  final String title;
  final String? titleAr;
  final String description;
  final String? descriptionAr;
  final String category;
  final String? categoryAr;
  final String categoryKey;
  final String status;
  final String? statusAr;
  final String statusKey;
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
    required this.categoryKey,
    required this.status,
    this.statusAr,
    required this.statusKey,
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
      category: json['category']?.toString() ?? 'Other',
      categoryAr: json['categoryAr'] as String?,
      categoryKey: supportCategoryKeyFromJson(json),
      status: json['status']?.toString() ?? 'Open',
      statusAr: json['statusAr'] as String?,
      statusKey: supportStatusKeyFromJson(json),
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
    categoryKey,
    status,
    statusAr,
    statusKey,
    createdAt,
    updatedAt,
  ];
}

String supportCategoryKeyFromJson(Map<String, dynamic> json) {
  final raw = json['category'] ?? json['issueCategory'];
  return supportCategoryKey(raw);
}

String supportStatusKeyFromJson(Map<String, dynamic> json) {
  return supportStatusKey(json['status']);
}

String supportCategoryKey(Object? value) {
  if (value is int) {
    return switch (value) {
      1 => 'payment',
      2 => 'tripExperience',
      3 => 'appBug',
      4 => 'accountIssue',
      5 => 'other',
      _ => 'unknown',
    };
  }

  final normalized = _normalizeEnumValue(value);
  return switch (normalized) {
    'payment' => 'payment',
    'tripexperience' => 'tripExperience',
    'trip' => 'tripExperience',
    'appbug' => 'appBug',
    'accountissue' => 'accountIssue',
    'other' => 'other',
    _ => normalized.isEmpty ? 'other' : 'unknown',
  };
}

String supportStatusKey(Object? value) {
  if (value is int) {
    return switch (value) {
      1 => 'open',
      2 => 'inProgress',
      3 => 'resolved',
      4 => 'closed',
      _ => 'unknown',
    };
  }

  final normalized = _normalizeEnumValue(value);
  return switch (normalized) {
    'open' => 'open',
    'inprogress' => 'inProgress',
    'resolved' => 'resolved',
    'closed' => 'closed',
    _ => normalized.isEmpty ? 'open' : 'unknown',
  };
}

String _normalizeEnumValue(Object? value) {
  return value
      .toString()
      .trim()
      .replaceAll(RegExp(r'[\s_-]+'), '')
      .toLowerCase();
}

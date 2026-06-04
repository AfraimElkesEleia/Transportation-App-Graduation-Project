import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum TransportType { all, bus, train }

extension TransportTypeExt on TransportType {
  int get value => index; // 0=All 1=Bus 2=Train
  String get label {
    switch (this) {
      case TransportType.all:
        return 'All';
      case TransportType.bus:
        return 'Bus';
      case TransportType.train:
        return 'Train';
    }
  }
}

/// Sort order — matches API values exactly
enum SortBy { departureTime, lowestPrice, shortestDuration }

extension SortByExt on SortBy {
  int get value => index; // 0=Departure 1=Price 2=Duration
  String get label {
    switch (this) {
      case SortBy.departureTime:
        return 'Departure Time';
      case SortBy.lowestPrice:
        return 'Lowest Price';
      case SortBy.shortestDuration:
        return 'Shortest Duration';
    }
  }
}

class SearchParams extends Equatable {
  final bool isRoundTrip;
  final String travelDate;
  final String? returnDate;
  final int passengers;
  final String fromDisplayName;
  final String toDisplayName;
  /// Arabic display name — shown when app is in Arabic locale.
  final String? fromDisplayNameAr;
  final String? toDisplayNameAr;
  final String? fromGovernorate;
  final int? fromStationId;

  final String? toGovernorate;
  final int? toStationId;

  final TransportType transport;
  final SortBy sortBy;
  final double? maxPrice;
  final List<String> preferredAgencies;

  final TimeOfDay? departureFrom;
  final TimeOfDay? departureTo;
  final TimeOfDay? arrivalFrom;
  final TimeOfDay? arrivalTo;
  final int pageNumber;
  final int pageSize;
  const SearchParams({
    this.isRoundTrip = false,
    required this.travelDate,
    this.returnDate,
    required this.passengers,
    required this.toDisplayName,
    required this.fromDisplayName,
    this.fromDisplayNameAr,
    this.toDisplayNameAr,
    this.fromGovernorate,
    this.fromStationId,
    this.toGovernorate,
    this.toStationId,
    this.transport = TransportType.all,
    this.sortBy = SortBy.departureTime,
    this.maxPrice,
    this.preferredAgencies = const [],
    this.departureFrom,
    this.departureTo,
    this.arrivalFrom,
    this.arrivalTo,
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'travelDate': travelDate,
      if (isRoundTrip && returnDate != null) 'returnDate': returnDate,
      'passengers': passengers,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      // Station ID takes priority over governorate name
      if (fromStationId != null)
        'fromStationId': fromStationId
      else if (fromGovernorate != null)
        'fromGovernorate': fromGovernorate,
      if (toStationId != null)
        'toStationId': toStationId
      else if (toGovernorate != null)
        'toGovernorate': toGovernorate,
      'transport': transport.value,
      'sortBy': sortBy.value,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (preferredAgencies.isNotEmpty) 'preferredAgencies': preferredAgencies,
    };
  }

  /// Display label for results screen header
  String get fromLabel => fromGovernorate ?? 'Station #$fromStationId';
  String get toLabel => toGovernorate ?? 'Station #$toStationId';

  bool get hasTimeFilters =>
      departureFrom != null ||
      departureTo != null ||
      arrivalFrom != null ||
      arrivalTo != null;

  int get activeFilterCount {
    int n = 0;
    if (maxPrice != null) n++;
    if (transport != TransportType.all) n++;
    if (sortBy != SortBy.departureTime) n++;
    if (hasTimeFilters) n++;
    if (preferredAgencies.isNotEmpty) n++;
    return n;
  }

  SearchParams copyWith({
    bool? isRoundTrip,
    String? travelDate,
    String? returnDate,
    int? passengers,
    TransportType? transport,
    SortBy? sortBy,
    double? maxPrice,
    bool clearMaxPrice = false,
    List<String>? preferredAgencies,
    TimeOfDay? departureFrom,
    TimeOfDay? departureTo,
    TimeOfDay? arrivalFrom,
    TimeOfDay? arrivalTo,
    bool clearTimeFilters = false,
    int? newPage,
  }) {
    return SearchParams(
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      travelDate: travelDate ?? this.travelDate,
      returnDate: returnDate ?? this.returnDate,
      passengers: passengers ?? this.passengers,
      toDisplayName: toDisplayName,
      fromDisplayName: fromDisplayName,
      fromDisplayNameAr: fromDisplayNameAr,
      toDisplayNameAr: toDisplayNameAr,
      fromGovernorate: fromGovernorate,
      fromStationId: fromStationId,
      toGovernorate: toGovernorate,
      toStationId: toStationId,
      transport: transport ?? this.transport,
      sortBy: sortBy ?? this.sortBy,
      maxPrice: clearMaxPrice ? null : maxPrice ?? this.maxPrice,
      preferredAgencies: preferredAgencies ?? this.preferredAgencies,
      departureFrom: clearTimeFilters
          ? null
          : departureFrom ?? this.departureFrom,
      departureTo: clearTimeFilters ? null : departureTo ?? this.departureTo,
      arrivalFrom: clearTimeFilters ? null : arrivalFrom ?? this.arrivalFrom,
      arrivalTo: clearTimeFilters ? null : arrivalTo ?? this.arrivalTo,
      pageNumber: newPage ?? pageNumber, 
      pageSize: pageSize,
    );
  }

  @override
  List<Object?> get props => [
    isRoundTrip,
    travelDate,
    returnDate,
    passengers,
    fromGovernorate,
    fromStationId,
    toGovernorate,
    toStationId,
    transport,
    sortBy,
    maxPrice,
    preferredAgencies,
    departureFrom,
    departureTo,
    arrivalFrom,
    arrivalTo,
  ];
}

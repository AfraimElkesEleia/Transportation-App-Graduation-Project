import 'package:flutter/material.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_form_controllers.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/search/domain/entities/trip_result_entity.dart';

bool isTrainTrip(TripResultEntity? trip) {
  if (trip == null) return false;
  final name = trip.agencyName.toLowerCase();
  return name.contains('rail') ||
      name.contains('enr') ||
      name.contains('train') ||
      name.contains('talgo');
}

void prefillFirstPassengerFromProfile({
  required List<PassengerFormControllers> controllers,
  required ProfileEntity profile,
  required bool includeId,
  VoidCallback? onIdTypeChanged,
}) {
  if (controllers.isEmpty) return;

  final first = controllers.first;
  if (first.nameController.text.trim().isEmpty) {
    first.nameController.text = profile.fullName;
  }
  if (first.phoneController.text.trim().isEmpty) {
    first.phoneController.text = profile.phoneNumber;
  }
  if (first.emailController.text.trim().isEmpty) {
    first.emailController.text = profile.email;
  }
  if (!includeId) return;

  if (profile.idNumber != null && profile.idNumber!.isNotEmpty) {
    if (first.idController.text.trim().isEmpty) {
      first.idController.text = profile.idNumber!;
    }
    if (profile.idType != null) {
      first.selectedIdType = profile.idType == 2 ? 'Passport' : 'NationalId';
      onIdTypeChanged?.call();
    }
  }
}

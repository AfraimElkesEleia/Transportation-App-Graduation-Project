import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String familyName;
  final String email;
  final String phoneNumber;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.familyName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [firstName, lastName, familyName, email, phoneNumber];
}

class UpdateProfileUseCase extends Usecase<ProfileEntity, UpdateProfileParams> {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      firstName:   params.firstName,
      lastName:    params.lastName,
      familyName:  params.familyName,
      email:       params.email,
      phoneNumber: params.phoneNumber,
    );
  }
}
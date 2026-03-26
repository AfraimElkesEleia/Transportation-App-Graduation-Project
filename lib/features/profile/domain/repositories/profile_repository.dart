import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  ResultFuture<ProfileEntity> getProfile();
  ResultFuture<ProfileEntity> updateProfile({
    required String firstName,
    required String lastName,
    required String familyName,
    required String email,
    required String phoneNumber,
  });
  ResultFuture<String> uploadProfilePicture({required String filePath});
  ResultVoid logout();
}
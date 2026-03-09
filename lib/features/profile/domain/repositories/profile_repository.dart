import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  /// Load user from local cache (TokenManager)
  ResultFuture<ProfileEntity> getProfile();

  /// Revoke current device refresh token on server then clear local storage
 ResultVoid logout();
}
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase extends Usecase<ProfileEntity, NoParams> {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  @override
  ResultFuture<ProfileEntity> call(NoParams params) {
    return repository.getProfile();
  }
}
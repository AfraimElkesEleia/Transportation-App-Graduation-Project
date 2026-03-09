import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';

class LogoutUseCase extends Usecase<void, NoParams> {
  final ProfileRepository repository;
  LogoutUseCase(this.repository);

  @override
  ResultVoid call(NoParams params) {
    return repository.logout();
  }
}
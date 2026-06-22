import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';

class UpdateLanguageUseCase {
  final ProfileRepository repository;

  UpdateLanguageUseCase(this.repository);

  ResultVoid call({required String languageCode}) {
    return repository.updateLanguage(languageCode: languageCode);
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:transportation_app/core/error/failures.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';

class UploadPictureParams extends Equatable {
  final String filePath;
  const UploadPictureParams(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class UploadProfilePictureUseCase extends Usecase<String, UploadPictureParams> {
  final ProfileRepository repository;
  UploadProfilePictureUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadPictureParams params) {
    return repository.uploadProfilePicture(filePath: params.filePath);
  }
}
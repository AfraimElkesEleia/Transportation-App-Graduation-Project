import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_picture_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase            getProfileUseCase;
  final UpdateProfileUseCase         updateProfileUseCase;
  final UploadProfilePictureUseCase  uploadPictureUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadPictureUseCase,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
  emit(ProfileLoading());
  print('🟣 [ProfileCubit] loadProfile called');
  final result = await getProfileUseCase(NoParams());
  result.fold(
    (failure) {
      print('🔴 [ProfileCubit] error: ${failure.message}');
      emit(ProfileError(failure.message));
    },
    (profile) {
      print('🟢 [ProfileCubit] loaded: ${profile.fullName}');
      emit(ProfileLoaded(profile));
    },
  );
}
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String familyName,
    required String email,
    required String phoneNumber,
  }) async {
    emit(ProfileUpdating());
    final result = await updateProfileUseCase(UpdateProfileParams(
      firstName:   firstName,
      lastName:    lastName,
      familyName:  familyName,
      email:       email,
      phoneNumber: phoneNumber,
    ));
    result.fold(
      (failure) => emit(ProfileUpdateFailure(
        message: failure.message,
        errors:  failure.errors,
      )),
      (profile) => emit(ProfileUpdateSuccess(profile)),
    );
  }
  Future<void> uploadProfilePicture(String filePath) async {
    emit(ProfilePictureUploading());
    final result = await uploadPictureUseCase(UploadPictureParams(filePath));
    result.fold(
      (failure) => emit(ProfilePictureUploadFailure(failure.message)),
      (url)     => emit(ProfilePictureUploadSuccess(url)),
    );
  }
}
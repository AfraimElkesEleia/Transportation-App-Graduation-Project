import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit({required this.getProfileUseCase}) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());

    final result = await getProfileUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
}
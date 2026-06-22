import 'package:flutter/foundation.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_picture_usecase.dart';
import 'package:transportation_app/features/signup/domain/usecases/register_use_case.dart';
import 'package:transportation_app/features/signup/presentation/cubit/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  final RegisterUseCase registerUseCase;
  final UploadProfilePictureUseCase uploadPictureUseCase;
  SignupCubit({
    required this.registerUseCase,
    required this.uploadPictureUseCase,
  }) : super(SignupInitial());

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String familyName,
    required int gender,
    required String dateOfBirth,
    required String countryCode,
    int? idType,
    String? idNumber,
    String? imagePath,
  }) async {
    emit(SignupLoading());

    final result = await registerUseCase(
      RegisterParams(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        familyName: familyName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        countryCode: countryCode,
        idType: idType,
        idNumber: idNumber,
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        debugPrint('🟡 [Cubit] failure: ${failure.message}');
        emit(SignupFailure(message: failure.message, errors: failure.errors));
      },
      (authResponse) async {
        debugPrint('🟢 [Cubit] success');
        if (imagePath != null) {
          final uploadResult = await uploadPictureUseCase(
            UploadPictureParams(imagePath),
          );
          if (isClosed) return;
          uploadResult.fold((failure) => null, (url) => null);
        }
        emit(SignupSuccess(authResponse));
      },
    );
  }
}

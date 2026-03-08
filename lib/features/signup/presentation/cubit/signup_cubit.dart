import 'package:transportation_app/features/signup/domain/usecases/register_use_case.dart';
import 'package:transportation_app/features/signup/presentation/cubit/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  final RegisterUseCase registerUseCase;

  SignupCubit({required this.registerUseCase}) : super(SignupInitial());

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
    String? nationalIdNumber,
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
        nationalIdNumber: nationalIdNumber,
      ),
    );

    result.fold(
      (failure) {
        print('🟡 [Cubit] failure: ${failure.message}');
        emit(SignupFailure(message: failure.message, errors: failure.errors));
      },
      (authResponse) {
        print('🟢 [Cubit] success');
        emit(SignupSuccess(authResponse));
      },
    );
  }
}

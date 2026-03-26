import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/login/domain/usecase/change_password_usecase.dart';
import 'package:transportation_app/features/login/domain/usecase/forgot_password_usecase.dart';
import 'package:transportation_app/features/login/domain/usecase/reset_password_usecase.dart';
import 'package:transportation_app/features/login/presentation/cubit/password_cubit/password_states.dart';

class PasswordCubit extends Cubit<PasswordStates> {
  final ForgotPasswordUsecase forgotPasswordUseCase;
  final ResetPasswordUsecase resetPasswordUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  PasswordCubit({
   required this.forgotPasswordUseCase,
   required this.resetPasswordUseCase,
   required this.changePasswordUseCase,
  }) : super(PasswordInitial());
  Future<void> forgotPassword({required String email}) async {
    emit(PasswordLoading());
    final result = await forgotPasswordUseCase(ForgetPasswordParams(email: email));
    result.fold(
      (failure) => emit(PasswordFailure(message: failure.message)),
      (_) => emit(const PasswordSuccess(
        'If your email is registered, you will receive a reset link shortly',
      )),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(PasswordLoading());
    final result = await resetPasswordUseCase(ResetPasswordParams(
      email: email, token: token,
      newPassword: newPassword, confirmPassword: confirmPassword,
    ));
    result.fold(
      (failure) => emit(PasswordFailure(message: failure.message, errors: failure.errors)),
      (_) => emit(const PasswordSuccess('Password reset successfully')),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(PasswordLoading());
    final result = await changePasswordUseCase(ChangePasswordParams(
      currentPassword: currentPassword,
      newPassword:     newPassword,
      confirmPassword: confirmPassword,
    ));
    result.fold(
      (failure) => emit(PasswordFailure(message: failure.message)),
      (_) => emit(const PasswordSuccess('Password changed successfully')),
    );
  }
}

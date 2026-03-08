import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/login/domain/usecase/login_usecase.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    String? deviceInfo,
  }) async {
    emit(LoginLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password, deviceInfo: deviceInfo),
    );

    result.fold(
      (failure) => emit(LoginFailure(message: failure.message, errors: failure.errors)),
      (authResponse) => emit(LoginSuccess(authResponse)),
    );
  }
}
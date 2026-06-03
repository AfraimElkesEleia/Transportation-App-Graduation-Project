import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/login/domain/usecase/login_usecase.dart';
import 'package:transportation_app/features/login/presentation/cubit/login_cubit/login_states.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/notfications/fcm_service.dart';
import 'package:transportation_app/core/notfications/fcm_token_datasource.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    String? deviceInfo,
    bool rememberMe = false
  }) async {
    emit(LoginLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password, deviceInfo: deviceInfo,rememberMe:rememberMe),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(LoginFailure(message: failure.message, errors: failure.errors)),
      (authResponse) async {
        emit(LoginSuccess(authResponse));
        final fcmToken = await FcmService.getToken();
        if (fcmToken != null) {
          await sl<FcmTokenDatasource>().registerToken(
            token: fcmToken,
            deviceType: FcmService.deviceType,
          );
        }
      },
    );
  }
}
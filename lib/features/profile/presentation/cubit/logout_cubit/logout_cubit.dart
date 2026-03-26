import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:transportation_app/features/profile/presentation/cubit/logout_cubit/logout_states.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit({required this.logoutUseCase}) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) {
        emit(LogoutSuccess());
      },
      (_) => emit(LogoutSuccess()),
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/my_tickets/domain/repositories/my_tickets_repository.dart';

abstract class PassengerBoardingPassState {}

class PassengerBoardingPassInitial extends PassengerBoardingPassState {}

class PassengerBoardingPassLoading extends PassengerBoardingPassState {}

class PassengerBoardingPassLoaded extends PassengerBoardingPassState {
  final String qrPayload;
  PassengerBoardingPassLoaded(this.qrPayload);
}

class PassengerBoardingPassError extends PassengerBoardingPassState {
  final String message;
  PassengerBoardingPassError(this.message);
}

class PassengerBoardingPassCubit extends Cubit<PassengerBoardingPassState> {
  final MyTicketsRepository repository;

  PassengerBoardingPassCubit({required this.repository})
    : super(PassengerBoardingPassInitial());

  Future<void> fetchQrPayload(int bookingId, int passengerId) async {
    emit(PassengerBoardingPassLoading());
    final result = await repository.getQrPayload(
      bookingId: bookingId,
      passengerId: passengerId,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(PassengerBoardingPassError(failure.message)),
      (payload) => emit(PassengerBoardingPassLoaded(payload)),
    );
  }
}

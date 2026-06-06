import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/notfications/local_alarm_scheduler.dart';
import 'package:transportation_app/features/booking/domain/usecases/add_to_cart_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/checkout_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/get_cart_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/get_seat_map_usecase.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';

class SeatMapCubit extends Cubit<SeatMapState> {
  final GetSeatMapUseCase getSeatMapUseCase;
  final AddToCartUseCase addToCartUseCase;
  final GetCartUseCase getCartUseCase;
  final CheckoutUseCase checkoutUseCase;

  SeatMapCubit({
    required this.getSeatMapUseCase,
    required this.addToCartUseCase,
    required this.getCartUseCase,
    required this.checkoutUseCase,
  }) : super(SeatMapInitial());

  Future<void> loadSeatMap(int occurrenceId, int coachClassId) async {
    if (isClosed) return;
    emit(SeatMapLoading());
    final result = await getSeatMapUseCase(occurrenceId);
    if (isClosed) return;
    result.fold((failure) => emit(SeatMapError(failure.message)), (map) {
      final classMap = map.classById(coachClassId);
      if (classMap == null) {
        emit(const SeatMapError('Class not found in seat map.'));
      } else {
        if (!isClosed) emit(SeatMapLoaded(classMap));
      }
    });
  }

  Future<void> addToCart({
    required int tripOccurrenceId,
    required int coachClassId,
    required int originStationId,
    required int destinationStationId,
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required List<Map<String, dynamic>> passengers,
  }) async {
    emit(SeatMapLoading());
    final result = await addToCartUseCase({
        'tripOccurrenceId': tripOccurrenceId,
        'coachClassId': coachClassId,
        'originStationId': originStationId,
        'destinationStationId': destinationStationId,
        'contactName': contactName,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
        'passengers': passengers,
      });
    if (isClosed) return;
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(CartSuccess()),
    );
  }

  Future<void> addMultipleToCart({
    required List<Map<String, dynamic>> payloads,
  }) async {
    emit(SeatMapLoading());
    for (final p in payloads) {
      final result = await addToCartUseCase(p);
      if (isClosed) return;
      final failed = result.fold((failure) {
        emit(CartError(failure.message));
        return true;
      }, (_) => false);
      if (failed) {
        return;
      }
    }
    emit(CartSuccess());
  }

  Future<bool> _addPayloads(List<Map<String, dynamic>> payloads) async {
    for (final p in payloads) {
      final result = await addToCartUseCase(p);
      if (isClosed) return false;
      final failed = result.fold((failure) {
        emit(CartError(failure.message));
        return true;
      }, (_) => false);
      if (failed) {
        return false;
      }
    }
    return true;
  }

  Future<void> _checkoutAfterCartAdd({required int pointsToRedeem}) async {
    final cartResult = await getCartUseCase();
    if (isClosed) return;
    final cartFailed = cartResult.fold((failure) {
      emit(CartAddedButCheckoutFailed(failure.message));
      return true;
    }, (_) => false);
    if (cartFailed) {
      return;
    }

    final checkoutResult = await checkoutUseCase(pointsToRedeem: pointsToRedeem);
    if (isClosed) return;
    checkoutResult.fold((failure) {
      emit(CartAddedButCheckoutFailed(failure.message));
    }, (_) async {
      await LocalAlarmScheduler.cancelCartExpiry();
      if (isClosed) return;
      emit(CartSuccess());
    });
  }

  Future<void> bookMultipleNow({
    required List<Map<String, dynamic>> payloads,
    int pointsToRedeem = 0,
  }) async {
    if (isClosed) return;
    emit(CartAdding());
    final added = await _addPayloads(payloads);
    if (isClosed || !added) {
      return;
    }
    await _checkoutAfterCartAdd(pointsToRedeem: pointsToRedeem);
  }

  Future<void> bookNow({
    required int tripOccurrenceId,
    required int coachClassId,
    required int originStationId,
    required int destinationStationId,
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required List<Map<String, dynamic>> passengers,
    int pointsToRedeem = 0,
  }) async {
    if (isClosed) return;
    emit(CartAdding());
    final added = await _addPayloads([
      {
        'tripOccurrenceId': tripOccurrenceId,
        'coachClassId': coachClassId,
        'originStationId': originStationId,
        'destinationStationId': destinationStationId,
        'contactName': contactName,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
        'passengers': passengers,
      },
    ]);
    if (isClosed || !added) {
      return;
    }
    await _checkoutAfterCartAdd(pointsToRedeem: pointsToRedeem);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:transportation_app/features/booking/presentation/cubit/seat_map_state.dart';

class SeatMapCubit extends Cubit<SeatMapState> {
  final BookingRemoteDatasource datasource;

  SeatMapCubit({required this.datasource}) : super(SeatMapInitial());

  Future<void> loadSeatMap(int occurrenceId, int coachClassId) async {
    if (isClosed) return;
    emit(SeatMapLoading());
    try {
      final map      = await datasource.getSeatMap(occurrenceId);
      final classMap = map.classById(coachClassId);
      if (classMap == null) {
        emit(const SeatMapError('Class not found in seat map.'));
      } else {
        if (!isClosed) emit(SeatMapLoaded(classMap));
      }
    } on ServerException catch (e) {
      if (!isClosed) emit(SeatMapError(e.message));
    } on NetworkException {
      if (!isClosed) emit(const SeatMapError('No internet connection.'));
    }
  }

  Future<void> addToCart({
    required int tripOccurrenceId,
    required int coachClassId,
    required int originStationId,
    required int destinationStationId,
    required List<Map<String, dynamic>> passengers,
  }) async {
    emit(SeatMapLoading());
    try {
      await datasource.addToCart({
        'tripOccurrenceId': tripOccurrenceId,
        'coachClassId': coachClassId,
        'originStationId': originStationId,
        'destinationStationId': destinationStationId,
        'passengers': passengers,
      });
      emit(CartSuccess());
    } on ServerException catch (e) {
      emit(CartError(e.message));
    } catch (_) {
      emit(const CartError('Unexpected error occurred'));
    }
  }

  Future<void> addMultipleToCart({
    required List<Map<String, dynamic>> payloads,
  }) async {
    emit(SeatMapLoading());
    try {
      for (final p in payloads) {
        await datasource.addToCart(p);
      }
      emit(CartSuccess());
    } on ServerException catch (e) {
      emit(CartError(e.message));
    } catch (_) {
      emit(const CartError('Unexpected error occurred'));
    }
  }

  Future<void> bookNow({
    required int    tripOccurrenceId,
    required int    coachClassId,
    required int    originStationId,
    required int    destinationStationId,
    required List<Map<String, dynamic>> passengers,
  }) async {
    if (isClosed) return;
    emit(CartAdding());
    try {
      await datasource.addToCart({
        'tripOccurrenceId':    tripOccurrenceId,
        'coachClassId':        coachClassId,
        'originStationId':     originStationId,
        'destinationStationId': destinationStationId,
        'passengers':          passengers,
      });
      await datasource.checkout();
      if (!isClosed) emit(CartSuccess());
    } on ServerException catch (e) {
      if (!isClosed) emit(CartError(e.message));
    } on NetworkException {
      if (!isClosed) emit(const CartError('No internet connection.'));
    }
  }
}
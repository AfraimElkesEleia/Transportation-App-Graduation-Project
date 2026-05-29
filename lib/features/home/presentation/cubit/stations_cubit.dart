import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/home/domain/usecases/get_stations_use_case.dart';
import 'stations_state.dart';

class StationsCubit extends Cubit<StationsState> {
  final GetStationsUseCase getStationsUseCase;

  StationsCubit({required this.getStationsUseCase}) : super(StationsInitial());

  Future<void> loadStations() async {
    if (state is StationsLoaded) return;
    emit(StationsLoading());
    final result = await getStationsUseCase(NoParams());
    result.fold(
      (failure) => emit(StationsError(failure.message)),
      (groups)  => emit(StationsLoaded(groups)),
    );
  }

  Future<void> refresh() async {
    emit(StationsLoading());
    final result = await getStationsUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(StationsError(failure.message)),
      (groups)  => emit(StationsLoaded(groups)),
    );
  }
}
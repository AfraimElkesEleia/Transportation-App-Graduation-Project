import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/home/domain/usecases/get_popular_routes_usecase.dart';
import 'package:transportation_app/features/home/presentation/cubit/popular_routes_states.dart';

class PopularRoutesCubit extends Cubit<PopularRoutesState> {
  final GetPopularRoutesUsecase _usecase;

  PopularRoutesCubit(this._usecase) : super(PopularRoutesInitial());

  Future<void> load() async {
    emit(PopularRoutesLoading());
    final result = await _usecase();
    if (isClosed) return;
    result.fold(
      (f) => emit(PopularRoutesError(f.message)),
      (routes) => emit(PopularRoutesLoaded(routes)),
    );
  }
}

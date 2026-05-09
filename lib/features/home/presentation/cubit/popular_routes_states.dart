import 'package:transportation_app/features/home/domain/entities/popular_route.dart';

abstract class PopularRoutesState {}

class PopularRoutesInitial extends PopularRoutesState {}

class PopularRoutesLoading extends PopularRoutesState {}

class PopularRoutesLoaded extends PopularRoutesState {
  final List<PopularRoute> routes;

  PopularRoutesLoaded(this.routes);
}

class PopularRoutesError extends PopularRoutesState {
  final String message;

  PopularRoutesError(this.message);
}

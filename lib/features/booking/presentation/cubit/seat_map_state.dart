import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';

abstract class SeatMapState extends Equatable {
  const SeatMapState();
  @override List<Object?> get props => [];
}
class SeatMapInitial extends SeatMapState {}
class SeatMapLoading extends SeatMapState {}
class SeatMapLoaded  extends SeatMapState {
  final SeatClassMap classMap;    // only the requested class
  const SeatMapLoaded(this.classMap);
  @override List<Object?> get props => [classMap];
}
class SeatMapError   extends SeatMapState {
  final String message;
  const SeatMapError(this.message);
  @override List<Object?> get props => [message];
}

// Adding to cart states
class CartAdding  extends SeatMapState {}
class CartSuccess extends SeatMapState {}
class CartError   extends SeatMapState {
  final String message;
  const CartError(this.message);
  @override List<Object?> get props => [message];
}
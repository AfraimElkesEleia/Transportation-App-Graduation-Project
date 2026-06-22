import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';

abstract class BookingRepository {
  ResultFuture<CartEntity?> getCart();
  ResultFuture<SeatMapEntity> getSeatMap(int occurrenceId);
  ResultFuture<void> addToCart(Map<String, dynamic> payload);
  ResultFuture<void> checkout({int pointsToRedeem = 0});
  ResultFuture<void> cancelCartItem(int bookingId);
}

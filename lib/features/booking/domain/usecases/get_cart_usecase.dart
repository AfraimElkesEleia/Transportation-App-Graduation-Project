import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';
import 'package:transportation_app/features/booking/domain/repositories/booking_repository.dart';

class GetCartUseCase {
  final BookingRepository repository;

  GetCartUseCase(this.repository);

  ResultFuture<CartEntity?> call() => repository.getCart();
}

import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/booking/domain/repositories/booking_repository.dart';

class AddToCartUseCase {
  final BookingRepository repository;

  AddToCartUseCase(this.repository);

  ResultFuture<void> call(Map<String, dynamic> payload) {
    return repository.addToCart(payload);
  }
}

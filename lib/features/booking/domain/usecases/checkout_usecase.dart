import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/booking/domain/repositories/booking_repository.dart';

class CheckoutUseCase {
  final BookingRepository repository;

  CheckoutUseCase(this.repository);

  ResultFuture<void> call({int pointsToRedeem = 0}) {
    return repository.checkout(pointsToRedeem: pointsToRedeem);
  }
}

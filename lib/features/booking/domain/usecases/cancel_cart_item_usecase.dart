import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/booking/domain/repositories/booking_repository.dart';

class CancelCartItemUsecase {
  final BookingRepository repository;

  CancelCartItemUsecase(this.repository);

  ResultFuture<void> call(int bookingId) => repository.cancelCartItem(bookingId);
}

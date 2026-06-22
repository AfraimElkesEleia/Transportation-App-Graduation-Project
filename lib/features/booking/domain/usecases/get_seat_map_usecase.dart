import 'package:transportation_app/core/utils/typedef.dart';
import 'package:transportation_app/features/booking/domain/entities/seat_map.dart';
import 'package:transportation_app/features/booking/domain/repositories/booking_repository.dart';

class GetSeatMapUseCase {
  final BookingRepository repository;

  GetSeatMapUseCase(this.repository);

  ResultFuture<SeatMapEntity> call(int occurrenceId) {
    return repository.getSeatMap(occurrenceId);
  }
}

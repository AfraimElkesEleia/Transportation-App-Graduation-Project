import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/error/exceptions.dart';
import 'package:transportation_app/core/notfications/local_alarm_scheduler.dart';
import 'package:transportation_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final BookingRemoteDatasource datasource;

  CartCubit({required this.datasource}) : super(CartInitial());

  Future<void> fetchCart() async {
    emit(CartLoading());
    try {
      final cart = await datasource.getCart();
      if (cart == null || cart.items.isEmpty) {
        emit(CartEmpty());
      } else {
        for (final item in cart.items) {
          if (item.holdExpiresAt != null) {
            await LocalAlarmScheduler.scheduleCartExpiry(
              holdExpiresAt: item.holdExpiresAt!,
            );
          }
        }
        emit(CartLoaded(cart));
      }
    } on ServerException catch (e) {
      emit(CartError(e.message));
    } catch (_) {
      emit(
        const CartError('An unexpected error occurred while fetching cart.'),
      );
    }
  }

  Future<void> checkout({int pointsToRedeem = 0}) async {
    final currentState = state;
    emit(CheckoutLoading());
    try {
      await datasource.checkout(pointsToRedeem: pointsToRedeem);
      await LocalAlarmScheduler.cancelCartExpiry();
      if (currentState is CartLoaded) {
        for (final item in currentState.cart.items) {
          if (item.boardingTime != null) {
            await LocalAlarmScheduler.scheduleBoardingReminder(
              bookingId: item.bookingId.toString(),
              boardingTime: item.boardingTime!,
              routeLabel: '${item.originGov} → ${item.destinationGov}',
            );
          }
        }
      }
      emit(CheckoutSuccess());
    } on ServerException catch (e) {
      emit(CheckoutError(e.message));
    } catch (_) {
      emit(
        const CheckoutError('An unexpected error occurred during checkout.'),
      );
    }
  }

  Future<void> cancelItem(int bookingId) async {
    emit(CartItemCancelling(bookingId));
    try {
      await datasource.cancelCartItem(bookingId);
      await LocalAlarmScheduler.cancelBoardingReminder(bookingId.toString());
      await fetchCart();
    } on ServerException catch (e) {
      emit(CartItemCancelError(e.message));
      await fetchCart();
    } catch (_) {
      emit(
        const CartItemCancelError(
          'An unexpected error occurred while cancelling.',
        ),
      );
      await fetchCart();
    }
  }
}

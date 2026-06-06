import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/notfications/local_alarm_scheduler.dart';
import 'package:transportation_app/features/booking/domain/usecases/cancel_cart_item_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/checkout_usecase.dart';
import 'package:transportation_app/features/booking/domain/usecases/get_cart_usecase.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final CheckoutUseCase checkoutUseCase;
  final CancelCartItemUsecase cancelCartItemUsecase;

  CartCubit({
    required this.getCartUseCase,
    required this.checkoutUseCase,
    required this.cancelCartItemUsecase,
  }) : super(CartInitial());

  Future<void> fetchCart() async {
    emit(CartLoading());
    final result = await getCartUseCase();
    if (isClosed) return;
    await result.fold((failure) async {
      emit(CartError(failure.message));
    }, (cart) async {
      if (cart == null || cart.items.isEmpty) {
        emit(CartEmpty());
      } else {
        for (final item in cart.items) {
          if (item.holdExpiresAt != null) {
            await LocalAlarmScheduler.scheduleCartExpiry(
              holdExpiresAt: item.holdExpiresAt!,
            );
            if (isClosed) return;
          }
        }
        emit(CartLoaded(cart));
      }
    });
  }

  Future<void> checkout({int pointsToRedeem = 0}) async {
    emit(CheckoutLoading());
    final result = await checkoutUseCase(pointsToRedeem: pointsToRedeem);
    if (isClosed) return;
    await result.fold((failure) async {
      emit(CheckoutError(failure.message));
    }, (_) async {
      await LocalAlarmScheduler.cancelCartExpiry();
      if (isClosed) return;
      emit(CheckoutSuccess());
    });
  }

  Future<void> cancelItem(int bookingId) async {
    emit(CartItemCancelling(bookingId));
    final result = await cancelCartItemUsecase(bookingId);
    if (isClosed) return;
    await result.fold((failure) async {
      emit(CartItemCancelError(failure.message));
      await fetchCart();
    }, (_) async {
      await fetchCart();
    });
  }
}

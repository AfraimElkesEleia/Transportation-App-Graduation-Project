import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/error/exceptions.dart';
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
        emit(CartLoaded(cart));
      }
    } on ServerException catch (e) {
      emit(CartError(e.message));
    } catch (_) {
      emit(const CartError('An unexpected error occurred while fetching cart.'));
    }
  }

  Future<void> checkout({int pointsToRedeem = 0}) async {
    emit(CheckoutLoading());
    try {
      await datasource.checkout(pointsToRedeem: pointsToRedeem);
      emit(CheckoutSuccess());
    } on ServerException catch (e) {
      emit(CheckoutError(e.message));
    } catch (_) {
      emit(const CheckoutError('An unexpected error occurred during checkout.'));
    }
  }
}

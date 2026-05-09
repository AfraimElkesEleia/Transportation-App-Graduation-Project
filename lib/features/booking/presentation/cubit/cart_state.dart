import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartEntity cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartEmpty extends CartState {}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CheckoutLoading extends CartState {}

class CheckoutSuccess extends CartState {}

class CheckoutError extends CartState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartItemCancelling extends CartState {
  final int bookingId;

  const CartItemCancelling(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class CartItemCancelError extends CartState {
  final String message;

  const CartItemCancelError(this.message);

  @override
  List<Object?> get props => [message];
}

part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class InitialCartState extends CartState {
  @override
  List<Object> get props => [];
}

class ShowProgressBar extends CartState {
  @override
  List<Object> get props => [];
}

class DismissProgressBar extends CartState {
  @override
  List<Object> get props => [];
}

class FetchedCart extends CartState {
  final List<CategoryDishes> categoryDishes;
  final int itemsCount;
  final double totalAmount;
  FetchedCart({required this.categoryDishes, required this.itemsCount, required this.totalAmount});
  @override
  List<Object> get props => [categoryDishes, itemsCount, totalAmount];
}

class OrderPlacedSuccessfully extends CartState {
  @override
  List<Object> get props => [];
}
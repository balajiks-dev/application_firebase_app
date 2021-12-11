part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class FetchCartItems extends CartEvent {
  @override
  List<Object> get props => [];
}

class PlaceOrderButtonClicked extends CartEvent {
  @override
  List<Object> get props => [];
}

class PlusButtonClicked extends CartEvent {
  final List<CategoryDishes> categoryDishes;
  final int selectedIndex;
  PlusButtonClicked({required this.categoryDishes, required this.selectedIndex});
  @override
  List<Object> get props => [categoryDishes, selectedIndex];
}

class MinusButtonClicked extends CartEvent {
    final List<CategoryDishes> categoryDishes;
  final int selectedIndex;
  MinusButtonClicked({required this.categoryDishes, required this.selectedIndex});
  @override
  List<Object> get props => [categoryDishes, selectedIndex];
}

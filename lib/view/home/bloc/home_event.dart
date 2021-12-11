part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchDishes extends HomeEvent {
  @override
  List<Object> get props => [];
}

class CategoriesChangedEvent extends HomeEvent {
  final int index;
  CategoriesChangedEvent({required this.index});
  @override
  List<Object> get props => [index];
}

class PlusClickedEvent extends HomeEvent {
final int selectedIndex;
  final int selectedCategory;
  PlusClickedEvent({required this.selectedIndex, required this.selectedCategory});
  @override
  List<Object> get props => [selectedIndex, selectedCategory];
}

class MinusClickedEvent extends HomeEvent {
  final int selectedIndex;
  final int selectedCategory;
  MinusClickedEvent({required this.selectedIndex, required this.selectedCategory});
  @override
  List<Object> get props => [selectedIndex, selectedCategory];
}

class UpdateDishesEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class LogoutEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}
part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class InitialHomeState extends HomeState {
  @override
  List<Object> get props => [];
}

class FetchDishesSuccess extends HomeState {
  final String userName;
  final String userPhoto;
  final String userUID;
  FetchDishesSuccess(
      {required this.userName, required this.userPhoto, required this.userUID});
  @override
  List<Object> get props => [userName, userPhoto, userUID];
}

class FetchDishesFailure extends HomeState {
  final String error;

  const FetchDishesFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class LoginValidationFailure extends HomeState {
  final String error;

  const LoginValidationFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class ShowProgressBar extends HomeState {
  @override
  List<Object> get props => [];
}

class DismissProgressBar extends HomeState {
  @override
  List<Object> get props => [];
}

class CategoriesChangedState extends HomeState {
  final int index;
  CategoriesChangedState({required this.index});
  @override
  List<Object> get props => [index];
}

class UpdatedCategoriesState extends HomeState {
  @override
  List<Object> get props => [];
}

class LogoutSuccess extends HomeState {
  @override
  List<Object> get props => [];
}

class LogoutFailure extends HomeState {
  final String error;
  LogoutFailure({required this.error});
  @override
  List<Object> get props => [error];
}

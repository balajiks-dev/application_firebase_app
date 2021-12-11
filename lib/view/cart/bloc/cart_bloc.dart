import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:application_firebase_app/model/dishes_response_model.dart';
import 'package:application_firebase_app/view/home/bloc/home_bloc.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(InitialCartState());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is FetchCartItems) {
      yield ShowProgressBar();
      List<CategoryDishes> categoryDishes = <CategoryDishes>[];
      int itemsCount = 0;
      double totalAmount = 0.0;

      dishesResponseModel[0].tableMenuList!.forEach((element) {
        element.categoryDishes!.forEach((dish) {
          if (dish.quantity! > 0) {
            categoryDishes.add(dish);
            itemsCount = itemsCount + dish.quantity!;
          }
        });
      });
      categoryDishes.forEach((dish) {
        totalAmount = totalAmount + (dish.dishPrice! * dish.quantity!);
      });
      yield DismissProgressBar();
      yield FetchedCart(
          categoryDishes: categoryDishes,
          itemsCount: itemsCount,
          totalAmount: totalAmount);
    } else if (event is PlaceOrderButtonClicked) {
      yield ShowProgressBar();
      cartCount.value = 0;
      yield DismissProgressBar();
      yield OrderPlacedSuccessfully();
    } else if (event is PlusButtonClicked) {
      yield ShowProgressBar();
      List<CategoryDishes> categoryDishes = <CategoryDishes>[];
      int itemsCount = 0;
      double totalAmount = 0.0;

      dishesResponseModel[0].tableMenuList!.forEach((element) {
        element.categoryDishes!.forEach((dish) {
          if (event.categoryDishes[event.selectedIndex].dishId == dish.dishId) {
            dish.quantity = dish.quantity! + 1;
          }
        });
      });

      dishesResponseModel[0].tableMenuList!.forEach((element) {
        element.categoryDishes!.forEach((dish) {
          if (dish.quantity! > 0) {
            categoryDishes.add(dish);
            itemsCount = itemsCount + dish.quantity!;
          }
        });
      });
      categoryDishes.forEach((dish) {
        totalAmount = totalAmount + (dish.dishPrice! * dish.quantity!);
      });
      yield DismissProgressBar();
      yield FetchedCart(
          categoryDishes: categoryDishes,
          itemsCount: itemsCount,
          totalAmount: totalAmount);
    } else if (event is MinusButtonClicked) {
      yield ShowProgressBar();
      List<CategoryDishes> categoryDishes = <CategoryDishes>[];
      int itemsCount = 0;
      double totalAmount = 0.0;

      dishesResponseModel[0].tableMenuList!.forEach((element) {
        element.categoryDishes!.forEach((dish) {
          if (event.categoryDishes[event.selectedIndex].dishId == dish.dishId) {
            if (dish.quantity! > 1) {
              dish.quantity = dish.quantity! - 1;
            } else {
              cartCount.value > 1 ? cartCount.value-- : cartCount.value = 0;
              dish.quantity = 0;
              categoryDishes.clear();
            }
          }
        });
      });

      dishesResponseModel[0].tableMenuList!.forEach((element) {
        element.categoryDishes!.forEach((dish) {
          if (dish.quantity! > 0) {
            categoryDishes.add(dish);
            itemsCount = itemsCount + dish.quantity!;
          }
        });
      });
      categoryDishes.forEach((dish) {
        totalAmount = totalAmount + (dish.dishPrice! * dish.quantity!);
      });
      yield DismissProgressBar();
      yield FetchedCart(
          categoryDishes: categoryDishes,
          itemsCount: itemsCount,
          totalAmount: totalAmount);
    }
  }
}

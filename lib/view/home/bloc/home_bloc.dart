import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application_firebase_app/model/dishes_response_model.dart';
import 'package:application_firebase_app/model/meta.dart';
import 'package:application_firebase_app/repository/home_repo.dart';
import 'package:application_firebase_app/utils/constants.dart';
part 'home_event.dart';
part 'home_state.dart';

List<DishesResponseModel> dishesResponseModel = <DishesResponseModel>[];
final cartCount = ValueNotifier<int>(0);

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialHomeState());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is FetchDishes) {
      yield ShowProgressBar();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString(AppStrings.phoneNumber) == null
          ? prefs.getString(AppStrings.userName)
          : prefs.getString(AppStrings.phoneNumber);
      String? userPhotoUrl = prefs.getString(AppStrings.userPhoto) != null ? prefs.getString(AppStrings.userPhoto)! : "https://www.kindpng.com/picc/m/52-526043_unknown-person-png-transparent-png.png";
      String userUID = prefs.getString(AppStrings.userUID)!;
      Meta meta = await HomeRepository().getDishesUrl();
      if (meta.statusCode == 200) {
        var validJson = jsonDecode(meta.statusMsg);

        validJson.forEach((f) =>
            dishesResponseModel.add(new DishesResponseModel.fromJson(f)));
        dishesResponseModel[0].tableMenuList!.forEach((element) {
          element.categoryDishes!.forEach((element) {
            element.quantity = 0;
          });
        });
        yield DismissProgressBar();
        yield FetchDishesSuccess(
            userName: userName!, userPhoto: userPhotoUrl, userUID: userUID);
      } else {
        yield DismissProgressBar();
        yield FetchDishesFailure(error: meta.statusMsg);
      }
    } else if (event is CategoriesChangedEvent) {
      yield ShowProgressBar();
      yield DismissProgressBar();
      yield CategoriesChangedState(index: event.index);
    } else if (event is PlusClickedEvent) {
      yield ShowProgressBar();
      dishesResponseModel[0]
          .tableMenuList![event.selectedCategory]
          .categoryDishes![event.selectedIndex]
          .quantity = dishesResponseModel[0]
              .tableMenuList![event.selectedCategory]
              .categoryDishes![event.selectedIndex]
              .quantity! +
          1;
      if (dishesResponseModel[0]
              .tableMenuList![event.selectedCategory]
              .categoryDishes![event.selectedIndex]
              .quantity! ==
          1) {
        cartCount.value++;
      }

      yield DismissProgressBar();
    } else if (event is MinusClickedEvent) {
      yield ShowProgressBar();
      if (dishesResponseModel[0]
              .tableMenuList![event.selectedCategory]
              .categoryDishes![event.selectedIndex]
              .quantity !=
          0) {
        dishesResponseModel[0]
            .tableMenuList![event.selectedCategory]
            .categoryDishes![event.selectedIndex]
            .quantity = dishesResponseModel[0]
                .tableMenuList![event.selectedCategory]
                .categoryDishes![event.selectedIndex]
                .quantity! -
            1;
        if (dishesResponseModel[0]
                .tableMenuList![event.selectedCategory]
                .categoryDishes![event.selectedIndex]
                .quantity! ==
            0) {
          cartCount.value--;
        }
      }
      yield DismissProgressBar();
    } else if (event is UpdateDishesEvent) {
      yield ShowProgressBar();
      yield DismissProgressBar();
      yield UpdatedCategoriesState();
    } else if (event is LogoutEvent) {
      yield ShowProgressBar();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      GoogleSignIn _googleSignIn = new GoogleSignIn();
      FirebaseAuth _auth = FirebaseAuth.instance;
      try {
        await _auth.signOut().then((onValue) {
          _googleSignIn.signOut();
        });
        yield DismissProgressBar();
        yield LogoutSuccess();
      } catch (e) {
        print(e);
        yield DismissProgressBar();
        yield LogoutFailure(error: "Logout Failure");
      }
    }
  }
}

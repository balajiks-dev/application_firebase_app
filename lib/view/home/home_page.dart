import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_firebase_app/model/dishes_response_model.dart';
import 'package:application_firebase_app/utils/assets.dart';
import 'package:application_firebase_app/utils/colors.dart';
import 'package:application_firebase_app/utils/constants.dart';
import 'package:application_firebase_app/view/cart/cart_page.dart';
import 'package:application_firebase_app/view/home/bloc/home_bloc.dart';
import 'package:application_firebase_app/view/login/login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDishesFetched = false;
    int selectedCategory = 0;
    String? userName;
    String? userPhoto;
    String? userUID;


  Future<bool> onWillPop() {
      DateTime? currentBackPressTime;
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
         final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: ColorData.toastColor,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppStrings.appClosingWarning,
                        style: GoogleFonts.merriweather(
                            color: ColorData.text_base_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
    return Future.value(true);
  }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: BlocProvider(
          create: (context) {
            return HomeBloc()..add(FetchDishes());
          },
          child: BlocListener<HomeBloc, HomeState>(
            listener: (BuildContext context, state) {
              if (state is FetchDishesFailure) {
                final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: ColorData.toastColor,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.error,
                        style: GoogleFonts.merriweather(
                            color: ColorData.text_base_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if(state is LogoutFailure){
                if (state is FetchDishesFailure) {
                final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: ColorData.toastColor,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.error,
                        style: GoogleFonts.merriweather(
                            color: ColorData.text_base_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              } else if (state is LoginValidationFailure) {
                final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: ColorData.toastColor,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.error,
                        style: GoogleFonts.merriweather(
                            color: ColorData.text_base_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (state is FetchDishesSuccess) {
                isDishesFetched = true;
                userUID = state.userUID;
                userName = state.userName;
                userPhoto = state.userPhoto;
              } else if (state is CategoriesChangedState) {
                selectedCategory = state.index;
              } else if (state is LogoutSuccess) {
                Navigator.pushAndRemoveUntil(
                  context, LoginPage.route(), (route) => false);
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return isDishesFetched
                    ? dishesResponseModel.length > 0
                        ? buildListView(dishesResponseModel, context,
                            selectedCategory, userName, userPhoto, userUID)
                        : Container(color: ColorData.white)
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  buildListView(
      List<DishesResponseModel>? dishesResponseModel,
      BuildContext context,
      int selectedCategory,
      String? userName,
      String? userPhoto,
      String? userUID) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<Tab> tabsList = <Tab>[];
    dishesResponseModel![0].tableMenuList!.forEach((element) {
      tabsList.add(Tab(text: element.menuCategory.toString()));
    });

    List<Widget> tabBarView = <Widget>[];
    dishesResponseModel[0].tableMenuList!.forEach(
      (element) {
        tabBarView.add(
          ListView.separated(
            separatorBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            shrinkWrap: true,
            itemCount: dishesResponseModel[0]
                .tableMenuList![selectedCategory]
                .categoryDishes!
                .length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin:
                    const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAvailabilityCard(
                        dishesResponseModel, selectedCategory, index),
                    Container(
                      width: width * 0.7,
                      margin: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              dishesResponseModel[0]
                                  .tableMenuList![selectedCategory]
                                  .categoryDishes![index]
                                  .dishName
                                  .toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.merriweather(
                                  fontWeight: FontWeight.w500,
                                  color: ColorData.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    "INR " +
                                        dishesResponseModel[0]
                                            .tableMenuList![selectedCategory]
                                            .categoryDishes![index]
                                            .dishPrice
                                            .toString(),
                                    style: GoogleFonts.merriweather(
                                        fontWeight: FontWeight.w500,
                                        color: ColorData.black),
                                  ),
                                  Spacer(),
                                  Text(
                                    dishesResponseModel[0]
                                            .tableMenuList![selectedCategory]
                                            .categoryDishes![index]
                                            .dishCalories
                                            .toString() +
                                        " calories",
                                    style: GoogleFonts.merriweather(
                                        fontWeight: FontWeight.w500,
                                        color: ColorData.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                dishesResponseModel[0]
                                    .tableMenuList![selectedCategory]
                                    .categoryDishes![index]
                                    .dishDescription
                                    .toString(),
                                maxLines: 3,
                                style: GoogleFonts.merriweather(
                                  fontWeight: FontWeight.w300,
                                  color: ColorData.text_base_color,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.8,
                                decoration: BoxDecoration(
                                  color: Colors.green[900],
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        BlocProvider.of<HomeBloc>(context).add(
                                            (MinusClickedEvent(
                                                selectedCategory:
                                                    selectedCategory,
                                                selectedIndex: index)));
                                      },
                                      icon: Icon(Icons.remove),
                                      color: Colors.white,
                                    ),
                                    Text(
                                      dishesResponseModel[0]
                                          .tableMenuList![selectedCategory]
                                          .categoryDishes![index]
                                          .quantity
                                          .toString(),
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: ColorData.white),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        BlocProvider.of<HomeBloc>(context).add(
                                          (PlusClickedEvent(
                                              selectedCategory:
                                                  selectedCategory,
                                              selectedIndex: index)),
                                        );
                                      },
                                      icon: Icon(Icons.add),
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          dishesResponseModel[0]
                                      .tableMenuList![selectedCategory]
                                      .categoryDishes![index]
                                      .addonCat!
                                      .length >
                                  0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      AppStrings.customizationsAvailable,
                                      style: GoogleFonts.merriweather(
                                          fontWeight: FontWeight.w500,
                                          color: ColorData.redColorShade_1),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Container(
                      width: width * 0.15,
                      height: height * 0.15,
                      margin: const EdgeInsets.all(5.0),
                      child: Image.network(
                        "https://c4.wallpaperflare.com/wallpaper/234/543/684/food-pizza-wallpaper-preview.jpg",
                        // dishesResponseModel[0]
                        //     .tableMenuList![selectedCategory]
                        //     .categoryDishes![index]
                        //     .dishImage
                        //     .toString(),
                        errorBuilder: (context, exception, stackTrack) {
                          return Image.network(
                              'http://pngimg.com/uploads/pizza/pizza_PNG44049.png',
                              fit: BoxFit.fitWidth);
                        },
                        loadingBuilder: (context, exception, stackTrack) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    return DefaultTabController(
        length: dishesResponseModel[0].tableMenuList!.length,
        child: Builder(
          builder: (BuildContext contex) {
            final TabController tabController =
                DefaultTabController.of(contex)!;
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                BlocProvider.of<HomeBloc>(context)
                    .add((CategoriesChangedEvent(index: tabController.index)));
              }
            });
            return Scaffold(
              drawerEnableOpenDragGesture: false,
              drawer:
                  buildDrawer(height, context, userName, userPhoto, userUID),
              body: Column(
                children: <Widget>[
                  SizedBox(
                    height: height * 0.2,
                    child: AppBar(
                      backgroundColor: ColorData.white,
                      leading: Builder(
                        builder: (context) => IconButton(
                            icon:
                                Icon(Icons.menu, color: ColorData.gray_shade_1),
                            onPressed: () => Scaffold.of(context).openDrawer()),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CartPage(),
                                        ),
                                      ).then((value) {
                                        BlocProvider.of<HomeBloc>(contex)
                                            .add((UpdateDishesEvent()));
                                      });
                                    },
                                    icon: Icon(Icons.shopping_cart,
                                        color: ColorData.gray_shade_1)
                                    //  icon: SvgPicture.asset(UIAssets.cartImage, color: ColorData.gray_shade_1)
                                    ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: cartCount,
                                builder: (context, value, widget) {
                                  return Positioned(
                                    top: -5,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CartPage(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                              color: cartCount.value == 0
                                                  ? Colors.transparent
                                                  : Colors.red,
                                              // borderRadius: BorderRadius.circular(10.0),
                                              shape: BoxShape.circle),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                              child: Text(
                                                cartCount.value == 0
                                                    ? ""
                                                    : cartCount.value
                                                        .toString(),
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                  color: ColorData.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                      bottom: TabBar(
                        isScrollable: true,
                        indicatorColor: ColorData.light_rose,
                        unselectedLabelColor: ColorData.text_base_color,
                        labelColor: ColorData.light_rose,
                        labelPadding:
                            const EdgeInsets.only(left: 10.0, right: 10.0),
                        labelStyle: GoogleFonts.merriweather(
                            fontWeight: FontWeight.w400),
                        tabs: tabsList,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: tabBarView),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Container buildAvailabilityCard(List<DishesResponseModel> dishesResponseModel,
      int selectedCategory, int index) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: dishesResponseModel[0]
                  .tableMenuList![selectedCategory]
                  .categoryDishes![index]
                  .dishAvailability!
              ? Colors.green
              : Colors.red,
        ),
      ),
      child: Center(
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: dishesResponseModel[0]
                    .tableMenuList![selectedCategory]
                    .categoryDishes![index]
                    .dishAvailability!
                ? Colors.green
                : Colors.red,
            shape: BoxShape.circle,
            border: Border.all(
              color: dishesResponseModel[0]
                      .tableMenuList![selectedCategory]
                      .categoryDishes![index]
                      .dishAvailability!
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrawer(double height, BuildContext context, String? userName,
      String? userPhoto, String? userUID) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            height: height * 0.3,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(76, 175, 71, 0.5),
                    Color.fromRGBO(111, 208, 17, 1),
                  ],
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                userPhoto!.isEmpty
                    ? Container(
                        width: 80.0,
                        height: 80.0,
                        margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(UIAssets.defaultProfilePicture),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                    : Container(
                        width: 80.0,
                        height: 80.0,
                        margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(userPhoto),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                Text(
                  userName!,
                  maxLines: 2,
                  style: GoogleFonts.montserrat(
                      color: ColorData.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                Text(
                  "ID: " + userUID!,
                  maxLines: 2,
                  style: GoogleFonts.montserrat(
                      color: ColorData.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(AppStrings.logOut,
                style: GoogleFonts.merriweather(
                    color: ColorData.gray_shade_1,
                    fontWeight: FontWeight.w500)),
            onTap: () async {
               BlocProvider.of<HomeBloc>(context).add(
                                          (LogoutEvent()),
                                        );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_firebase_app/custom_widgets/custom_success_message.dart';
import 'package:application_firebase_app/custom_widgets/modal_rounded_progress_bar.dart';
import 'package:application_firebase_app/model/dishes_response_model.dart';
import 'package:application_firebase_app/utils/assets.dart';
import 'package:application_firebase_app/utils/colors.dart';
import 'package:application_firebase_app/utils/constants.dart';
import 'package:application_firebase_app/view/cart/bloc/cart_bloc.dart';
import 'package:application_firebase_app/view/home/home_page.dart';

class CartPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CartPage());
  }

  @override
  Widget build(BuildContext context) {
    ProgressBarHandler _handler = ProgressBarHandler();
    List<CategoryDishes>? categoryDishes;
    bool isCartFetched = false;
    int itemsCount = 0;
    double totalAmount = 0.0;

    Future<bool> onWillPop() {
      Navigator.pop(context);
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black45,
              ),
              onPressed: () async {
                Navigator.pop(context);
              }),
          title: Text(
            AppStrings.orderSummary,
            style:
                GoogleFonts.montserrat(color: Colors.black45, fontSize: 18.0),
          ),
        ),
        body: BlocProvider(
          create: (context) {
            return CartBloc()..add(FetchCartItems());
          },
          child: BlocListener<CartBloc, CartState>(
            listener: (BuildContext context, state) {
              if (state is ShowProgressBar) {
                _handler.show();
              } else if (state is DismissProgressBar) {
                _handler.dismiss();
              } else if (state is FetchedCart) {
                categoryDishes = state.categoryDishes;
                isCartFetched = true;
                itemsCount = state.itemsCount;
                totalAmount = state.totalAmount;
              } else if (state is OrderPlacedSuccessfully) {
                showDialog(
                  context: context,
                  builder: (BuildContext cont) => CustomSuccessDialog(
                    image: UIAssets.successfullImage,
                    title: "Successfully ordered!",
                    titleTextStyle: GoogleFonts.merriweather(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[900]),
                    context: cont,
                    cardColor: ColorData.white,
                    content: "Your Order is placed Successfully!",
                    contentTextStyle: GoogleFonts.montserrat(
                        color: ColorData.text_base_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    okButtonAction: (BuildContext contxt) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomePage()),
                        ModalRoute.withName('/'),
                      );
                    },
                    okButtonText: "Home",
                    okButtonBackgroundColor: Colors.green[900],
                    okButtonTextStyle: GoogleFonts.montserrat(
                        color: ColorData.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ).then((value) {
                  if (value == null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()),
                      ModalRoute.withName('/'),
                    );
                  }
                });
              }
            },
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return isCartFetched
                    ? categoryDishes!.length > 0
                        ? buildMainUI(
                            categoryDishes, context, itemsCount, totalAmount)
                        : Container(
                            color: ColorData.white,
                            child: Center(
                              child: Text(
                                "No Products added in Cart",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
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

  buildMainUI(List<CategoryDishes>? categoryDishes, BuildContext context,
      int itemsCount, double totalAmount) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          BlocProvider.of<CartBloc>(context).add((PlaceOrderButtonClicked()));
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 15,
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.green[900],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Text(
              AppStrings.placeOrder,
              style: GoogleFonts.merriweather(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          child: Card(
            elevation: 3.0,
            child: Column(
              children: [
                buildDishesCount(categoryDishes, itemsCount),
                ListView.separated(
                    separatorBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                    itemCount: categoryDishes!.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildAvailabilityCard(categoryDishes, index),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child: Text(
                                            categoryDishes[index]
                                                .dishName
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                                color: ColorData.black,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                            "INR " +
                                                categoryDishes[index]
                                                    .dishPrice
                                                    .toString(),
                                            style: GoogleFonts.montserrat(
                                                color: ColorData.black,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                            categoryDishes[index]
                                                    .dishCalories
                                                    .toString() +
                                                " calories",
                                            style: GoogleFonts.montserrat(
                                                color: ColorData.black,
                                                fontWeight: FontWeight.w500)),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.2,
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
                                            BlocProvider.of<CartBloc>(context)
                                                .add((MinusButtonClicked(
                                                    categoryDishes:
                                                        categoryDishes,
                                                    selectedIndex: index)));
                                          },
                                          icon: Icon(Icons.remove),
                                          color: Colors.white,
                                        ),
                                        Text(
                                          categoryDishes[index]
                                              .quantity
                                              .toString(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: ColorData.white),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            BlocProvider.of<CartBloc>(context)
                                                .add((PlusButtonClicked(
                                                    categoryDishes:
                                                        categoryDishes,
                                                    selectedIndex: index)));
                                          },
                                          icon: Icon(Icons.add),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                      "INR " +
                                          (categoryDishes[index].dishPrice! *
                                                  categoryDishes[index]
                                                      .quantity!)
                                              .toStringAsFixed(2),
                                      style: GoogleFonts.montserrat(
                                          color: ColorData.black,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                buildTotalAmountView(totalAmount)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildTotalAmountView(double totalAmount) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppStrings.totalAmount,
                style: GoogleFonts.montserrat(
                    color: ColorData.black, fontWeight: FontWeight.w500)),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("INR " + totalAmount.toString(),
                style: GoogleFonts.montserrat(
                    color: Colors.green[900], fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }

  Container buildDishesCount(
      List<CategoryDishes>? categoryDishes, int itemsCount) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
          color: Colors.green[900], borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            categoryDishes!.length.toString() +
                " Dishes - " +
                itemsCount.toString() +
                " Items",
            style: GoogleFonts.montserrat(
                color: ColorData.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Container buildAvailabilityCard(
      List<CategoryDishes>? categoryDishes, int index) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: categoryDishes![index].dishAvailability!
              ? Colors.green
              : Colors.red,
        ),
      ),
      child: Center(
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: categoryDishes[index].dishAvailability!
                ? Colors.green
                : Colors.red,
            shape: BoxShape.circle,
            border: Border.all(
              color: categoryDishes[index].dishAvailability!
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

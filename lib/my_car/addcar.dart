import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:parking_4/bottom_bar/bottom_bar.dart';
import 'package:parking_4/bottom_bar/buildnavItemForanotherScreens.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/widgets/custom_appBar.dart';
import 'package:parking_4/constants/widgets/custom_texr_field.dart';
import 'package:parking_4/constants/widgets/main_button.dart';
import 'package:parking_4/my_car/carCubit.dart';
import 'package:parking_4/my_car/carStates.dart';

class PostCar extends StatefulWidget {
  const PostCar({super.key});

  @override
  State<PostCar> createState() => _PostCarState();
}

class _PostCarState extends State<PostCar> {
  TextEditingController userName = TextEditingController();
  TextEditingController carNumber = TextEditingController();
  TextEditingController carColor = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: BlocBuilder<CarCubit, CarStates>(
                builder: (context, state) {
                  if (state is AddCarSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("orderSentSucccessffuly".tr())),
                    );
                    userName.clear();
                    carNumber.clear();
                    carColor.clear();
                  } else if (state is AddCarFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("errorTryAgain".tr())),
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "carOrder".tr(),
                        style: TextStyle(
                            color: secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Gap(20),
                      Image.asset("assets/images/car.png"),
                      Gap(20),
                      Row(children: [Text("userName".tr())]),
                      CustomTextFieldCard(
                        hintText: '',
                        controller: userName,
                        validator: (value) =>
                            value!.isEmpty ? "userName".tr() : null,
                      ),
                      Gap(20),
                      Row(children: [Text("carNumber".tr())]),
                      CustomTextFieldCard(
                        hintText: '',
                        controller: carNumber,
                        validator: (value) =>
                            value!.isEmpty ? "chooseCarNum" : null,
                      ),
                      Gap(20),
                      Row(children: [Text("carType".tr())]),
                      CustomTextFieldCard(
                        hintText: '',
                        controller: carColor,
                        validator: (value) =>
                            value!.isEmpty ? "car_type".tr() : null,
                      ),
                      Gap(30),
                      state is AddCarLoading
                          ? Center(
                              child: LoadingAnimationWidget.threeArchedCircle(
                                color: secondaryColor,
                                size: 50,
                              ),
                            )
                          : MainButton(
                              backGroundColor: primaryColor,
                              text: "register".tr(),
                              textColor: white,
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  final carData = {
                                    "name": userName.text,
                                    "carNumber": carNumber.text,
                                    "carType": carColor.text,
                                  };

                                  await context
                                      .read<CarCubit>()
                                      .addCar(carData);
                                  state is AddCarSuccess
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  "orderSentSucccessffuly"
                                                      .tr())),
                                        )
                                      : Container();
                                  setState(() {
                                    context
                                        .read<CarCubit>()
                                        .fetchCars(forceRefresh: true);
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BottomBarScreen(
                                              index: 2,
                                            )),
                                  );
                                }
                              },
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          // Floating Icons
          Positioned(
            top: -25, // Move icons up
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNavItem(Icons.home, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BottomBarScreen(index: 0)));
                }),
                buildNavItem(Icons.receipt_long, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BottomBarScreen(index: 1)));
                }),
                buildNavItem(Icons.directions_car, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BottomBarScreen(index: 2)));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

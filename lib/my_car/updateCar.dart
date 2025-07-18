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

// ignore: must_be_immutable
class UpdateCar extends StatefulWidget {
  int carId;

  String carNum;
  String carType;
  UpdateCar({
    super.key,
    required this.carId,
    required this.carNum,
    required this.carType,
  });

  @override
  State<UpdateCar> createState() => _UpdateCarState();
}

class _UpdateCarState extends State<UpdateCar> {
  TextEditingController userName = TextEditingController();
  TextEditingController carNumber = TextEditingController();
  TextEditingController carColor = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    carNumber.text = widget.carNum;
    carColor.text = widget.carType;
  }

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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (state is UpdateCarSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("orderSentSucccessffuly".tr())),
                        );
                      } else if (state is UpdateCarFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("errorTryAgain".tr())),
                        );
                      }
                    });

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "تعديل سيارة".tr(),
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Gap(20),
                        Image.asset("assets/images/car.png"),
                        Gap(20),

                        // Car Number Field
                        Row(children: [Text("carNumber".tr())]),
                        CustomTextFieldCard(
                          hintText: '',
                          controller: carNumber,
                          validator: (value) =>
                              value!.isEmpty ? "chooseCarNum".tr() : null,
                        ),
                        Gap(20),

                        // Car Color Field
                        Row(children: [Text("carType".tr())]),
                        CustomTextFieldCard(
                          hintText: '',
                          controller: carColor,
                          validator: (value) =>
                              value!.isEmpty ? "car_type".tr() : null,
                        ),
                        Gap(30),

                        // Register Button
                        state is UpdateCarLoading
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
                                      "carNumber": carNumber.text,
                                      "carType": carColor.text,
                                    };

                                    print("widget.carId ${widget.carId}");

                                    // Update the car
                                    await context
                                        .read<CarCubit>()
                                        .updateCar(widget.carId, carData);

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
                )),
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

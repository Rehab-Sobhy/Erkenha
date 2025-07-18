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
import 'package:parking_4/home/places_cubit.dart';
import 'package:parking_4/my_car/carCubit.dart';
import 'package:parking_4/my_car/carStates.dart';
import 'package:parking_4/parkCar/barkStates.dart';
import 'package:parking_4/parkCar/parkCubit.dart';

// ignore: must_be_immutable
class BuyOrSellParking extends StatefulWidget {
  BuyOrSellParking({super.key, required this.id});
  int id;
  @override
  State<BuyOrSellParking> createState() => _BuyOrSellParkingState();
}

class _BuyOrSellParkingState extends State<BuyOrSellParking> {
  void initState() {
    super.initState();
    context.read<CarCubit>().fetchCars();
  }

  final TextEditingController day = TextEditingController();
  final TextEditingController time = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  int? selectedCarId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: BlocListener<ParkCarCubit, ParkCarState>(
        listener: (context, state) {
          if (state is ParkCarLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: secondaryColor,
                  size: 50,
                ),
              ),
            );
          } else if (state is ParkCarSuccess) {
            Navigator.of(context, rootNavigator: true).pop(); // Close loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("orderSentSucccessffuly".tr())),
            );
            final Pcubit = context.read<PlacesCubit>();
            Pcubit.fetchPlaces(forceRefresh: true);

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BottomBarScreen()));
          } else if (state is ParkCarFailed) {
            Navigator.of(context, rootNavigator: true).pop(); // Close loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("errorTryAgain".tr())),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "buyorsellparking".tr(),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    Image.asset(
                      "assets/images/download__8_-removebg-preview 1 - Copy.png",
                      height: 120,
                    ),
                    const Gap(20),
                    BlocBuilder<CarCubit, CarStates>(
                      builder: (context, state) {
                        if (state is GetCarFailed) {
                          print(state.error);
                          return Text(
                            state.error,
                            style: TextStyle(color: Colors.red),
                          );
                        } else if (state is GetCarSuccess) {
                          final cars = state.cars;
                          final carItems = cars.map((car) {
                            return DropdownMenuItem<int>(
                              value: car['id'],
                              child: Text("${car['carNumber']}"),
                            );
                          }).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [Text("${"chooseCarNum".tr()} *")]),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<int>(
                                value: cars.any(
                                        (car) => car['id'] == selectedCarId)
                                    ? selectedCarId
                                    : null,
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(12),
                                dropdownColor: Colors.white,
                                items: carItems.isNotEmpty
                                    ? carItems
                                    : [
                                        const DropdownMenuItem<int>(
                                          value: null,
                                          enabled: false,
                                          child: Text("",
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ],
                                onChanged: carItems.isNotEmpty
                                    ? (value) {
                                        setState(() {
                                          selectedCarId = value;
                                        });
                                      }
                                    : null,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                validator: (value) {
                                  if (carItems.isEmpty) return null;
                                  if (value == null)
                                    return "chooseCarFirst".tr();
                                  return null;
                                },
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    const Gap(20),
                    Row(children: [Text("day".tr())]),
                    CustomTextFieldCard(
                      suffixIcon: Icon(Icons.date_range),
                      hintText: ' ',
                      controller: day,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: primaryColor,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        primaryColor, // button text color
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Transform.scale(
                                  scale: 0.85,
                                  child: child,
                                ),
                              ),
                            );
                          },
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          day.text = formattedDate;
                        }
                      },
                    ),
                    const Gap(20),
                    Row(children: [Text("time".tr())]),
                    CustomTextFieldCard(
                      suffixIcon: Icon(Icons.access_time),
                      hintText: ' ',
                      controller: time,
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                timePickerTheme: TimePickerThemeData(
                                  backgroundColor: Colors.white,
                                  dialHandColor: Colors.deepPurple,
                                  dialBackgroundColor:
                                      Colors.deepPurple.shade100,
                                  hourMinuteColor:
                                      const Color.fromARGB(255, 206, 203, 203),
                                  hourMinuteTextColor: Colors.white,
                                  entryModeIconColor: Colors.deepPurple,
                                  helpTextStyle: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 14,
                                  ),
                                ),
                                colorScheme: ColorScheme.light(
                                  primary: Colors.deepPurple,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: Center(
                                child: Transform.scale(
                                  scale: 0.75,
                                  child: child,
                                ),
                              ),
                            );
                          },
                        );

                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final formattedTime = DateFormat('hh:mm a').format(
                              DateTime(now.year, now.month, now.day,
                                  pickedTime.hour, pickedTime.minute));
                          time.text = formattedTime;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the description".tr();
                        }
                        return null;
                      },
                    ),
                    const Gap(30),
                    BlocBuilder<CarCubit, CarStates>(
                      builder: (context, state) {
                        return MainButton(
                          backGroundColor: primaryColor,
                          text: "register".tr(),
                          textColor: white,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await context.read<ParkCarCubit>().buyParking(
                                    placeid: widget.id,
                                    carId: selectedCarId,
                                    day: day.text,
                                    time: time.text,
                                    context: context);
                              } on Exception {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("errorTryAgain".tr())),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
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

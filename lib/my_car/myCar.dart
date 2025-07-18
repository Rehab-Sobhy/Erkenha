import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/widgets/custom_appBar.dart';
import 'package:parking_4/constants/widgets/main_button.dart';
import 'package:parking_4/constants/styles.dart';
import 'package:parking_4/my_car/addcar.dart';
import 'package:parking_4/my_car/carCubit.dart';
import 'package:parking_4/my_car/carStates.dart';
import 'package:parking_4/my_car/updateCar.dart';
import 'package:easy_localization/easy_localization.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({super.key});

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<CarCubit>();
    if (!cubit.isCarsLoaded) {
      cubit.fetchCars();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppBar(),
      body: BlocBuilder<CarCubit, CarStates>(
        builder: (context, state) {
          if (state is GetCarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetCarFailed) {
            return Center(
              child: Text(
                "errorTryAgain".tr(),
                style: style14black.copyWith(color: Colors.red),
              ),
            );
          }

          if (state is GetCarSuccess) {
            final cars = state.cars;

            if (cars.isEmpty) {
              return Center(
                child: MainButton(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostCar()),
                    );
                    context
                        .read<CarCubit>()
                        .fetchCars(); // إعادة التحميل بعد الإضافة
                  },
                  text: "addyourFirstCar".tr(),
                  backGroundColor: primaryColor,
                  textColor: white,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.orange, width: 2.5),
                    ),
                    elevation: 7,
                    color: Colors.white,
                    child: Container(
                      height: 150,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MainButton(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostCar()),
                                  );
                                  context
                                      .read<CarCubit>()
                                      .fetchCars(); // إعادة تحميل بعد الإضافة
                                },
                                radius: 8,
                                height: 30,
                                width: 30,
                                backGroundColor: Colors.green,
                                text: "+",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              Gap(5),
                              MainButton(
                                fontWeight: FontWeight.bold,
                                radius: 8,
                                width: 30,
                                height: 30,
                                backGroundColor: Colors.red,
                                fontSize: 16,
                                onTap: () {
                                  _confirmDeleteCar(context, car['id']);
                                },
                                text: "x",
                              ),
                              Gap(5),
                              Container(
                                height: 35,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      const Color.fromARGB(255, 241, 241, 160),
                                ),
                                child: InkWell(
                                  child: Icon(Icons.edit),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateCar(
                                          carId: car["id"],
                                          carNum: car["carNumber"],
                                          carType: car["carType"],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${"carType".tr()}: ${car['carType'] ?? ''}",
                            style: style14black,
                          ),
                          const Gap(10),
                          Text(
                            "${"carNumber".tr()} : ${car['carNumber'] ?? ''}",
                            style: style14black,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _confirmDeleteCar(BuildContext context, int carId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text("confirmDelete".tr(), style: style14black),
        ),
        content: Text("areYouSureYouWantdeleteCar".tr(), style: style14black),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MainButton(
                onTap: () => Navigator.of(context).pop(),
                width: 100,
                text: "cancel".tr(),
                backGroundColor: Colors.green,
                textColor: white,
              ),
              const Gap(10),
              MainButton(
                onTap: () async {
                  await context.read<CarCubit>().deleteCar(carId);
                  context
                      .read<CarCubit>()
                      .fetchCars(); // إعادة التحميل بعد الحذف
                  Navigator.pop(context);
                },
                width: 100,
                text: "yes".tr(),
                backGroundColor: Colors.red,
                textColor: white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

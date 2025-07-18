import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:parking_4/constants/apiKey.dart';
import 'package:parking_4/constants/cachHelper.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/styles.dart';
import 'package:parking_4/constants/widgets/custom_appBar.dart';
import 'package:parking_4/constants/widgets/main_button.dart';
import 'package:parking_4/my_car/carCubit.dart';
import 'package:parking_4/parkCar/parkCubit.dart';
import 'package:parking_4/parkCar/reservation_model.dart';

class MyVisitsScreen extends StatefulWidget {
  const MyVisitsScreen({super.key});

  @override
  State<MyVisitsScreen> createState() => _MyVisitsScreenState();
}

class _MyVisitsScreenState extends State<MyVisitsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CarCubit>().fetchReservations();
    print("res ${context.read<CarCubit>().reservations}");
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CarCubit>();
    final List<dynamic> orders = cubit.reservations;

    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppBar(),
      body: orders.isEmpty
          ? Center(
              child: Text(
                "no_reservations".tr(),
                style: style18black,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildVisitCard(orders[index]);
                },
              ),
            ),
    );
  }

  Widget _buildVisitCard(Reservation order) {
    final car = order.car;
    final place = order.place;
    final location = place.location;
    final placeName = place.name;
    final String imagePath = place.image ?? "";
    final String imageUrl =
        imagePath.startsWith("http") ? imagePath : "$baseUrl/$imagePath";

    final String day = order.day ?? '';
    final String time = order.time ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: order.status == "active"
                  ? Colors.red
                  : order.status == "waiting"
                      ? Colors.orange
                      : Colors.grey,
              width: 2.5),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: imagePath.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              "assets/images/car.png",
                              height: 80.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Image.asset("assets/images/car.png", height: 80.h),
              ),
              const Gap(10),
              _buildInfoText("${"car_type".tr()} : ${car.carType ?? ''}"),
              _buildInfoText("${"car_number".tr()} : ${car.carNumber ?? ''}"),
              const Gap(10),
              _buildInfoText(
                  "${"location".tr()} : ${CacheHelper.getData(key: "language") == "en" ? location["en"] ?? '' : location["ar"] ?? ''}"),
              _buildInfoText("${"place".tr()} : ${placeName["en"] ?? ''}"),
              const Gap(10),
              _buildInfoText("${"status".tr()} : ${order.status ?? ''}"),
              _buildInfoText("${"day".tr()} : $day"),
              _buildInfoText("${"time".tr()} : $time"),
              order.status == "active" || order.status == "waiting"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Center(
                                      child: Text(
                                    "confirmDelete".tr(),
                                    style: style14black,
                                  )),
                                  content: Text(
                                    "areYouSureYouWantendVisit".tr(),
                                    style: style14black,
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MainButton(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          width: 100,
                                          text: "cancel".tr(),
                                          backGroundColor: Colors.green,
                                          textColor: white,
                                        ),
                                        Gap(10),
                                        MainButton(
                                          onTap: () async {
                                            setState(() {
                                              order.status = "done";
                                            });
                                            await context
                                                .read<ParkCarCubit>()
                                                .rejectParking(order.id);
                                            await context
                                                .read<CarCubit>()
                                                .fetchReservations();

                                            setState(() {});

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
                            },
                            icon: Icon(
                              Icons.hourglass_bottom,
                              color: Colors.grey,
                              size: 35,
                            )),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: style18black.copyWith(
        color: primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/styles.dart';

import 'package:parking_4/constants/widgets/main_button.dart';
import 'package:parking_4/parkCar/buyorsellparking.dart';

// ignore: must_be_immutable
class PlaceDetailsSceen extends StatefulWidget {
  PlaceDetailsSceen(
      {super.key,
      required this.image,
      required this.name,
      required this.id,
      required this.prkingCount,
      required this.location});
  String image;
  int prkingCount;
  int id;

  String location;
  String name;
  @override
  State<PlaceDetailsSceen> createState() => _PlaceDetailsSceenState();
}

class _PlaceDetailsSceenState extends State<PlaceDetailsSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .45,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.image,
                  ),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
          ),
          Gap(10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.name,
                      style: style14black.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Gap(10),
                Text(
                  widget.location,
                  style: style12black.copyWith(color: primaryColor),
                ),
                Gap(10),
                Row(
                  children: [
                    Text(
                      "${"available".tr()} ${widget.prkingCount} ${"parking".tr()}",
                      style: style14black.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
          ),
          Gap(30),
        ],
      ),
      floatingActionButton: MainButton(
        backGroundColor: primaryColor,
        text: "gotoparking".tr(),
        textColor: Colors.white,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuyOrSellParking(
                        id: widget.id,
                      )));
        },
      ),
    );
  }
}

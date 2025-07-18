import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:parking_4/categories/categoryCubit.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/styles.dart';
import 'package:parking_4/constants/widgets/custom_appBar.dart';
import 'package:parking_4/home/detailofplace.dart';

import 'package:parking_4/home/homeStates.dart';
import 'package:parking_4/parkCar/buyorsellparking.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlacesScreen extends StatelessWidget {
  final int categoryId;

  const PlacesScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: BlocBuilder<Categorycubit, HomeStates>(
        builder: (context, state) {
          if (state is CategoriesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriesSuccess) {
            final places =
                context.read<Categorycubit>().getPlacesByCategoryId(categoryId);

            if (places.isEmpty) {
              return const Center(child: Text(""));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlaceDetailsSceen(
                                  image: place.image,
                                  name: place.name,
                                  id: place.id,
                                  prkingCount: place.parkCount,
                                  location: place.weblocation)));
                    },
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      child: Container(
                        height: 170,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      place.image,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Gap(10),
                                  Row(
                                    children: [
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BuyOrSellParking(
                                                        id: place.id,
                                                      )));
                                        },
                                        child: Container(
                                          height: 25,
                                          child: Image.asset(
                                              "assets/images/logoOfParkDirect.jpg"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(5),
                                  Text(
                                    place.name,
                                    style: style16black.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const Gap(5),
                                  InkWell(
                                    onTap: () async {
                                      await launchUrlString(place.weblocation);
                                    },
                                    child: Text(
                                      place.weblocation,
                                      style: style12black.copyWith(
                                          decoration: TextDecoration.underline),
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                  Text(
                                    "${"available".tr()} ${place.parkCount} ${"parking".tr()}",
                                    style: style12black.copyWith(
                                        color: primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is CategoryError) {
            return Center(child: Text(state.error));
          }

          return const Center(child: Text("Unexpected state"));
        },
      ),
    );
  }
}

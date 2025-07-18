import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gap/gap.dart';
import 'package:parking_4/categories/ctegories.dart';
import 'package:parking_4/categories/places_withcategoryid.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/styles.dart';
import 'package:parking_4/constants/widgets/custom_appBar.dart';
import 'package:parking_4/home/detailofplace.dart';
import 'package:parking_4/categories/categoryCubit.dart';
import 'package:parking_4/home/homeStates.dart';
import 'package:parking_4/home/placesState.dart';
import 'package:parking_4/home/places_cubit.dart';
import 'package:parking_4/parkCar/buyorsellparking.dart';
import 'package:parking_4/my_car/carCubit.dart';
import 'package:parking_4/notifications/notifications.dart';
import 'package:parking_4/profile/cubit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<Categorycubit>();
    final Pcubit = context.read<PlacesCubit>();
    Pcubit.fetchPlaces();
    cubit.fetchCategories();
    context.read<CarCubit>().fetchOrders();
    context.read<CarCubit>().fetchReservations();
    context.read<UserCubit>().fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<Categorycubit>();
    final Pcubit = context.read<PlacesCubit>();
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          Pcubit.searchPlaces(value);
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "searchAboutWhatYouWhant".tr(),
                        contentPadding: EdgeInsets.all(0),
                        labelStyle:
                            const TextStyle(color: Colors.grey, fontSize: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Spacer(),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1, // Adjust the flex ratio as needed
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),

              const Gap(20),

              Row(
                children: [
                  Text(
                    "categories".tr(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesScreen()));
                    },
                    child: Text(
                      "showall".tr(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),

              BlocBuilder<Categorycubit, HomeStates>(
                builder: (context, state) {
                  print("Current State: $state"); // Debugging log
                  if (state is CategoriesLoadingState) {
                    return Center();
                  }
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cubit.categories.length,
                      itemBuilder: (context, index) {
                        final category = cubit.categories[index];
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PlacesScreen(categoryId: category.id),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12), // Apply border radius
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        12), // Ensure image respects radius
                                    child: Image.network(
                                      category.image,
                                      width: 90,
                                      height: 60,
                                      fit: BoxFit
                                          .fill, // Ensure image fills the card properly
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              // Places Section

              BlocBuilder<PlacesCubit, PlacesState>(
                builder: (context, state) {
                  if (state is PlacesLoadingState) {
                    return const Center();
                  } else if (state is PlacesError) {
                    return Center(child: Text(""));
                  } else if (state is GetPlacesSuccess) {
                    final places = state.places;

                    if (places.isEmpty) {
                      return Center(child: Text(""));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                                        prkingCount: place.parkingsCount,
                                        location: place.webLocation)));
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
                                            place.image ??
                                                "https://th.bing.com/th/id/OIP.0PG09nGnJA0eANPas7qNhQHaJ4?rs=1&pid=ImgDetMain",
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            await launchUrlString(
                                                place.webLocation);
                                          },
                                          child: Text(
                                            place.webLocation,
                                            style: style12black.copyWith(
                                                decoration:
                                                    TextDecoration.underline),
                                            softWrap: true,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                        Text(
                                          "${"available".tr()} ${place.parkingsCount} ${"parking".tr()}",
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
                    );
                  }

                  return const SizedBox(); // fallback
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

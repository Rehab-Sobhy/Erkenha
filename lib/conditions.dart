import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parking_4/bottom_bar/bottom_bar.dart';
import 'package:parking_4/bottom_bar/buildnavItemForanotherScreens.dart';
import 'package:parking_4/constants/apiKey.dart';
import 'package:parking_4/constants/cachHelper.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/widgets/custom_appBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Conditions extends StatefulWidget {
  const Conditions({super.key});

  @override
  State<Conditions> createState() => _ConditionsState();
}

class _ConditionsState extends State<Conditions> {
  List<String> descriptions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final language = CacheHelper.getData(key: "language") ?? "ar";
      print("Language header: $language");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('conditions_descriptions');

      if (cachedData != null) {
        print("Data loaded from cache");
        setState(() {
          descriptions = List<String>.from(
            cachedData.split(','),
          );
          isLoading = false;
        });
      } else {
        var response = await Dio().get(
          '$baseUrl/api/conditions',
          options: Options(headers: {
            "Accept-Language": language,
          }),
        );

        if (response.statusCode == 200) {
          print("Response: ${response.data}");

          // استخراج البيانات من الاستجابة وتخزينها في SharedPreferences
          List<String> descriptionsList = List<String>.from(
            response.data["data"].map((item) => item["description"]),
          );

          // تخزين البيانات في SharedPreferences
          await prefs.setString(
              'conditions_descriptions', descriptionsList.join(','));

          setState(() {
            descriptions = descriptionsList;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Failed to load data";
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppBar(),
      body: Center(
        child: isLoading
            ? Container()
            : errorMessage != null
                ? Text(
                    "",
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "conditions".tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ...descriptions.map(
                          (desc) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Text(
                              desc,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // Gap at the bottom
                      ],
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

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:parking_4/about_us.dart';
import 'package:parking_4/bottom_bar/bottom_bar.dart';
import 'package:parking_4/bottom_bar/buildnavItemForanotherScreens.dart';
import 'package:parking_4/conditions.dart';
import 'package:parking_4/constants/apiKey.dart';

import 'package:parking_4/constants/cachHelper.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/styles.dart';
import 'package:parking_4/constants/widgets/comminications.dart';
import 'package:parking_4/constants/widgets/custom_appBar.dart';
import 'package:parking_4/constants/widgets/main_button.dart';
import 'package:parking_4/privacy.dart';
import 'package:parking_4/profile/cubit.dart';
import 'package:parking_4/profile/dialogeofDelete.dart';
import 'package:parking_4/profile/dialogeofLogOut.dart';
import 'package:parking_4/profile/profileStates.dart';
import 'package:parking_4/profile/profile_model.dart';
import 'package:parking_4/profile/update_userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String name = "Loading...";
  String email = "Loading...";

  CommunicationHelper commHelper = CommunicationHelper();

  @override
  void initState() {
    super.initState();
    loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserCubit>().fetchUserData();
      }
    });
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString("user");
    if (userData != null) {
      try {
        Map<String, dynamic> userMap = jsonDecode(userData);
        setState(() {
          name = userMap["name"] ?? " ";
          email = userMap["email"] ?? "";
        });
      } catch (e) {
        print("Error parsing user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = context.locale.languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center();
          } else if (state is UserError) {
            return Center(
                child: Text("errorTryAgain".tr(),
                    style: TextStyle(color: Colors.red)));
          } else if (state is UserLoaded) {
            UserModel user = state.user;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.image != null &&
                                user.image.isNotEmpty
                            ? NetworkImage("$baseUrl/${user.image}")
                            : const AssetImage("assets/profile_placeholder.png")
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 6,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EditProfileScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                            child: const Icon(Icons.edit,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Text(user.name ?? "",
                      style:
                          style14black.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(5),
                  Text(user.email ?? "",
                      style:
                          style14black.copyWith(fontWeight: FontWeight.bold)),
                  Divider(indent: 15, endIndent: 20, color: grey43),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildLinkItem(
                                "privacy".tr(),
                                () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PrivacyScreen()))),
                          ],
                        ),
                        Row(
                          children: [
                            _buildLinkItem(
                                "aboutUs".tr(),
                                () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AboutUs()))),
                          ],
                        ),
                        Row(
                          children: [
                            _buildLinkItem(
                                "conditions".tr(),
                                () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Conditions()))),
                          ],
                        ),
                        Row(
                          children: [
                            _buildLinkItem(
                                currentLang == 'en' ? "العربية" : "English",
                                () async {
                              Locale newLocale = currentLang == 'en'
                                  ? const Locale('ar', 'EG')
                                  : const Locale('en', 'US');
                              await context.setLocale(newLocale);
                              CacheHelper.saveData(
                                  key: 'language',
                                  value: newLocale.languageCode);
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  _buildSocialIcons(),
                  Gap(20.h),
                  MainButton(
                    textColor: Colors.white,
                    backGroundColor: primaryColor,
                    text: "logOut".tr(),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('isLoggedIn');
                      await prefs.remove('token');
                      await prefs.remove('profile_image');
                      showDialog(
                        context: context,
                        builder: (_) => LogOutDialoge(onConfirm: () {
                          context.read<UserCubit>().LogOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BottomBarScreen(index: 0)),
                              (_) => false);
                        }),
                      );
                    },
                  ),
                  Gap(10.h),
                  MainButton(
                    textColor: Colors.white,
                    backGroundColor: primaryColor,
                    text: "deleteAcc".tr(),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('isLoggedIn');
                      await prefs.remove('token');
                      await prefs.remove('profile_image');
                      showDialog(
                        context: context,
                        builder: (_) => DeleteConfirmationDialog(onConfirm: () {
                          context.read<UserCubit>().deleteUser();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BottomBarScreen(index: 0)),
                              (_) => false);
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            );
          }
          return const Center(child: Text("No Data"));
        },
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          Positioned(
            top: -25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNavItem(
                    Icons.home,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BottomBarScreen(index: 0)))),
                buildNavItem(
                    Icons.receipt_long,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BottomBarScreen(index: 1)))),
                buildNavItem(
                    Icons.directions_car,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BottomBarScreen(index: 2)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Text(text,
            style: style14black.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIcon("assets/images/twitter.png",
            () => launchUrlString("https://x.com/home")),
        const Gap(15),
        _socialIcon("assets/images/mail - Copy.png",
            () => commHelper.sendEmail("e.lubbad91@gmail.com", "", "")),
        const Gap(15),
        _socialIcon("assets/images/insta - Copy.png",
            () => launchUrlString("https://www.instagram.com/")),
        const Gap(15),
        _socialIcon("assets/images/whatsapp.png",
            () => commHelper.openWhatsApp("+966559689171", "")),
      ],
    );
  }

  Widget _socialIcon(String path, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(path, width: 45),
    );
  }
}

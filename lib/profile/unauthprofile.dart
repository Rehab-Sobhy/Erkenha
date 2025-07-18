import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:parking_4/about_us.dart';
import 'package:parking_4/auth/login/login_screen.dart';

import 'package:parking_4/conditions.dart';

import 'package:parking_4/constants/cachHelper.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/styles.dart';

import 'package:parking_4/constants/widgets/custom_appBar.dart';
import 'package:parking_4/constants/widgets/main_button.dart';
import 'package:parking_4/privacy.dart';
import 'package:parking_4/profile/cubit.dart';

class UnAthProfile extends StatefulWidget {
  const UnAthProfile({super.key});

  @override
  State<UnAthProfile> createState() => _UnAthProfileState();
}

class _UnAthProfileState extends State<UnAthProfile> {
  String name = "Loading...";
  String email = "Loading...";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = context.locale.languageCode;
    return BlocProvider(
      create: (context) => UserCubit()..fetchUserData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(),
        body: Column(
          children: [
            const Gap(50),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivacyScreen()));
                        },
                        child: Text(
                          "privacy".tr(),
                          style: style14black.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Gap(15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutUs()));
                        },
                        child: Text(
                          "aboutUs".tr(),
                          style: style14black.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Gap(15),
                      InkWell(
                        onTap: () async {
                          Locale newLocale = currentLang == 'en'
                              ? const Locale('ar', 'EG')
                              : const Locale('en', 'US');

                          await context.setLocale(newLocale);

                          CacheHelper.saveData(
                              key: 'language', value: newLocale.languageCode);
                        },
                        child: Text(
                          currentLang == 'en'
                              ? "العربية"
                              : "English", // Change text dynamically
                          style: style14black.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Gap(15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Conditions()));
                        },
                        child: Text(
                          "conditions".tr(),
                          style: style14black.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Gap(15),
                    ],
                  ),
                )
              ],
            ),
            const Gap(30),
            Gap(50.h),
            MainButton(
              textColor: Colors.white,
              backGroundColor: primaryColor,
              text: "logIn".tr(),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            Gap(15.h),
          ],
        ),
      ),
    );
  }
}

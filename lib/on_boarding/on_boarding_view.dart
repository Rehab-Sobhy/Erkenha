import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parking_4/auth/login/login_screen.dart';

import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/styles.dart';
import 'package:parking_4/constants/widgets/main_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreem extends StatefulWidget {
  const OnBoardingScreem({super.key});

  @override
  State<OnBoardingScreem> createState() => _OnBoardingScreemState();
}

class _OnBoardingScreemState extends State<OnBoardingScreem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: -100, end: 50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    width: 100,
                    "assets/images/P.png",
                  ),
                  const Spacer(),
                  Image.asset(
                    width: 100,
                    "assets/images/white_logo.png",
                  ),
                ],
              ),
              const Gap(40),
              Stack(
                children: [
                  Image.asset(
                    width: 300,
                    "assets/images/circle.png",
                  ),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        left: _animation.value,
                        right: 50,
                        top: 50,
                        bottom: 50,
                        child: Image.asset(
                          width: 100,
                          "assets/images/car.png",
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Gap(20),
              Text(
                "onboardingTitle".tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "onBoardingDetails".tr(),
                  style: style14White,
                ),
              ),
              const Gap(40),
              MainButton(
                text: "التالي",
                backGroundColor: secondaryColor,
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('hasSeenOnboardingScreen', "seen");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
              ),
              const Gap(20),
              MainButton(
                text: "تخطى",
                backGroundColor: white,
                textColor: Colors.black,
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('hasSeenOnboardingScreen', "seen");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

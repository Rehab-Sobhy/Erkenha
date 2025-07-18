import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:parking_4/auth/login/login_cubit.dart';
import 'package:parking_4/auth/login/login_states.dart';
import 'package:parking_4/auth/login/otp.dart';
import 'package:parking_4/bottom_bar/bottom_bar.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/widgets/custom_texr_field.dart';

import 'package:parking_4/constants/widgets/main_button.dart';

class Sendotpscreen extends StatefulWidget {
  const Sendotpscreen({super.key});

  @override
  State<Sendotpscreen> createState() => _SendotpscreenState();
}

class _SendotpscreenState extends State<Sendotpscreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: Container(),
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Gap(90),
              Center(
                child: Image.asset(
                  "assets/images/logo1.png",
                  width: 220,
                ),
              ),
              const Gap(50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  Text(
                    "phone".tr(),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(20),
                  CustomTextFieldCard(
                    hintText: '',
                    controller: phoneController,
                  ),
                  const Gap(20),
                  const Gap(50),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("errorTryAgain".tr())),
                        );
                      } else if (state is LoginSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("loginSuccessful".tr())),
                        );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomBarScreen()));
                      }
                    },
                    builder: (context, state) {
                      return state is LoginLoading
                          ? const Center()
                          : MainButton(
                              onTap: () {
                                if (phoneController.text.isNotEmpty) {
                                  showSimpleNotification(
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 30,
                                          right: 10,
                                          left: 10), // Adjust top padding
                                      child: Text(" OTP is 123456"),
                                    ),
                                    background: white,
                                    foreground: Colors.black,
                                    duration: Duration(seconds: 5),
                                    position: NotificationPosition
                                        .top, // Ensure it appears at the top
                                  );

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtpScreen(
                                                phone: phoneController.text,
                                              )));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("pleaseFillAllFields".tr())),
                                  );
                                }
                              },
                              backGroundColor: primaryColor,
                              text: "sendOtp".tr(),
                              textColor: white,
                            );
                    },
                  ),
                  const Gap(50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

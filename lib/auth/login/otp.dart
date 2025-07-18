import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:parking_4/auth/login/login_cubit.dart';
import 'package:parking_4/auth/login/login_states.dart';
import 'package:parking_4/bottom_bar/bottom_bar.dart';
import 'package:parking_4/constants/styles.dart';
import 'package:parking_4/constants/widgets/main_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../constants/colors.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: white,
        leading: Container(),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(50),
              Text(
                "otp".tr(),
                style: style14White.copyWith(
                    color: secondaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Gap(10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 10,
                  color: const Color.fromARGB(255, 233, 233, 233),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      height: 400,
                      child: BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccess) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomBarScreen()));
                          }
                        },
                        builder: (context, state) {
                          return ListView(
                            children: [
                              PinCodeTextField(
                                appContext: context,
                                length: 6,
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                enableActiveFill: true,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.grey,
                                  inactiveFillColor: Colors.grey[200]!,
                                  selectedFillColor: Colors.grey,
                                  activeColor: Colors.grey,
                                  inactiveColor: Colors.grey,
                                  selectedColor: Colors.grey,
                                ),
                                onChanged: (value) {},
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "pleaseEnterTheCode".tr();
                                  }
                                  return null;
                                },
                                beforeTextPaste: (text) {
                                  return true;
                                },
                              ),
                              Gap(100),
                              state is LoginLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : MainButton(
                                      onTap: () {
                                        String otpCode =
                                            _otpController.text.trim();
                                        if (otpCode.length == 6) {
                                          context
                                              .read<LoginCubit>()
                                              .Otp(widget.phone, otpCode);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "pleaseEnterAValidCode".tr()),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      textColor: Colors.white,
                                      backGroundColor: primaryColor,
                                      text: "confirm".tr(),
                                    ),
                              Gap(30),
                              MainButton(
                                textColor: white,
                                backGroundColor: secondaryColor,
                                text: "resendOtp".tr(),
                                onTap: () {
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
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

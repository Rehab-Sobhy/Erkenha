import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:parking_4/auth/login/login_cubit.dart';
import 'package:parking_4/auth/login/login_states.dart';

import 'package:parking_4/auth/login/sendOtpscreen.dart';
import 'package:parking_4/auth/register/register.dart';
import 'package:parking_4/bottom_bar/bottom_bar.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/widgets/custom_texr_field.dart';
import 'package:parking_4/constants/widgets/main_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

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
              const Gap(30),
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
                  Text(
                    "logIn".tr(),
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    "email".tr(),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(15),
                  CustomTextFieldCard(
                    hintText: '',
                    controller: emailController,
                  ),
                  const Gap(15),
                  Text(
                    "password".tr(),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(15),
                  CustomTextFieldCard(
                    hintText: '',
                    controller: passwordController,
                    isPassword: !isPasswordVisible, // Toggle based on state
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const Gap(20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Sendotpscreen()));
                    },
                    child: Text(
                      "forgetPassword".tr(),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(50),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("loginerror").tr()),
                        );
                      } else if (state is LoginSuccess) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomBarScreen(
                                      index: 0,
                                    )));
                      }
                    },
                    builder: (context, state) {
                      return state is LoginLoading
                          ? const Center(child: CircularProgressIndicator())
                          : MainButton(
                              onTap: () {
                                if (emailController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {
                                  context.read<LoginCubit>().login(
                                        emailController.text,
                                        passwordController.text,
                                      );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("pleaseFillAllFields".tr())),
                                  );
                                }
                              },
                              backGroundColor: primaryColor,
                              text: "logIn".tr(),
                              textColor: white,
                            );
                    },
                  ),
                  const Gap(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "donotHaveAcc".tr(),
                        style: TextStyle(
                          color: grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          "creatAccount".tr(),
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:parking_4/auth/register/register_states.dart';
import 'package:parking_4/bottom_bar/bottom_bar.dart';
import 'package:parking_4/bottom_bar/buildnavItemForanotherScreens.dart';

import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/widgets/main_button.dart';
import 'package:parking_4/profile/cubit.dart';
import 'package:parking_4/profile/profile.dart';
import 'package:parking_4/profile/profileStates.dart';

import '../../constants/widgets/custom_texr_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserCubit>(context).fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => UserCubit()..fetchUserData(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserLoaded) {
                  print(state.user.address);
                  nameController.text = state.user.name;
                  phoneController.text = state.user.phone;
                  emailController.text = state.user.email;
                } else if (state is UserUpdateLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("dataUpdated".tr()),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (state is UpdateFaild) {
                  print(state.message);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("errorTryAgain".tr())),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Gap(90),
                    Center(
                      child: Image.asset(
                        width: 220,
                        "assets/images/logo1.png",
                      ),
                    ),
                    const Gap(50),
                    Text(
                      "editProfile".tr(),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    _buildTextField("userName".tr(), nameController),
                    const Gap(10),
                    _buildTextField("phone".tr(), phoneController),
                    const Gap(10),
                    _buildTextField("email".tr(), emailController),
                    const Gap(10),
                    const Gap(40),
                    state is RegisterLoading
                        ? Center(child: CircularProgressIndicator())
                        : MainButton(
                            onTap: () async {
                              // Get the current user state
                              var userCubit =
                                  BlocProvider.of<UserCubit>(context);

                              await userCubit.updateUserData(
                                nameController.text,
                                phoneController.text,
                                emailController.text,
                              );

                              await BlocProvider.of<UserCubit>(context)
                                  .fetchUserData();
                            },
                            backGroundColor: primaryColor,
                            text: "update".tr(),
                            textColor: white,
                          ),
                    const Gap(30),
                  ],
                );
              },
            ),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const Gap(10),
        CustomTextFieldCard(
          hintText: '',
          controller: controller,
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import 'package:parking_4/auth/login/login_screen.dart';
import 'package:parking_4/auth/register/cubit.dart';
import 'package:parking_4/auth/register/register_model.dart';
import 'package:parking_4/auth/register/register_states.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/widgets/main_button.dart';
import '../../constants/widgets/custom_texr_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RegisterModel registerModel = RegisterModel();
  File? selectedImage;

  XFile? _image;
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = pickedFile;
        if (_image != null) {
          selectedImage = File(_image!.path);
        }
      });
    } catch (e) {
      print("Image picking error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: Container(),
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => RegisterCubit(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("registrationSuccessful".tr()),
                    ),
                  );
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                } else if (state is RegisterFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("errorTryAgain".tr())),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Gap(30),
                    Center(
                      child: Image.asset(
                        width: 220,
                        "assets/images/logo1.png",
                      ),
                    ),
                    const Gap(50),
                    Text(
                      "creatAccount".tr(),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    _buildTextField("${"userName".tr()} *", nameController),
                    const Gap(10),
                    _buildTextField("phone".tr(), phoneController),
                    const Gap(10),
                    _buildTextField("${"email".tr()} *", emailController),
                    const Gap(10),
                    _buildTextField("${"password".tr()} *", passwordController),
                    const Gap(10),
                    _buildTextField(
                        "confirmPassword".tr(), passwordConfirmationController),
                    const Gap(10),
                    _buildTextField("address".tr(), addressController),
                    const Gap(10),
                    if (selectedImage != null)
                      Center(
                        child: Image.file(
                          selectedImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const Gap(10),
                    Center(
                      child: MainButton(
                        backGroundColor: primaryColor,
                        textColor: white,
                        text: "chooseImage".tr(),
                        onTap: pickImage,
                      ),
                    ),
                    const Gap(15),
                    state is RegisterLoading
                        ? Center(child: CircularProgressIndicator())
                        : MainButton(
                            onTap: () {
                              registerModel.name = nameController.text;
                              registerModel.phone = phoneController.text;
                              registerModel.email = emailController.text;
                              registerModel.address = addressController.text;
                              registerModel.password = passwordController.text;
                              registerModel.password_confirmation =
                                  passwordConfirmationController.text;
                              registerModel.image = selectedImage;

                              if (registerModel.name!.isEmpty ||
                                  registerModel.email!.isEmpty ||
                                  registerModel.phone!.isEmpty ||
                                  registerModel.address!.isEmpty ||
                                  registerModel.password!.isEmpty ||
                                  registerModel
                                      .password_confirmation!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("pleaseFillAllFields".tr())),
                                );
                                return;
                              }

                              if (registerModel.password!.length < 8) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("passError".tr())),
                                );
                                return;
                              }

                              if (registerModel.password !=
                                  registerModel.password_confirmation) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("confirmPassError".tr())),
                                );
                                return;
                              }

                              BlocProvider.of<RegisterCubit>(context)
                                  .signup(registerModel, context);
                            },
                            backGroundColor: primaryColor,
                            text: "register".tr(),
                            textColor: white,
                          ),
                    const Gap(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "haveAccount".tr(),
                          style: TextStyle(
                              color: grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "logIn".tr(),
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Gap(50),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label",
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

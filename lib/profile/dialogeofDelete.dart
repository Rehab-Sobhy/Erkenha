import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/styles.dart';
import 'package:parking_4/constants/widgets/main_button.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          "confirmDelete".tr(),
          style: style16black,
        ),
      ),
      content: Text("areYouSureYouWantDelete".tr()),
      actions: [
        Row(
          children: [
            MainButton(
              onTap: () {
                Navigator.of(context).pop();
              },
              width: 100,
              text: "cancel".tr(),
              backGroundColor: Colors.green,
              textColor: white,
            ),
            Gap(20),
            MainButton(
              width: 100,
              text: "yes".tr(),
              onTap: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              backGroundColor: Colors.red,
              textColor: white,
            ),
          ],
        ),
      ],
    );
  }
}

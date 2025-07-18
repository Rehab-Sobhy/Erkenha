import 'package:flutter/material.dart';
import 'package:parking_4/constants/colors.dart';

Widget buildNavItem(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: secondaryColor, width: 2),
      ),
      child: Icon(
        icon,
        color: const Color.fromARGB(136, 0, 0, 0),
        size: 30,
      ),
    ),
  );
}

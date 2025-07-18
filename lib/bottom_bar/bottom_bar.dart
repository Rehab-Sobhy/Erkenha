import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/home/homeScreen.dart';
import 'package:parking_4/categories/categoryCubit.dart';
import 'package:parking_4/home/places_cubit.dart';

import 'package:parking_4/my_car/carCubit.dart';
import 'package:parking_4/my_car/myCar.dart';
import 'package:parking_4/my_visits/my_visits.dart';

// ignore: must_be_immutable
class BottomBarScreen extends StatefulWidget {
  int index;
  BottomBarScreen({this.index = 0});
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MyVisitsScreen(),
    MyCarScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index; // هنا تحدد البداية بس

    final cubit = context.read<Categorycubit>();
    final Pcubit = context.read<PlacesCubit>();
    Pcubit.fetchPlaces();
    cubit.fetchCategories();
    context.read<CarCubit>().fetchCars();
    context.read<CarCubit>().fetchOrders();
    context.read<CarCubit>().fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
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
                _buildNavItem(Icons.home, 0),
                _buildNavItem(Icons.receipt_long, 1),
                _buildNavItem(Icons.directions_car, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onItemTapped(index),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? secondaryColor : Colors.white,
              border: Border.all(
                  color: isSelected ? Colors.white : secondaryColor, width: 2),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(136, 0, 0, 0),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_4/bottom_bar/bottom_bar.dart';
import 'package:parking_4/bottom_bar/buildnavItemForanotherScreens.dart';

import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/constants/widgets/custom_appBar.dart';

import 'package:parking_4/notifications/cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();

    // context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppBar(),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoadingState) {
            return Center();
          } else if (state is NotificationErrorState) {
            return Center(child: Text(""));
          } else if (state is NotificationSuccessState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  var notification = state.notifications[index];
                  return IntrinsicHeight(
                    child: Container(
                      child: Card(
                        color: white,
                        margin: EdgeInsets.all(10),
                        elevation: 8,
                        child: ListTile(
                          title: Text(notification['notification']['title']),
                          subtitle: Text(notification['notification']['body']),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        },
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
}

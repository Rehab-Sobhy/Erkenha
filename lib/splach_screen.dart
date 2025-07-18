import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parking_4/bottom_bar/bottom_bar.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/auth/login/login_screen.dart';
import 'package:parking_4/home/places_cubit.dart';
import 'package:parking_4/my_car/carCubit.dart';
import 'package:parking_4/notifications/cubit.dart';
import 'package:parking_4/on_boarding/on_boarding_view.dart';
import 'package:parking_4/profile/cubit.dart';
import 'categories/categoryCubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _fetchInitialData();
    _printAllKeys();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkUserStatus();
      }
    });
  }

  void _fetchInitialData() {
    final categoryCubit = context.read<Categorycubit>();
    final placesCubit = context.read<PlacesCubit>();

    placesCubit.fetchPlaces();
    context.read<UserCubit>().fetchUserData();
    context.read<NotificationCubit>().fetchNotifications();
    final carCubit = context.read<CarCubit>();
    carCubit.fetchOrders();
    carCubit.fetchReservations();
    categoryCubit.fetchCategories();
  }

  Future<void> _printAllKeys() async {
    if (kDebugMode) {
      final keys = await _getAllKeys();
      print("All saved keys: $keys");
    }
  }

  Future<Set<String>> _getAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  Future<void> _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final hasSeenOnboarding = prefs.getString('hasSeenOnboardingScreen');
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (kDebugMode) {
      print("token: $token");
      print("isLoggedIn: $isLoggedIn");
      print("hasSeenOnboarding: $hasSeenOnboarding");
    }

    if (token != null) {
      _navigateTo(BottomBarScreen());
    } else if (hasSeenOnboarding != null) {
      _navigateTo(const LoginScreen());
    } else {
      _navigateTo(const OnBoardingScreem());
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _animation,
              child: Image.asset("assets/images/P.png"),
            ),
            const Gap(10),
            SlideTransition(
              position: _animation,
              child: Image.asset("assets/images/white_logo.png"),
            ),
          ],
        ),
      ),
    );
  }
}

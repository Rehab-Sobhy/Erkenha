import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:parking_4/auth/login/login_cubit.dart';
import 'package:parking_4/constants/cachHelper.dart';
import 'package:parking_4/categories/categoryCubit.dart';
import 'package:parking_4/constants/colors.dart';
import 'package:parking_4/firebase_options.dart';
import 'package:parking_4/home/places_cubit.dart';
import 'package:parking_4/my_car/carCubit.dart';
import 'package:parking_4/notifications/cubit.dart';
import 'package:parking_4/parkCar/parkCubit.dart';
import 'package:parking_4/profile/cubit.dart';
import 'package:parking_4/splach_screen.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("رسالة في الخلفية: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance.getToken().then((token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("fcm_token", token ?? "");
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await CacheHelper.init();
  String? savedLanguage = CacheHelper.getData(key: 'language');
  Locale deviceLocale = PlatformDispatcher.instance.locale.languageCode == 'ar'
      ? const Locale('ar', 'EG')
      : const Locale('en', 'US');

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'قناة الإشعارات العامة',
        defaultColor: primaryColor,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        playSound: true,
      )
    ],
    debug: true,
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          channelKey: 'basic_channel',
          title: message.notification!.title,
          body: message.notification!.body,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    }
  });

  runApp(
    OverlaySupport.global(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
        path: 'assets/localization',
        fallbackLocale: const Locale('en', 'US'),
        startLocale: savedLanguage == 'ar'
            ? const Locale('ar', 'EG')
            : savedLanguage == 'en'
                ? const Locale('en', 'US')
                : deviceLocale,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => Categorycubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => CarCubit()),
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => PlacesCubit()),
        BlocProvider(create: (context) => ParkCarCubit()),
        BlocProvider(create: (context) => NotificationCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: SplashScreen(),
        ),
      ),
    );
  }
}

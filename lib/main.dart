import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prognosify/auth/google_sign_in.dart';
import 'package:prognosify/firebase_options.dart';
import 'package:prognosify/models/notification/notification_services.dart';
import 'package:prognosify/router/app_router_config.dart';
import 'package:prognosify/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);

String appTitle = 'Prognosify';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  NotificationServices.initializeNotifications();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp.router(
        // routeInformationParser: AppRouter().router.routeInformationParser,
        // routerDelegate: AppRouter().router.routerDelegate,
        // routeInformationProvider: AppRouter().router.routeInformationProvider,
        routerConfig: AppRouter().router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
            colorScheme: kColorScheme,
            appBarTheme: AppBarTheme(
              scrolledUnderElevation: 0,
              color: Colors.transparent,
              centerTitle: true,
              // color: Colors.transparent,
            ),
            textTheme: ThemeData().textTheme.copyWith(
                titleSmall: GoogleFonts.nunito(
                    fontSize: 18, color: kColorScheme.shadow),
                titleMedium: GoogleFonts.nunito(
                  fontSize: 24,
                  color: kColorScheme.shadow,
                ))),
      ),
    );
  }
}

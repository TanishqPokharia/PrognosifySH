import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prognosify/auth/google_sign_in.dart';
import 'package:prognosify/firebase_options.dart';
import 'package:prognosify/models/notification/notification_services.dart';
import 'package:prognosify/router/app_router_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart' as PR;

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);

String appTitle = 'Prognosify';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  // Hive.registerAdapter(PrognosifyNotificationAdapter());
  NotificationServices.initializeNotifications();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // runApp(DevicePreview(
  //     builder: ((context) => const MyApp()), enabled: !kReleaseMode));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PR.ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp.router(
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,

        // routeInformationParser: AppRouter().router.routeInformationParser,
        // routerDelegate: AppRouter().router.routerDelegate,
        // routeInformationProvider: AppRouter().router.routeInformationProvider,
        routerConfig: AppRouter().router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
            colorScheme: kColorScheme,
            appBarTheme: const AppBarTheme(
                scrolledUnderElevation: 0,
                color: Colors.transparent,
                centerTitle: true,
                systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarColor: Colors.black)
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

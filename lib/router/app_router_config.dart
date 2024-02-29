import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/navigation_menu/doctor_navigation_menu.dart';
import 'package:prognosify/navigation_menu/patient_navigation_menu.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:prognosify/screens/details_screen.dart';
import 'package:prognosify/screens/doctor/doctor_sign_up_screen.dart';
import 'package:prognosify/screens/sign_in_screen.dart';
import 'package:prognosify/screens/questions_screen.dart';
import 'package:prognosify/screens/results_screen.dart';
import 'package:prognosify/screens/patient_sign_up_screen.dart';
import 'package:prognosify/screens/splash_screen.dart';
import 'package:prognosify/screens/start_screen.dart';
import 'package:prognosify/screens/welcome_screen.dart';

class AppRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
      name: AppRouterConstants.splashScreen,
      path: '/',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SplashScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.welcomeScreen,
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        key: state.pageKey,
        child: const WelcomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0), // Bottom
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
    ),
    GoRoute(
      name: AppRouterConstants.patientSignUpScreen,
      path: "/patientSignUp",
      pageBuilder: (context, state) =>
          const MaterialPage(child: PatientSignUpScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.signInScreen,
      path: "/signIn",
      pageBuilder: (context, state) =>
          const MaterialPage(child: SignInScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.doctorSignUpScreen,
      path: "/doctorSignUp",
      pageBuilder: (context, state) =>
          const MaterialPage(child: DoctorSignUpScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.startScreen,
      path: '/start',
      pageBuilder: (context, state) => const MaterialPage(child: StartScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.patientNavigationScreen,
      path: "/patientNavigation",
      // builder: (context, state) => const NavigationMenu(),
      // pageBuilder: (context, state) => CustomTransitionPage(
      //   transitionDuration: const Duration(seconds: 1),
      //   key: state.pageKey,
      //   child: const NavigationMenu(),
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      //       FadeTransition(
      //     opacity: CurveTween(curve: Curves.easeInCirc).animate(animation),
      //     child: child,
      //   ),
      // ),
      pageBuilder: (context, state) =>
          const MaterialPage(child: PatientNavigationMenu()),
    ),
    GoRoute(
      name: AppRouterConstants.doctorNavigationScreen,
      path: '/doctorNavigation',
      pageBuilder: (context, state) =>
          const MaterialPage(child: DoctorNavigationMenu()),
    ),
    GoRoute(
      name: AppRouterConstants.questionsScreen,
      path: '/questions',
      pageBuilder: (context, state) {
        return const MaterialPage(child: QuestionsScreen());
      },
    ),
    GoRoute(
      name: AppRouterConstants.resultsScreen,
      path: '/results',
      pageBuilder: (context, state) {
        final dynamic answersList = state.extra;
        return MaterialPage(child: ResultsScreen(answersList: answersList));
      },
    ),
    GoRoute(
        name: AppRouterConstants.detailsScreen,
        path: "/details",
        pageBuilder: (context, state) {
          final dynamic detail = state.extra;
          return MaterialPage(
              child: DetailsScreen(
            diseaseName: detail[0],
            index: detail[1],
            diseaseImage: detail[2],
            diseaseDescription: detail[3],
            diseaseSymptoms: detail[4],
            diseasePrecautions: detail[5],
            help: detail[6],
            routines: detail[7],
          ));
        })
  ]);
}

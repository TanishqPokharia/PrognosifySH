import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/navigation_menu/navigation_menu.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:prognosify/screens/details_screen.dart';
import 'package:prognosify/screens/questions_screen.dart';
import 'package:prognosify/screens/results_screen.dart';
import 'package:prognosify/screens/sign_in_screen.dart';
import 'package:prognosify/screens/sign_up_screen.dart';
import 'package:prognosify/screens/splash_screen.dart';
import 'package:prognosify/screens/start_screen.dart';
import 'package:prognosify/screens/welcome_screen.dart';

class AppRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
      name: AppRouterConstants.splashScreen,
      path: '/',
      pageBuilder: (context, state) => MaterialPage(child: SplashScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.welcomeScreen,
      path: '/welcome',
      builder: (context, state) => WelcomeScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        transitionDuration: Duration(milliseconds: 500),
        key: state.pageKey,
        child: WelcomeScreen(),
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
      name: AppRouterConstants.signUpScreen,
      path: "/signUp",
      pageBuilder: (context, state) => MaterialPage(child: SignUpScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.signInScreen,
      path: "/signIn",
      pageBuilder: (context, state) => MaterialPage(child: SignInScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.startScreen,
      path: '/start',
      pageBuilder: (context, state) => MaterialPage(child: StartScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.navigationScreen,
      path: "/navigation",
      builder: (context, state) => NavigationMenu(
        currentScreenIndex: state.extra as int,
      ),
      pageBuilder: (context, state) => CustomTransitionPage(
        transitionDuration: Duration(seconds: 1),
        key: state.pageKey,
        child: NavigationMenu(
          currentScreenIndex: state.extra as int,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: CurveTween(curve: Curves.easeInCirc).animate(animation),
          child: child,
        ),
      ),
    ),
    GoRoute(
      name: AppRouterConstants.questionsScreen,
      path: '/questions',
      pageBuilder: (context, state) {
        final dynamic userAge = state.extra;
        return MaterialPage(
            child: QuestionsScreen(
          userAge: userAge,
        ));
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

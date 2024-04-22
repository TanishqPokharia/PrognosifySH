import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/navigation_menu/doctor_navigation_menu.dart';
import 'package:prognosify/navigation_menu/patient_navigation_menu.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:prognosify/screens/patient/details_screen.dart';
import 'package:prognosify/screens/doctor/doctor_sign_up_screen.dart';
import 'package:prognosify/screens/doctor/prescription_screen.dart';
import 'package:prognosify/screens/health_matrix/bmi/bmi_screen.dart';
import 'package:prognosify/screens/health_matrix/calorie/calorie_screen.dart';
import 'package:prognosify/screens/health_matrix/report_summarizer/report_summarizer_screen.dart';
import 'package:prognosify/screens/health_matrix/sleep_monitor/sleep_monitor_screen.dart';
import 'package:prognosify/screens/patient/contacted_doctors/contacted_doctors_screen.dart';
import 'package:prognosify/screens/sign_in_screen.dart';
import 'package:prognosify/screens/patient/questions_screen.dart';
import 'package:prognosify/screens/patient/results_screen.dart';
import 'package:prognosify/screens/patient/patient_sign_up_screen.dart';
import 'package:prognosify/screens/splash_screen.dart';
import 'package:prognosify/screens/patient/patient_home_screen.dart';
import 'package:prognosify/screens/welcome_screen.dart';
import 'package:prognosify/widgets/calorie_history_card.dart';

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
      pageBuilder: (context, state) =>
          const MaterialPage(child: PatientHomeScreen()),
    ),
    GoRoute(
      name: AppRouterConstants.patientNavigationScreen,
      path: "/patientNavigation",
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
        }),
    GoRoute(
      name: AppRouterConstants.prescriptionScreen,
      path: "/prescription",
      pageBuilder: (context, state) {
        final dynamic patientData = state.extra;
        return MaterialPage(
            child: WritePrescriptionScreen(patientData: patientData));
      },
    ),
    GoRoute(
        name: AppRouterConstants.sleepMonitorScreen,
        path: "/sleep",
        pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: SleepMonitorScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                      Tween(begin: Offset(1, 0), end: Offset.zero).chain(
                          CurveTween(curve: Curves.fastEaseInToSlowEaseOut))),
                  child: child,
                );
              },
            )),
    GoRoute(
        name: AppRouterConstants.bmiScreen,
        path: "/bmi",
        pageBuilder: (context, state) {
          print(state.extra);
          return CustomTransitionPage(
            key: state.pageKey,
            child: BMIScreen(
              bmi: state.extra.toString().toDouble(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(Tween(
                        begin: Offset(1, 0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut))),
                child: child,
              );
            },
          );
        }),
    GoRoute(
      name: AppRouterConstants.calorieScreen,
      path: "/calorie",
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: CaloriesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
          ),
          child: child,
        ),
      ),
    ),
    GoRoute(
      name: AppRouterConstants.reportSummarizerScreen,
      path: "/reportSummarizer",
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: MedicalReportSummarizer(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
          ),
          child: child,
        ),
      ),
    ),
    GoRoute(
      name: AppRouterConstants.contactedDoctorsScreen,
      path: "/contactedDoctors",
      pageBuilder: (context, state) =>
          const MaterialPage(child: ContactedDoctorsScreen()),
    )
  ]);
}

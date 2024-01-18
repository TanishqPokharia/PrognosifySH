import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:prognosify/auth/auth_services.dart';
import 'package:prognosify/auth/google_sign_in.dart';
import 'package:prognosify/main.dart';
import 'package:prognosify/models/disease_card_data.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:prognosify/widgets/disease_card.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  Future getUserTopDiseases() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    final userTopDiseasesName = userData['topDiseases'];
    final userTopDiseasesPercentage = userData['topPercentage'];
    final userTopDiseasesPrecautions = userData['topDiseasesPrecautions'];
    final userTopDiseasesSymptoms = userData['topDiseasesSymptoms'];
    final userTopDiseasesRoutines = userData['topDiseasesRoutines'];

    final List<DiseaseCardData> topDiseasesData = [];

    for (int i = 0; i < 3; i++) {
      final firebaseData = await FirebaseFirestore.instance
          .collection('diseases')
          .doc(userTopDiseasesName[i])
          .get();

      topDiseasesData.add(
        DiseaseCardData(
            percentage: userTopDiseasesPercentage[i],
            disease: userTopDiseasesName[i],
            imageLink: firebaseData['link'],
            diseaseDescription: firebaseData['desc'],
            symptoms: userTopDiseasesSymptoms[i.toString()],
            precautions: userTopDiseasesPrecautions[i.toString()],
            routines: userTopDiseasesRoutines[i.toString()],
            help: firebaseData['help']),
      );
    }

    return topDiseasesData;
  }

  Color setColor(double value) {
    if (value <= 30) {
      return Colors.green;
    } else if (value <= 60) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return UserProfileSignedIn(context);
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          } else {
            return Center(
              child: Text("User data not available"),
            );
          }
        });
  }

  Widget UserProfileSignedIn(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return FutureBuilder(
      future: getUserTopDiseases(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          return profilePage(user, context, data);
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        } else {
          return Center(
            child: Text("User data not available"),
          );
        }
      },
    );
  }

  Widget profilePage(User user, BuildContext context,
      List<DiseaseCardData> diseaseCardDataList) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              child: Column(
            children: [
              if (user.photoURL == null)
                Container(
                  margin:
                      EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
                  child: ProfilePhoto(
                    totalWidth: 100,
                    cornerRadius: 80,
                    color: Theme.of(context).colorScheme.onPrimary,
                    image: AssetImage('assets/defaultprofile.png'),
                    outlineWidth: 5,
                    outlineColor: kColorScheme.primary,
                  ),
                )
              else
                Container(
                  margin:
                      EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
                  child: ProfilePhoto(
                    totalWidth: 100,
                    cornerRadius: 80,
                    color: Colors.transparent,
                    image: CachedNetworkImageProvider(
                      user.photoURL!,
                    ),
                    outlineWidth: 5,
                    outlineColor: kColorScheme.primary,
                  ),
                ),
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  user.displayName!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 130,
                height: 50,
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    if (user.photoURL == null) {
                      AuthServices.signOutUser(context);
                    } else {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogout(context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Logout"), Icon(Icons.logout)],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Top 3 diseases you are vulnerable to",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ...diseaseCardDataList.asMap().entries.map((entry) {
                final index = entry.key;
                final disease = entry.value;
                return GestureDetector(
                  onTap: () {
                    GoRouter.of(context)
                        .pushNamed(AppRouterConstants.detailsScreen, extra: [
                      disease.disease,
                      index,
                      disease.imageLink != null
                          ? Image.network(
                              disease.imageLink!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/imagenotloaded.png',
                              fit: BoxFit.cover,
                            ),
                      disease.diseaseDescription,
                      disease.symptoms,
                      disease.precautions,
                      disease.help,
                      disease.routines
                    ]);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: DiseaseCard(
                        index: index,
                        diseaseCardData: disease,
                        context: context),
                  ),
                );
              })
            ],
          ))
        ],
      ),
    );
  }
}

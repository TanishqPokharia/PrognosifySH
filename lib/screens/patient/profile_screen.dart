import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:prognosify/auth/auth_services.dart';
import 'package:prognosify/auth/google_sign_in.dart';
import 'package:prognosify/data/disease_card_data.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:prognosify/widgets/disease_card.dart';
import 'package:provider/provider.dart' as PV;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

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
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser!.reload();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Column(
      children: [
        if (user.photoURL == null)
          Container(
            margin: EdgeInsets.only(
                top: mq(context, 25),
                right: mq(context, 35),
                left: mq(context, 35),
                bottom: mq(context, 25)),
            child: ProfilePhoto(
              totalWidth: mq(context, 120),
              cornerRadius: mq(context, 80),
              color: Theme.of(context).colorScheme.onPrimary,
              image: const AssetImage('assets/defaultprofile.png'),
              outlineWidth: 5,
              outlineColor: Theme.of(context).colorScheme.primary,
            ),
          )
        else
          Container(
            margin: EdgeInsets.only(
                top: mq(context, 25),
                right: mq(context, 35),
                left: mq(context, 35),
                bottom: mq(context, 25)),
            child: CircleAvatar(
              radius: mq(context, 100),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: CircleAvatar(
                radius: mq(context, 90),
                foregroundImage: CachedNetworkImageProvider(user.photoURL!),
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.all(mq(context, 15)),
          child: Text(
            user.displayName!,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: mq(context, 41), fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: mq(context, 200),
          margin: EdgeInsets.symmetric(
              horizontal: mq(context, 100),
              vertical: mq(context, mq(context, 30))),
          height: mq(context, 60),
          child: ElevatedButton(
            onPressed: () {
              if (user.photoURL == null) {
                AuthServices.signOutUser(context);
              } else {
                final provider = PV.Provider.of<GoogleSignInProvider>(context,
                    listen: false);
                provider.googleLogout(context);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Logout",
                  style: TextStyle(fontSize: mq(context, 20)),
                ),
                SizedBox(
                  width: mq(context, 10),
                ),
                const Icon(Icons.logout)
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(mq(context, 10)),
          child: Center(
            child: Text(
              "Top 3 diseases you are vulnerable to",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: mq(context, 21)),
            ),
          ),
        ),
        StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return userProfileSignedIn(context);
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              } else {
                return const Center(
                  child: Text("User data not available"),
                );
              }
            }),
      ],
    );
  }

  Widget userProfileSignedIn(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return FutureBuilder(
      future: getUserTopDiseases(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          return profilePage(user, context, data);
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else {
          return const Center(
            child: Text("User data not available"),
          );
        }
      },
    );
  }

  Widget profilePage(User user, BuildContext context,
      List<DiseaseCardData> diseaseCardDataList) {
    return Expanded(
      child: ListView(
        children: [
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
                      ? CachedNetworkImage(
                          imageUrl: disease.imageLink!,
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
                margin: EdgeInsets.all(mq(context, 20)),
                child: DiseaseCard(
                    index: index, diseaseCardData: disease, context: context),
              ),
            );
          })
        ],
      ),
    );
  }
}

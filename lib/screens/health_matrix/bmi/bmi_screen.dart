import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prognosify/widgets/pie_chart_indicator.dart';

final touchedIndexProvider = StateProvider<int>((ref) => -1);

final userWeightProvider = StateProvider<double>((ref) => 0);
final userHeightProvider = StateProvider<double>((ref) => 0);

final userDataProvider =
    StreamProvider.family<DocumentSnapshot, User?>((ref, user) {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .snapshots();
});

List<double> nutrientValues = [
  15.32,
  8.95,
  9.46,
  4.78,
  12.11,
  17.65,
  2.54,
  5.68,
  11,
  8.85,
  2.54,
  1.52,
];

List<PieChartSectionData> showingSections(WidgetRef ref) {
  return List.generate(12, (i) {
    final touchedIndex = ref.watch(touchedIndexProvider);
    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 25.0 : 14.0;
    final radius = isTouched ? 100.0 : 50.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    switch (i) {
      case 0:
        return PieChartSectionData(
          color: Colors.blue,
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 1:
        return PieChartSectionData(
          color: Color.fromARGB(255, 200, 158, 19),
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 2:
        return PieChartSectionData(
          color: Colors.orange,
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 3:
        return PieChartSectionData(
          color: Colors.grey,
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 4:
        return PieChartSectionData(
          color: Colors.green,
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 5:
        return PieChartSectionData(
          color: Colors.cyan,
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 6:
        return PieChartSectionData(
          color: Color.fromARGB(255, 198, 91, 34),
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 7:
        return PieChartSectionData(
          color: Colors.redAccent,
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 8:
        return PieChartSectionData(
          color: Colors.indigo,
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 9:
        return PieChartSectionData(
          color: Colors.blueGrey,
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 10:
        return PieChartSectionData(
          color: Colors.pinkAccent,
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      case 11:
        return PieChartSectionData(
          color: Color.fromARGB(255, 165, 233, 70),
          value: nutrientValues[i],
          title: '${nutrientValues[i]}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );

      default:
        throw Error();
    }
  });
}

class BMIScreen extends ConsumerWidget {
  BMIScreen({super.key, required this.bmi});
  final double bmi;

  final user = FirebaseAuth.instance.currentUser;
  final formKey = GlobalKey<FormState>();
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  String get weightCategory {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi > 18.5 && bmi < 24.9) {
      return "Healthy";
    } else {
      return "Overweight";
    }
  }

  void changeBMI(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      barrierLabel: "Change Height and Weight",
      context: context,
      builder: (context) => Container(
        height: mq(context, 600),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: mq(context, 45), vertical: mq(context, 10)),
                child: TextFormField(
                  style: TextStyle(fontSize: mq(context, 21)),
                  key: const ValueKey("height"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter proper height";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    ref.read(userHeightProvider.notifier).state =
                        newValue.toDouble();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(mq(context, 25)))),
                    label: Text(
                      "Height(meters)",
                      style: TextStyle(fontSize: mq(context, 21)),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: mq(context, 45), vertical: mq(context, 10)),
                child: TextFormField(
                  style: TextStyle(fontSize: mq(context, 21)),
                  key: const ValueKey("weight"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter proper weight";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    ref.read(userWeightProvider.notifier).state =
                        newValue.toDouble();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(mq(context, 25)))),
                    label: Text(
                      "Weight(kilograms)",
                      style: TextStyle(fontSize: mq(context, 21)),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(mq(context, 20)),
                child: TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(user!.uid)
                            .update({
                          "weight": ref.watch(userWeightProvider),
                          "height": ref.watch(userHeightProvider)
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Height and Weight changed")));
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 20),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showNutrientDetails(BuildContext context) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Container(
            margin: EdgeInsets.all(mq(context, 20)),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Protien",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: mq(context, 30)),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 10)),
                      child: Text(
                        " Animal Sources 🥩 \n ◾ Meat (beef, lamb, pork, poultry) \n ◾ Fish (salmon, tuna, mackerel)\n ◾ Eggs \n ◾ Dairy (milk, yogurt, cheese)",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: mq(context, 24)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 10)),
                      child: Text(
                        " Plant Sources 🌱 \n ◾ Beans (kidney beans, black beans, pinto beans)\n ◾ Chickpeas\n ◾ Peas\n ◾ Tofu\n ◾ Nuts (almonds, walnuts, peanuts)\n ◾ Seeds (lentils ,chia seeds, flax seeds, pumpkin seeds)",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: mq(context, 24)),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vitamins",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: mq(context, 30)),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 10)),
                      child: Text(
                        " Fat-Soluble Vitamins (A, D, E, K)\n ◾ Fatty fish\n ◾ Egg yolks\n ◾ Dairy products\n ◾ Nuts\n ◾ Seeds\n ◾ Leafy green vegetables",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: mq(context, 24)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 10)),
                      child: Text(
                        " Water-Soluble Vitamins (B complex, C)\n ◾ Fruits (citrus fruits, berries)\n ◾ Vegetables (potatoes, broccoli, Brussels sprouts)\n ◾ Whole grains, legumes",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: mq(context, 24)),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Minerals",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: mq(context, 30)),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 10)),
                      child: Text(
                        " ◾ Calcium: Dairy products (milk, cheese, yogurt) leafy green vegetables, tofu, fortified foods (cereals, orange juice)\n ◾ Iron: Red meat, poultry, fish, beans, lentils, leafy green vegetables, iron-fortified foods (cereals, bread)\n ◾ Potassium: Fruits (bananas, oranges, cantaloupe), vegetables (potatoes, spinach, mushrooms), dairy products (milk, yogurt)\n ◾ Sodium: Table salt, processed foods (canned goods, cured meats), soy sauce\n  ◾ Magnesium: Nuts, seeds, legumes, whole grains, leafy green vegetables, dark chocolate",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: mq(context, 24)),
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: FittedBox(child: Text("Body Mass Index")),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    height: mq(context, 400),
                    width: mq(context, 400),
                    child: PieChart(
                      PieChartData(
                          sections: showingSections(ref),
                          pieTouchData:
                              PieTouchData(touchCallback: (event, response) {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.touchedSection == null) {
                              ref.read(touchedIndexProvider.notifier).state =
                                  -1;
                              return;
                            }

                            ref.read(touchedIndexProvider.notifier).state =
                                response.touchedSection!.touchedSectionIndex;
                          })),
                      swapAnimationDuration: Duration(milliseconds: 150),
                      swapAnimationCurve: Curves.linear,
                    )),
                Center(
                  child: Text(
                    "BMI : $bmi \n $weightCategory",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: mq(context, 20),
                        color: Colors.teal.shade800,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: mq(context, 50),
            ),
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              child: GestureDetector(
                onTap: () {
                  showNutrientDetails(context);
                },
                child: const Card(
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Indicator(title: "Protien", color: Colors.blue),
                            Indicator(title: "Calcium", color: Colors.grey),
                            Indicator(
                                title: "Magnesium",
                                color: Color.fromARGB(255, 198, 91, 34)),
                            Indicator(title: "Iron", color: Colors.blueGrey),
                          ],
                        ),
                        Column(
                          children: [
                            Indicator(
                                title: "Potassium",
                                color: Color.fromARGB(255, 200, 158, 19)),
                            Indicator(title: "Sodium", color: Colors.green),
                            Indicator(
                                title: "Vitamin A", color: Colors.redAccent),
                            Indicator(
                                title: "Vitamin B",
                                color: Color.fromARGB(255, 208, 52, 104)),
                          ],
                        ),
                        Column(
                          children: [
                            Indicator(title: "Vitamin C", color: Colors.orange),
                            Indicator(
                                title: "Vitamin D", color: Colors.tealAccent),
                            Indicator(
                                title: "Vitamin E",
                                color: Color.fromARGB(255, 18, 3, 182)),
                            Indicator(
                                title: "Vitamin K",
                                color: Color.fromARGB(255, 165, 233, 70)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              child: ElevatedButton(
                  onPressed: () {
                    changeBMI(context, ref);
                  },
                  child: Text("Reset Weight/Height")),
            )
          ],
        ),
      ),
    );
  }
}

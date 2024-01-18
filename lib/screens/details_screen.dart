import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen(
      {super.key,
      required this.diseaseName,
      required this.index,
      required this.diseaseImage,
      required this.diseaseDescription,
      required this.diseasePrecautions,
      required this.diseaseSymptoms,
      required this.routines,
      required this.help});
  final String diseaseName;
  final Image? diseaseImage;
  final String diseaseDescription;
  final List<dynamic> diseasePrecautions;
  final List<dynamic> diseaseSymptoms;
  final List<dynamic> routines;
  final int index;
  final String help;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailsScreenState();
  }
}

class _DetailsScreenState extends State<DetailsScreen> {
  Future openHelpLink(context) async {
    final url = Uri.parse(widget.help);
    if (!await launchUrl(url)) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Container(
                  height: 100,
                  width: 200,
                  child: Text("Network Error. Please try again later"),
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return SafeArea(
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: Text(
                  "Details",
                  style: TextStyle(fontSize: 20),
                ),
                foregroundColor: Colors.white,
                centerTitle: true,
                expandedHeight: 250,
                // backgroundColor: Theme.of(context).colorScheme.primary,
                // scrolledUnderElevation: 0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: widget.diseaseImage != null
                      ? Hero(
                          tag: "disease${widget.index}",
                          child: widget.diseaseImage!,
                        )
                      : Container(),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (widget.diseaseName.length < 20)
                            Text(
                              widget.diseaseName,
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            )
                          else
                            Text(
                              widget.diseaseName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description:",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 72, 72, 70)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.diseaseDescription,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Precautions to take:",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 72, 72, 70)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ...widget.diseasePrecautions.map((precaution) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Material(
                                color: Colors.transparent,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: [
                                    Text(
                                      "${widget.diseasePrecautions.indexOf(precaution) + 1}. $precaution",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Precautionary Routines:",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 72, 72, 70)),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              child: Container(
                                                height: 200,
                                                width: 150,
                                                child: Center(
                                                  child: Wrap(
                                                    spacing: 10,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Text(
                                                              "Set daily precautionary routines for yourself!",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                GoRouter.of(
                                                                        context)
                                                                    .goNamed(
                                                                        AppRouterConstants
                                                                            .navigationScreen,
                                                                        extra:
                                                                            1);
                                                              },
                                                              child: Text(
                                                                  "Set Daily Routines"))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ));
                                  },
                                  icon: Icon(Icons.info))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ...widget.routines.map((routine) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Material(
                                color: Colors.transparent,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: [
                                    Text(
                                      "${widget.routines.indexOf(routine) + 1}. $routine",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Seek medical care if you experience:",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 72, 72, 70)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ...widget.diseaseSymptoms.map((symptom) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Material(
                                color: Colors.transparent,
                                child: Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "${widget.diseaseSymptoms.indexOf(symptom) + 1}. $symptom",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.all(20),
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            openHelpLink(context);
                          },
                          child: Text("Find nearby doctors/specialists")),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

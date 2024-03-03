import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  final CachedNetworkImage? diseaseImage;
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
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  Future openHelpLink(context) async {
    final url = Uri.parse(widget.help);
    if (!await launchUrl(url)) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: SizedBox(
                  height: mq(context, 150),
                  width: mq(context, 250),
                  child: const Text("Network Error. Please try again later"),
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: Text(
                "Details",
                style: TextStyle(fontSize: mq(context, 25)),
              ),
              foregroundColor: Colors.white,
              centerTitle: true,
              expandedHeight: mq(context, 300),
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
                    margin: EdgeInsets.all(mq(context, 20)),
                    // padding: EdgeInsets.only(right: mq(context, 20)),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        Text(
                          widget.diseaseName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: mq(context, 36),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(mq(context, 21)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description:",
                          style: TextStyle(
                              fontSize: mq(context, 24),
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 72, 72, 70)),
                        ),
                        SizedBox(
                          height: mq(context, 25),
                        ),
                        Text(
                          widget.diseaseDescription,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: mq(context, 18)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(mq(context, 21)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Precautions to take:",
                          style: TextStyle(
                              fontSize: mq(context, 24),
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 72, 72, 70)),
                        ),
                        SizedBox(
                          height: mq(context, 25),
                        ),
                        ...widget.diseasePrecautions.map((precaution) {
                          return Container(
                            padding: EdgeInsets.only(bottom: mq(context, 21)),
                            child: Material(
                              color: Colors.transparent,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runSpacing: mq(context, 15),
                                spacing: mq(context, 15),
                                children: [
                                  Text(
                                    "${widget.diseasePrecautions.indexOf(precaution) + 1}. $precaution",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontSize: mq(context, 18)),
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
                    margin: EdgeInsets.all(mq(context, 21)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Precautionary Routines:",
                              style: TextStyle(
                                  fontSize: mq(context, 24),
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 72, 72, 70)),
                            ),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: SizedBox(
                                              height: mq(context, 250),
                                              width: mq(context, 200),
                                              child: Center(
                                                child: Wrap(
                                                  spacing: mq(context, 15),
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(mq(
                                                                  context, 15)),
                                                          child: Text(
                                                            "Set daily precautionary routines for yourself!",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                    fontSize: mq(
                                                                        context,
                                                                        21),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                },
                                icon: const Icon(Icons.info))
                          ],
                        ),
                        SizedBox(
                          height: mq(context, 25),
                        ),
                        ...widget.routines.map((routine) {
                          return Container(
                            padding: EdgeInsets.only(bottom: mq(context, 21)),
                            child: Material(
                              color: Colors.transparent,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runSpacing: mq(context, 15),
                                spacing: mq(context, 15),
                                children: [
                                  Text(
                                    "${widget.routines.indexOf(routine) + 1}. $routine",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontSize: mq(context, 18)),
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
                    margin: EdgeInsets.all(mq(context, 21)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Seek medical care ONLY if you experience:",
                        //   style: TextStyle(
                        //       fontSize: mq(context, 29),
                        //       fontWeight: FontWeight.bold,
                        //       color: const Color.fromARGB(255, 72, 72, 70)),
                        // ),
                        RichText(
                            text: TextSpan(
                                text: "Seek medical care",
                                style: TextStyle(
                                    fontSize: mq(context, 24),
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 72, 72, 70)),
                                children: [
                              TextSpan(
                                  text: " ONLY ",
                                  style: TextStyle(
                                      fontSize: mq(context, 24),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                              TextSpan(
                                  text: "if you experience:",
                                  style: TextStyle(
                                      fontSize: mq(context, 24),
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 72, 72, 70)))
                            ])),
                        SizedBox(
                          height: mq(context, 25),
                        ),
                        ...widget.diseaseSymptoms.map((symptom) {
                          return Container(
                            padding: EdgeInsets.only(bottom: mq(context, 16)),
                            child: Material(
                              color: Colors.transparent,
                              child: Wrap(
                                runSpacing: mq(context, 15),
                                spacing: mq(context, 15),
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "${widget.diseaseSymptoms.indexOf(symptom) + 1}. $symptom",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontSize: mq(context, 18)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

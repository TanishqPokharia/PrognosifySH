import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/main.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:prognosify/models/disease_card_data.dart';
import 'package:prognosify/widgets/disease_card.dart';

class ResultList extends StatefulWidget {
  const ResultList({super.key, required this.diseaseList});
  final List<DiseaseCardData> diseaseList;
  @override
  State<StatefulWidget> createState() {
    return _ResultListState();
  }
}

class _ResultListState extends State<ResultList> {
  bool startAnimation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
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

  Future<Map<String, String>> getImage(index) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("diseases")
        .doc(widget.diseaseList[index].disease)
        .get();
    return {
      'image': snapshot.data()?['link'],
      'description': snapshot.data()?['desc']
    };
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        primary: false,
        itemBuilder: (context, index) {
          final diseaseImage = widget.diseaseList[index].imageLink != null
              ? CachedNetworkImage(
                  imageUrl: widget.diseaseList[index].imageLink!,
                  fit: BoxFit.cover)
              : Image.asset(
                  "assets/imagenotloaded.png",
                  fit: BoxFit.cover,
                );
          final String diseaseDescription =
              widget.diseaseList[index].diseaseDescription ?? "Error";
          return SafeArea(
            child: AnimatedContainer(
              curve: Curves.linear,
              transform: Matrix4.translationValues(
                0,
                startAnimation ? 0 : MediaQuery.of(context).size.height,
                0,
              ),
              duration: Duration(milliseconds: 600 + (index * 100)),
              margin: EdgeInsets.all(mq(context, 15)),
              child: Container(
                margin: EdgeInsets.all(mq(context, 15)),
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context)
                        .pushNamed(AppRouterConstants.detailsScreen, extra: [
                      widget.diseaseList[index].disease,
                      index,
                      diseaseImage,
                      diseaseDescription,
                      widget.diseaseList[index].symptoms,
                      widget.diseaseList[index].precautions,
                      widget.diseaseList[index].help,
                      widget.diseaseList[index].routines
                    ]);
                  },
                  child: DiseaseCard(
                      index: index,
                      diseaseCardData: widget.diseaseList[index],
                      context: context),
                ),
              ),
            ),
          );
        },
        itemCount: widget.diseaseList.length,
      ),
    );
  }
}

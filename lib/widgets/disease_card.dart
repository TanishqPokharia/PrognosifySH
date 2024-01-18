import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:prognosify/models/disease_card_data.dart';

class DiseaseCard extends StatefulWidget {
  const DiseaseCard({
    super.key,
    required this.index,
    required this.diseaseCardData,
    required this.context,
  });
  final int index;
  final DiseaseCardData diseaseCardData;
  final BuildContext context;

  @override
  State<DiseaseCard> createState() => _DiseaseCardState();
}

class _DiseaseCardState extends State<DiseaseCard> {
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
    return Card(
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: "disease${widget.index}",
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: widget.diseaseCardData.imageLink != null
                            ? CachedNetworkImageProvider(
                                widget.diseaseCardData.imageLink!,
                              )
                            : const AssetImage("assets/imagenotloaded.png")
                                as ImageProvider,
                        fit: BoxFit.cover)),
              ),
            ),
            const VerticalDivider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 200,
                        child: Text(
                          widget.diseaseCardData.disease,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 20),
                    child: CircularPercentIndicator(
                      radius: 40,
                      progressColor:
                          setColor(widget.diseaseCardData.percentage),
                      lineWidth: 6,
                      percent: widget.diseaseCardData.percentage / 100,
                      animation: true,
                      animationDuration: 2000,
                      center: Text(
                        "${widget.diseaseCardData.percentage.round()}%",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
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

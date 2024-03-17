import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:prognosify/data/disease_card_data.dart';

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
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
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
    return Card(
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: "disease${widget.index}",
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: mq(context, 10)),
                height: mq(context, 100),
                width: mq(context, 100),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mq(context, 50)),
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
                    padding: EdgeInsets.all(mq(context, 10)),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        // width: mq(context, 250),
                        child: Text(
                          widget.diseaseCardData.disease,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: mq(context, 25)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  Container(
                    // padding: EdgeInsets.all(mq(context, 10)),
                    margin: EdgeInsets.all(mq(context, 15)),
                    child: CircularPercentIndicator(
                      radius: mq(context, 40),
                      progressColor:
                          setColor(widget.diseaseCardData.percentage),
                      lineWidth: 6,
                      percent: widget.diseaseCardData.percentage / 100,
                      animation: true,
                      animationDuration: 2000,
                      center: Text(
                        "${widget.diseaseCardData.percentage.round()}%",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: mq(context, 18)),
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

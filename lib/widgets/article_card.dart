import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard(
      {super.key,
      required this.author,
      required this.title,
      required this.articleUrl});
  final String author;
  final String title;
  final String articleUrl;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  Future goToArticle(context) async {
    final url = Uri.parse(articleUrl);
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
    return GestureDetector(
      onTap: () {
        goToArticle(context);
      },
      child: Container(
          width: mq(context, 400),
          // height: mq(context, 300),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(mq(context, 10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(mq(context, 10)),
                  child: Text(author),
                ),
                Container(
                  margin: EdgeInsets.all(mq(context, 10)),
                  child: Text(
                    title,
                    maxLines: 3,
                  ),
                )
              ],
            ),
          )),
    );
  }
}

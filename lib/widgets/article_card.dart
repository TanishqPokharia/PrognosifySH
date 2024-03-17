import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard(
      {super.key,
      required this.author,
      required this.title,
      required this.articleUrl,
      required this.imageUrl});
  final String author;
  final String title;
  final String articleUrl;
  final String? imageUrl;

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
          height: mq(context, 200),
          // height: mq(context, 300),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(mq(context, 10))),
            child: Container(
              padding: EdgeInsets.all(mq(context, 10)),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(mq(context, 10)),
                          width: mq(context, 200),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: mq(context, 18)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 10)),
                          width: mq(context, 200),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: mq(context, 16)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq(context, 10)),
                        child: Image.network(
                          imageUrl!,
                          height: mq(context, 150),
                          width: mq(context, 150),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              margin: EdgeInsets.all(mq(context, 10)),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq(context, 10)),
                                child: Image.asset(
                                  "assets/Defaultarticleimage.jpg",
                                  height: mq(context, 150),
                                  width: mq(context, 150),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq(context, 10)),
                        child: Image.asset(
                          "assets/Defaultarticleimage.jpg",
                          height: mq(context, 150),
                          width: mq(context, 150),
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

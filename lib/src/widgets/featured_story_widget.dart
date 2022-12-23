import 'package:flutter/material.dart';

import 'package:eudoria/src/app_builder.dart';

class FeaturedStory extends StatelessWidget {
  FeaturedStory({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  String heading() => 'An ecosystem providing a diversity of habitats';

  String sentence1() => 'The park delights everyone with its two water basins, '
      'informational signage and concrete walking paths allowing nature lovers '
      'to experience wildflowers and wildlife such as long-necked turtles, '
      'frogs, microbats and a wide variety of birdlife.';

  String sentence2() => 'story';
  String sentence3() => 'story';

  String story() => 'story';

  final List<Widget> stories = [
    // ChartFungiWidget(animate: false),
    // const RadarAnimalsWidget(animate: true),
    // ChartBloomWidget(animate: false),
  ];

  final List<String> title = ['', '', ''];

  Padding layout1(BuildContext c) => Padding(
        padding: EdgeInsets.only(
          top: screenSize.height * 0.02,
          left: screenSize.width / 15,
          right: screenSize.width / 15,
        ),
        child: AppFlexer.isSmallScreen(c)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(),
                  Text(
                    heading(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    sentence1(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      // fontSize: 18,
                      fontFamily: 'Montserrat',
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(),
                  const SizedBox(height: 20),
                  Text(
                    heading(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        sentence1(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          // fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 10),
                ],
              ),
      );

  Padding layout2(BuildContext c) => AppFlexer.isSmallScreen(c)
      ? Padding(
          padding: EdgeInsets.only(top: screenSize.height / 70),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: screenSize.width / 15),
                ...Iterable<int>.generate(stories.length).map(
                  (int pageIndex) => Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenSize.height / 1,
                            width: screenSize.width / 1.1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: stories[pageIndex],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenSize.height / 70,
                            ),
                            child: Text(
                              title[pageIndex],
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: screenSize.width / 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      : Padding(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.01,
            left: screenSize.width / 15,
            right: screenSize.width / 15,
          ),
          // padding: const EdgeInsets.all(5),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...Iterable<int>.generate(stories.length).map(
                (int pageIndex) => Column(
                  children: [
                    SizedBox(
                      height: screenSize.height / 1.1,
                      width: screenSize.width / 3.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: stories[pageIndex],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height / 70,
                      ),
                      child: Text(
                        title[pageIndex],
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.1,
                fit: BoxFit.cover,
                image: AssetImage("assets/images/reeds.png"))),
        padding: const EdgeInsets.all(30),
        // color: AppStyler.themeData(context).primaryColorDark,
        child: layout1(context));
  }
}

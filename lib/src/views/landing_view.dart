import 'package:eudoria/src/widgets/app_lowbar_widget.dart';
import 'package:eudoria/src/widgets/app_radbar_widget.dart';
import 'package:eudoria/src/widgets/featured_image_widget.dart';
import 'package:eudoria/src/widgets/featured_story_widget.dart';
import 'package:flutter/material.dart';

import 'package:eudoria/src/app_builder.dart';
import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_security.dart';
import 'package:eudoria/src/widgets/app_drawer_widget.dart';
import 'package:eudoria/src/widgets/app_topbar_widget.dart';

class LandingView extends StatefulWidget {
  const LandingView({Key? key, required this.controller}) : super(key: key);

  static const viewName = 'home';
  static const viewIndex = 5;

  final AppController controller;

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  final GlobalKey<ScaffoldState> _landingKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  double _scrollPosition = 0;
  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double opacity = 1;
    var screenSize = MediaQuery.of(context).size;

    opacity = _scrollPosition < screenSize.height * 0.28
        ? _scrollPosition / (screenSize.height * 0.28)
        : 1;

    return Scaffold(
        key: _landingKey,
        extendBodyBehindAppBar: true,
        appBar: widget.controller.accessManager.aMode != AppMode.mobile
            ? AppFlexer.isSmallScreen(context)
                ? AppBar(
                    backgroundColor:
                        widget.controller.themeMode == ThemeMode.light
                            ? AppStyler.themeData(context)
                                .primaryColorDark
                                .withOpacity(opacity)
                            : widget.controller.themeMode == ThemeMode.dark
                                ? ThemeData.dark().primaryColorDark
                                : ThemeData.light().primaryColorDark,
                    elevation: 0,
                    title: AppStyler.appTitle(context))
                : PreferredSize(
                    preferredSize: Size(screenSize.width, 1000),
                    child: AppTopBarWidget(
                      opacity: opacity,
                      controller: widget.controller,
                    ), //_opacity,
                  )
            : AppBar(toolbarHeight: 0),
        endDrawer: AppDrawer(controller: widget.controller),
        body: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),

            /// Center is a layout widget. It takes a single child and positions
            /// it in the middle of the parent.
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      // body-container with fixed height.
                      // decoration: const BoxDecoration(
                      //     image: DecorationImage(
                      //         opacity: 0.1,
                      //         fit: BoxFit.cover,
                      //         image: AssetImage("assets/images/reeds.png"))),
                      color: null,
                      child: SizedBox(
                          // height: screenSize.height * 0.88,
                          width: screenSize.width,
                          child: Row(children: [
                            Expanded(
                                child: Column(children: [
                              SizedBox(
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/mcw.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              FeaturedHeading(screenSize: screenSize),
                              FeaturedImage(screenSize: screenSize),
                              SizedBox(height: screenSize.height * 0.05),
                              FeaturedStory(screenSize: screenSize),
                              const AppLowBar()
                            ]))
                          ])))
                ])));
  }
}

class FeaturedHeading extends StatelessWidget {
  const FeaturedHeading({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  String heading() => 'Mary Carroll Wetland';

  String sentence() => 'Escape for a moment, Explore and Discover.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.02,
        left: screenSize.width / 15,
        right: screenSize.width / 15,
      ),
      child: AppFlexer.isSmallScreen(context)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(),
                Text(
                  heading(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  sentence(),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  heading(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    sentence(),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

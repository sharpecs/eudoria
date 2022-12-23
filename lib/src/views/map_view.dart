import 'package:eudoria/src/app_builder.dart';
import 'package:flutter/material.dart';
import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_security.dart';
import 'package:eudoria/src/utils/lookup_util.dart';
import 'package:eudoria/src/widgets/app_drawer_widget.dart';
import 'package:eudoria/src/widgets/app_topbar_widget.dart';
import 'package:eudoria/src/widgets/map_mcwetland_widget.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class MapView extends StatefulWidget with LookupView {
  const MapView({Key? key, required this.controller}) : super(key: key);

  static const viewName = 'map';
  static const viewIndex = 1;

  final AppController controller;

  @override
  State<MapView> createState() => _MapViewState();

  @override
  void initLookup() {
    // TODO: implement initLookup
  }
}

class _MapViewState extends State<MapView> {
  double opacity = 0;

  @override
  void initState() {
    widget.initLookup();
    super.initState(); //init state
  }

  @override
  Widget build(BuildContext context) {
    // final ScrollController scrollController = ScrollController();
    double scrollPosition = 0;
    var screenSize = MediaQuery.of(context).size;

    opacity = scrollPosition < screenSize.height * 0.40
        ? scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
        appBar: !widget.controller.usingBackButton
            ? widget.controller.accessManager.aMode == AppMode.mobile
                ? AppBar(toolbarHeight: 0)
                : AppFlexer.isSmallScreen(context)
                    ? AppBar(
                        // backgroundColor: Colors.blueGrey.shade900.withOpacity(1),
                        elevation: 0,
                        title: Text(
                          AppLocalizations.of(context)!.appTitle,
                          style: TextStyle(
                            color: Colors.blueGrey.shade100,
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 3,
                          ),
                        ),
                      )
                    : PreferredSize(
                        preferredSize: Size(screenSize.width, 1000),
                        child: AppTopBarWidget(
                          opacity: 1,
                          controller: widget.controller,
                        ), //_opacity,
                      )
            : AppBar(
                // backbutton,
                elevation: 0,
                title: Text(
                  'Observations',
                  style: TextStyle(
                    color: Colors.blueGrey.shade100,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3,
                  ),
                ),
                leading: BackButton(
                  color: Colors.black,
                  onPressed: () {
                    widget.controller.backButtonOff();
                    widget.controller.routerIndex =
                        widget.controller.lookup!.popLookup();
                  },
                ),
              ),
        endDrawer: !widget.controller.usingBackButton
            ? AppDrawer(controller: widget.controller)
            : null,
        body: SingleChildScrollView(
          child: Center(

              /// Center is a layout widget. It takes a single child and positions
              /// it in the middle of the parent.
              /// controller: _scrollController,
              /// physics: const ClampingScrollPhysics(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Container(
                    // body-container with fixed height.
                    color: null,
                    child: SizedBox(
                        height: screenSize.height * 0.88,
                        width: screenSize.width,
                        child: Row(children: [
                          Expanded(
                              child: Column(children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: screenSize.width * 0.97,
                                  maxHeight: screenSize.height * 0.88),
                              child: MapMCWetlandWidget(
                                  appController: widget.controller),
                            ),
                          ]))
                        ])))
              ])),
        ));
  }
}

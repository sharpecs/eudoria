import 'package:flutter/material.dart';

import 'package:eudoria/src/app_builder.dart';
import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_router.dart';

class AppTopBarWidget extends StatefulWidget {
  const AppTopBarWidget(
      {Key? key, required this.opacity, required this.controller})
      : super(key: key);

  final AppController controller;

  final double opacity;

  @override
  State<AppTopBarWidget> createState() => _AppTopBarWidgetState();
}

class _AppTopBarWidgetState extends State<AppTopBarWidget> {
  final List _isHovering = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(screenSize.width, 1000),
      child: Container(
        color: widget.controller.themeMode == ThemeMode.light
            ? AppStyler.themeData(context)
                .primaryColorDark
                .withOpacity(widget.opacity)
            : widget.controller.themeMode == ThemeMode.dark
                ? ThemeData.dark().primaryColorDark
                : ThemeData.light().primaryColorDark,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: TextStyle(
                  color: Colors.blueGrey.shade100,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: screenSize.width / 8),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[0] = true
                              : _isHovering[0] = false;
                        });
                      },
                      onTap: () =>
                          widget.controller.routerIndex = LandingView.viewIndex,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                              color: _isHovering[0]
                                  ? Colors.blue.shade200
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[0],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: screenSize.width / 20),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[1] = true
                              : _isHovering[1] = false;
                        });
                      },
                      onTap: () => widget.controller.routerIndex =
                          ObservationView.viewIndex,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Observations',
                            style: TextStyle(
                              color: _isHovering[1]
                                  ? Colors.blue.shade200
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[1],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: screenSize.width / 20),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[2] = true
                              : _isHovering[2] = false;
                        });
                      },
                      onTap: () =>
                          widget.controller.routerIndex = SpeciesView.viewIndex,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Species',
                            style: TextStyle(
                              color: _isHovering[2]
                                  ? Colors.blue.shade200
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[2],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: screenSize.width / 20),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[3] = true
                              : _isHovering[3] = false;
                        });
                      },
                      onTap: () =>
                          widget.controller.routerIndex = MapView.viewIndex,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Map',
                            style: TextStyle(
                              color: _isHovering[3]
                                  ? Colors.blue.shade200
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[3],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (widget.controller.accessManager.authToRecord) ...[
                      SizedBox(width: screenSize.width / 20),
                      InkWell(
                        onHover: (value) {
                          setState(() {
                            value
                                ? _isHovering[4] = true
                                : _isHovering[4] = false;
                          });
                        },
                        onTap: () => widget.controller.routerIndex =
                            SettingsView.viewIndex,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Settings',
                              style: TextStyle(
                                color: _isHovering[4]
                                    ? Colors.blue.shade200
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Visibility(
                              maintainAnimation: true,
                              maintainState: true,
                              maintainSize: true,
                              visible: _isHovering[4],
                              child: Container(
                                height: 2,
                                width: 20,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              InkWell(
                onHover: (value) {
                  setState(() {
                    value ? _isHovering[5] = true : _isHovering[5] = false;
                  });
                },
                onTap: () {},
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: _isHovering[5] ? Colors.white : Colors.white70,
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width / 50,
              ),
              InkWell(
                onHover: (value) {
                  setState(() {
                    value ? _isHovering[6] = true : _isHovering[6] = false;
                  });
                },
                onTap: () {},
                child: Text(
                  'Donate',
                  style: TextStyle(
                    color: _isHovering[6] ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

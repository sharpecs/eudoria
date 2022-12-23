import 'dart:math' as math;
import 'package:eudoria/src/app_builder.dart';
import 'package:flutter/material.dart';

import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_model.dart';
import 'package:eudoria/src/app_security.dart';
import 'package:eudoria/src/widgets/app_button_widget.dart';
import 'package:eudoria/src/widgets/app_drawer_widget.dart';
import 'package:eudoria/src/widgets/app_topbar_widget.dart';
import 'package:eudoria/src/widgets/tag_textfield_widget.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget with TagWidget {
  const SettingsView({Key? key, required this.controller}) : super(key: key);

  static const viewName = 'system';
  static const viewIndex = 4;

  final AppController controller;

  @override
  State<SettingsView> createState() => _SettingsViewState();

  @override
  void initTagWidget() {
    if (controller.tags.isActive) {
      controller.tags.isActive = false;
    } else {
      controller.tags.setTagState('locationsTags', controller.locations);
      controller.tags
          .setTagState('locationsOptionTags', ['other', 'mc_wetland']);
    }

    controller.locations =
        controller.tags.getTagState('locationsTags') as List<String>;
  }
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();
  double opacity = 0;

  static const _actionTitles = [
    'Email Observations',
    'Manage Observations',
    'Delete Observations'
  ];

  // view attributes
  List<String> locationalTags = [];

  @override
  void initState() {
    widget.initTagWidget();

    // init models
    locationalTags =
        widget.controller.tags.getTagState('locationsTags') as List<String>;

    super.initState();
  }

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () {
                if (index == 0) {
                  widget.controller.exportApplication();
                }
                if (index == 2) {
                  setState(() {
                    widget.controller.records.clear();
                    widget.controller.saveApplication();
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(_actionTitles[index].split(' ')[0].toUpperCase()),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  void _authUserAction() {
    if (!widget.controller.accessManager.auth) {
      widget.controller.accessManager.authorise(widget.controller.appUser);
      Observer o = Observer(
          observerID: widget.controller.appUser.id,
          email: widget.controller.appUser.email,
          name: widget.controller.appUser.name);
      widget.controller.addObserver(o);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final ScrollController scrollController = ScrollController();
    double scrollPosition = 0;
    var screenSize = MediaQuery.of(context).size;

    opacity = scrollPosition < screenSize.height * 0.40
        ? scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: widget.controller.accessManager.aMode != AppMode.mobile
              ? AppFlexer.isSmallScreen(context)
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
              : AppBar(toolbarHeight: 0),
          endDrawer: AppDrawer(controller: widget.controller),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            // controller: _scrollController,
            // physics: const ClampingScrollPhysics(),
            child: SingleChildScrollView(
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
                                widget.controller.accessManager.aMode !=
                                        AppMode.mobile
                                    ? SizedBox(height: screenSize.height * 0.01)
                                    : SizedBox(
                                        height: screenSize.height * 0.03),
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: screenSize.width * 0.97),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppStyler.themeData(context)
                                              .primaryColorDark,
                                        ),
                                        child: Column(children: [
                                          Row(children: [
                                            const Text(' ',
                                                style: TextStyle(height: 1.5)),
                                            Text(
                                              'OBSERVER DETAILS',
                                              style: TextStyle(
                                                color: Colors.blueGrey.shade100,
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 3,
                                              ),
                                            ),
                                          ]),
                                          Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: AppStyler.themeData(
                                                          context)
                                                      .backgroundColor),
                                              child: Column(children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextFormField(
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Name',
                                                        // helperText: 'User Name',
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter your user name';
                                                        }
                                                        return null;
                                                      },
                                                      initialValue: widget
                                                          .controller
                                                          .appUser
                                                          .name,
                                                      onTap: () {},
                                                      onChanged: (value) {
                                                        widget
                                                            .controller
                                                            .appUser
                                                            .name = value;
                                                      },
                                                    )),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextFormField(
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Email',
                                                        // helperText: 'Email Address',
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value == '') {
                                                          return 'Please enter your email address';
                                                        }
                                                        return null;
                                                      },
                                                      initialValue: widget
                                                          .controller
                                                          .appUser
                                                          .email,
                                                      onTap: () {},
                                                      onChanged: (value) {
                                                        widget
                                                            .controller
                                                            .appUser
                                                            .email = value;
                                                        _authUserAction();
                                                      },
                                                    )),
                                              ]))
                                        ]))),
                                SizedBox(height: screenSize.height * 0.01),
                                TagTextFieldWidget(
                                    title: 'locations',
                                    appController: widget.controller),
                                SizedBox(height: screenSize.height * 0.01),
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: screenSize.width * 0.97,
                                        maxHeight: screenSize.height * 0.12),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          // color: Colors.grey.shade300,
                                        ),
                                        child: Column(children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Table(
                                                  border: null,
                                                  columnWidths: const <int,
                                                      TableColumnWidth>{
                                                    0: IntrinsicColumnWidth(),
                                                    1: FixedColumnWidth(30),
                                                    // 2: IntrinsicColumnWidth(),
                                                    2: FixedColumnWidth(200),
                                                  },
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  children: [
                                                    TableRow(children: [
                                                      const Text(
                                                          'Storage Size :'),
                                                      const Text(''),
                                                      Text(
                                                          '${widget.controller.observation.size.toString()} bytes'),
                                                    ]),
                                                    TableRow(children: [
                                                      const Text(
                                                          'Observations :'),
                                                      const Text(''),
                                                      Text(widget
                                                          .controller
                                                          .observation
                                                          .records
                                                          .length
                                                          .toString()),
                                                    ]),
                                                    TableRow(children: [
                                                      const Text('Species :'),
                                                      const Text(''),
                                                      Text(widget
                                                          .controller
                                                          .observation
                                                          .species
                                                          .length
                                                          .toString()),
                                                    ]),
                                                    TableRow(children: [
                                                      const Text('Observers :'),
                                                      const Text(''),
                                                      Text(widget
                                                          .controller
                                                          .observation
                                                          .observers
                                                          .length
                                                          .toString()),
                                                    ])
                                                  ],
                                                ),
                                              ]),
                                        ]))),
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: screenSize.width * 0.88,
                                        maxHeight: screenSize.height * 0.10),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          // color: Colors.grey.shade300
                                        ),
                                        child: Column(children: [
                                          Row(children: const [
                                            Text(' '),
                                            Text('')
                                          ]),
                                          const Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Text(
                                                  "Use the system button below to email or clear all your observations.")),
                                        ]))),
                              ]))
                            ]))),
                  ]),
            ),
          ),
          floatingActionButton: ExpandableFab(
            appController: widget.controller,
            distance: 112.0,
            children: [
              AppButton(
                onPressed: () => _showAction(context, 0),
                icon: const Icon(Icons.email),
              ),
              AppButton(
                onPressed: () {
                  // widget.controller.appUser.canAccess(ManagementView.viewIndex)
                  //     ? widget.controller.routerIndex = ManagementView.viewIndex
                  //     : _showAction(context, 1);
                },
                icon: const Icon(Icons.data_thresholding),
              ),
              AppButton(
                onPressed: () => _showAction(context, 2),
                icon: const Icon(Icons.delete_forever),
              ),
            ],
          ),
        ));
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
    required this.appController,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;
  final AppController appController;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(appController: widget.appController),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab({required AppController appController}) {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: () {
              appController.locations = appController.tags
                  .getTagState('locationsTags') as List<String>;
              appController.saveApplication();
              _toggle();
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    super.key,
    required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}

import 'package:eudoria/src/app_exception.dart';
import 'package:eudoria/src/app_router.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';

import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_model.dart';
import 'package:eudoria/src/app_security.dart';
import 'package:eudoria/src/utils/lookup_util.dart';
import 'package:eudoria/src/app_builder.dart';
import 'package:eudoria/src/widgets/app_drawer_widget.dart';
import 'package:eudoria/src/widgets/app_topbar_widget.dart';
import 'package:eudoria/src/widgets/picker_number_widget.dart';
import 'package:eudoria/src/widgets/tag_textfield_widget.dart';

class RecordView extends StatefulWidget with LookupView, TagWidget {
  const RecordView({Key? key, required this.controller}) : super(key: key);

  static const viewName = 'record';
  static const viewIndex = 2;

  final AppController controller;

  @override
  initLookup() {
    if (controller.lookup != null && controller.lookup!.isActive) {
      controller.lookup!.isActive = false;
      controller.tags.isActive = true;
    } else {
      controller.setLookup(SpeciesLookupDirector(viewIndex));
      controller.lookup!.lookupID = controller.record.speciesID;
      controller.lookup!.setFieldState('locality', controller.record.locality);
      controller.lookup!.setFieldState('tally', controller.record.speciesTally);
    }
  }

  @override
  void initTagWidget() {
    if (controller.tags.isActive) {
      controller.tags.isActive = false;
    } else {
      controller.tags
          .setTagState('conditionTags', controller.record.conditionalTags);
      controller.tags
          .setTagState('conditionOptionTags', ['disease', 'blooming']);
    }
  }

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // models
  late Record record;
  late Observer observer;
  late Species selected;

  // view attributes
  double? latitude;
  double? longitude;
  int speciesQty = 0;
  // bool atMCWetlands = false;
  List<String> conditionalTags = [];
  String locality = '';

  int _qtyOnes = 0;
  int _qtyTens = 0;
  int _qtyHuns = 0;
  double opacity = 0;
  bool isInit = true;

  @override
  void initState() {
    widget.initLookup();
    widget.initTagWidget();

    // init models
    record = widget.controller.record;
    observer = widget.controller.getObserverByID(widget.controller.appUser.id)!;
    selected =
        widget.controller.getSpeciesByID(widget.controller.lookup!.lookupID)!;

    locality = widget.controller.lookup!.getFieldState('locality') as String;
    speciesQty = widget.controller.lookup!.getFieldState('tally') as int;
    conditionalTags =
        widget.controller.tags.getTagState('conditionTags') as List<String>;
    latitude = record.latitude;
    longitude = record.longitude;

    _qtyHuns = (speciesQty * 0.01).floor();
    _qtyTens = ((speciesQty - (_qtyHuns * 100)) * 0.1).floor();
    _qtyOnes = speciesQty % 10;

    // init view attributes
    if (record.latitude != null && record.latitude! == 0) {
      _getPosition().then((value) {});
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleOnesChanged(int newValue) {
    setState(() {
      _qtyOnes = newValue;
      isInit = false;
      speciesQty = (_qtyHuns * 100) + (_qtyTens * 10) + (_qtyOnes);
    });
  }

  void _handleTensChanged(int newValue) {
    setState(() {
      _qtyTens = newValue;
      isInit = false;
      speciesQty = (_qtyHuns * 100) + (_qtyTens * 10) + (_qtyOnes);
    });
  }

  void _handleHunsChanged(int newValue) {
    setState(() {
      _qtyHuns = newValue;
      isInit = false;
      speciesQty = (_qtyHuns * 100) + (_qtyTens * 10) + (_qtyOnes);
    });
  }

  Future<void> _getPosition() async {
    try {
      final Location location = Location();
      final now = await location.getLocation();

      setState(() {
        latitude = now.latitude;
        longitude = now.longitude;
      });
    } catch (e) {
      widget.controller.addException(AppException(
        id: DateTime.now().microsecondsSinceEpoch,
        code: 'RecordView._getPosition()',
        text: e.toString(),
      ));
      widget.controller.saveApplication();
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrollPosition = 0;
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
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
                        SizedBox(height: screenSize.height * 0.01),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: screenSize.width * 0.97),
                            // maxHeight: screenSize.height * 0.20),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppStyler.themeData(context)
                                      .primaryColorDark,
                                ),
                                child: Column(children: [
                                  Row(children: [
                                    const Text(' ',
                                        style: TextStyle(height: 1.5)),
                                    Text(
                                      'RECORD SPECIES',
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
                                        color: AppStyler.themeData(context)
                                            .backgroundColor),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: TextFormField(
                                          initialValue: selected.name,
                                          onTap: () {
                                            widget.controller.lookup!.isActive =
                                                true;
                                            widget.controller.backButtonOn();
                                            widget.controller.lookup!
                                                .setFieldState(
                                                    'locality', locality);
                                            widget.controller.lookup!
                                                .setFieldState(
                                                    'tally', speciesQty);
                                            widget.controller.routerIndex =
                                                widget.controller.lookup!
                                                    .pushLookup();
                                          },
                                          onChanged: (value) {
                                            int speciesID = widget
                                                .controller.lookup!.lookupID;
                                            selected = widget.controller
                                                .getSpeciesByID(speciesID)!;
                                            setState(() {});
                                          },
                                          decoration: const InputDecoration(
                                              // labelText: 'Select species...',
                                              helperText:
                                                  'Tap to lookup species',
                                              suffixIcon: Icon(Icons.search)),
                                        )),
                                  )
                                ]))),
                        SizedBox(height: screenSize.height * 0.02),
                        TagTextFieldWidget(
                            title: 'Condition',
                            appController: widget.controller),
                        SizedBox(height: screenSize.height * 0.02),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: screenSize.width * 0.97),
                            // maxHeight: screenSize.height * 0.25),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppStyler.themeData(context)
                                      .primaryColorDark,
                                ),
                                child: Column(children: [
                                  Row(children: [
                                    const Text(' ',
                                        style: TextStyle(height: 1.5)),
                                    Text(
                                      'COUNT',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade100,
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 3,
                                      ),
                                    )
                                  ]),
                                  Container(
                                    width: double.infinity,
                                    height: screenSize.height * 0.20,
                                    decoration: BoxDecoration(
                                        color: AppStyler.themeData(context)
                                            .backgroundColor),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          PickerNumber(
                                              key: const Key('one-picker'),
                                              iniVal: _qtyHuns,
                                              title: '',
                                              onChanged: _handleHunsChanged),
                                          PickerNumber(
                                              key: const Key('ten-picker'),
                                              iniVal: _qtyTens,
                                              title: '',
                                              onChanged: _handleTensChanged),
                                          PickerNumber(
                                              key: const Key('hundred-picker'),
                                              iniVal: _qtyOnes,
                                              title: '',
                                              onChanged: _handleOnesChanged)
                                        ]),
                                  )
                                ]))),
                        SizedBox(height: screenSize.height * 0.02),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: screenSize.width * 0.97,
                                maxHeight: screenSize.height * 0.15),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  // color: Colors.grey,
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
                                              TableCellVerticalAlignment.middle,
                                          children: [
                                            TableRow(children: [
                                              const Text('Locality :'),
                                              const Text(''),
                                              DropdownButton<String>(
                                                value: widget
                                                        .controller.locations
                                                        .contains(locality)
                                                    ? locality
                                                    : widget.controller
                                                        .locations.first,
                                                onChanged: (String? value) {
                                                  locality = value!;
                                                  setState(() {});
                                                },
                                                items: widget
                                                    .controller.locations
                                                    .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              const Text('Longitude :'),
                                              const Text(''),
                                              Text('$longitude'),
                                            ]),
                                            TableRow(children: [
                                              const Text('Latitude :'),
                                              const Text(''),
                                              Text('$latitude'),
                                            ])
                                          ],
                                        ),
                                      ]),
                                ]))),
                      ]))
                    ])))
          ]))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          conditionalTags = widget.controller.tags.getTagState('conditionTags')
              as List<String>;
          record.speciesID = selected.speciesId;
          record.speciesTally = speciesQty;
          record.latitude = latitude;
          record.longitude = longitude;
          record.locality = locality.toUpperCase();
          record.conditionalTags = conditionalTags;
          record.observerID = observer.observerID;
          widget.controller.addRecord(record);
          widget.controller.saveApplication();
          widget.controller.routerIndex = ObservationView.viewIndex;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:eudoria/src/widgets/observation_option_widget.dart';
import 'package:flutter/material.dart';

import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_model.dart';
import 'package:eudoria/src/app_security.dart';
import 'package:eudoria/src/utils/filter_util.dart';
import 'package:eudoria/src/utils/lookup_util.dart';
import 'package:eudoria/src/views/record_view.dart';
import 'package:eudoria/src/widgets/app_button_widget.dart';
import 'package:eudoria/src/widgets/app_drawer_widget.dart';
import 'package:eudoria/src/widgets/app_topbar_widget.dart';
import 'package:eudoria/src/app_builder.dart';
import 'package:eudoria/src/widgets/observation_filter_widget.dart';

/// Displays a list of records captured from observations.
///
class ObservationView extends StatefulWidget with FilteringDialog, LookupView {
  const ObservationView({Key? key, required this.controller}) : super(key: key);

  static const viewName = 'observations';
  static const viewIndex = 0;

  final AppController controller;

  @override
  State<ObservationView> createState() => _ObservationViewState();

  @override
  void initFilter() {
    if (controller.filter != null && controller.filter!.isActive) {
      // Do nothing, search is impacted by filtering.
    } else {
      controller.setFilter(FilteringChainDirector());
    }
  }

  @override
  void initLookup() {
    if (controller.lookup != null && controller.lookup!.isActive) {
      controller.lookup!.isActive = false;
    } else {
      controller.setLookup(MapLookupDirector(viewIndex));
      controller.lookup!.lookupID = 0;
    }
  }
}

class _ObservationViewState extends State<ObservationView> {
  double opacity = 0;

  // This list holds the data for the list view
  List<Record> _foundRecords = [];
  Map<int, Record> _filteredRecords = {};

  @override
  initState() {
    widget.initLookup();
    widget.initFilter();

    // at the beginning show all.
    _buildFilteredRecords();
    _foundRecords = _filteredRecords.values.toList();

    super.initState();
  }

  void _buildFilteredRecords() {
    _filteredRecords = {};
    var sortedByKeyMap = Map.fromEntries(
        widget.controller.records.entries.toList()
          ..sort((e1, e2) => e2.key.compareTo(e1.key)));

    for (var r in sortedByKeyMap.entries) {
      _filteredRecords.update(
        r.value.timestamp,
        (value) => r.value,
        ifAbsent: () => r.value,
      );
    }
  }

  void _displayFilterDialog(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return ObservationFilter(
            controller: widget.controller, onChanged: _handleFilterDialog);
      },
    );
  }

  void _handleObservationOption(Record r) {
    widget.controller.saveApplication();
    _buildFilteredRecords();
    _runFilter('');
  }

  void _handleFilterDialog(Map<int, Record> fRecords) {
    _filteredRecords = fRecords;
    _foundRecords = fRecords.values.toList();
    _runFilter('');
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Record> results = [];
    if (enteredKeyword.isEmpty) {
      results = _filteredRecords.values.toList();
    } else {
      Map<int, Record> searchedRecords = {};
      for (var r in _filteredRecords.entries) {
        searchedRecords.update(
          r.value.timestamp,
          (value) => r.value,
          ifAbsent: () => r.value,
        );
      }
      FilterRecordsOnCondition f =
          FilterRecordsOnCondition(searchedRecords, enteredKeyword);

      f.filter();
      results = searchedRecords.values.toList();
    }

    // Refresh the UI
    setState(() {
      _foundRecords = results;
    });
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
        appBar: widget.controller.accessManager.aMode != AppMode.mobile
            ? AppFlexer.isSmallScreen(context)
                ? AppBar(
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
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Container(
                  // body-container with fixed height.
                  color: null,
                  child: SizedBox(
                      // height: screenSize.height * 0.76,
                      // width: screenSize.width,
                      child: Row(children: [
                    Expanded(
                        child: Align(
                            child: Wrap(children: [
                      ConstrainedBox(
                          // for spacing.
                          constraints:
                              BoxConstraints(maxWidth: screenSize.width * 0.97),
                          child: Row(children: [
                            SizedBox(height: screenSize.height * 0.01),
                          ])),
                      ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: screenSize.width * 0.95),
                          child: Row(children: <Widget>[
                            Flexible(
                                child: TextField(
                                    onChanged: (value) => _runFilter(value),
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        labelText: 'Search Observations',
                                        suffixIcon: Icon(Icons.search)))),
                            AppButton(
                              onPressed: () => _displayFilterDialog(context, 0),
                              icon: const Icon(Icons.manage_search),
                            ),
                          ])),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: screenSize.width * 0.97,
                              maxHeight: screenSize.height * 0.88),
                          child: _foundRecords.isNotEmpty
                              ? ListView.builder(
                                  restorationId: 'HistoryView',
                                  itemCount: _foundRecords.length,
                                  itemBuilder:
                                      (BuildContext context, int index) => Card(
                                          key: ValueKey(
                                              _foundRecords[index].speciesID),
                                          color: AppStyler.themeData(context)
                                              .cardColor,
                                          elevation: 4,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 1),
                                          child: ListTile(
                                            leading: RecordID(
                                                controller: widget.controller,
                                                record: _foundRecords[index]),
                                            title: RecordDetail(
                                              controller: widget.controller,
                                              record: _foundRecords[index],
                                            ),
                                            trailing: ObservationOption(
                                                controller: widget.controller,
                                                record: _foundRecords[index],
                                                onChanged:
                                                    _handleObservationOption),
                                            onTap: () {
                                              widget.controller.record =
                                                  _foundRecords[index];
                                              widget.controller.routerIndex =
                                                  RecordView.viewIndex;
                                              setState(() {});
                                            },
                                          )))
                              : const Text(
                                  'No Observations Found',
                                  style: TextStyle(fontSize: 24),
                                )),
                    ])))
                  ])))
            ]))),
        floatingActionButton: widget.controller.accessManager.authToRecord
            ? FloatingActionButton(
                onPressed: () {
                  int s = widget.controller.getSpeciesUnknown().speciesId;
                  String l = widget.controller.locations[0];
                  Record record = Record(
                    timestamp: DateTime.now().microsecondsSinceEpoch,
                    longitude: 0,
                    latitude: 0,
                    speciesTally: 0,
                    speciesID: s,
                    observerID: 0,
                    locality: l,
                    imageURL: "",
                    conditionalTags: [],
                  );
                  widget.controller.record = record;
                  widget.controller.routerIndex = RecordView.viewIndex;
                },
                child: const Icon(Icons.add),
              )
            : null);
  }
}

class RecordID extends StatelessWidget {
  const RecordID({
    required this.controller,
    required this.record,
    Key? recordIDKey,
  }) : super(key: recordIDKey);

  final Record record;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.all(0),
        width: screenSize.width * 0.09,
        child: AppFlexer.isSmallScreen(context)
            ? Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                      controller.getSpeciesByID(record.speciesID)!.getAvatar(),
                    ])),
              ])
            : Row(children: [record.getDateDisplay()]));
  }
}

class RecordDetail extends StatelessWidget {
  const RecordDetail({
    required this.controller,
    required this.record,
    Key? recordDetailKey,
  }) : super(key: recordDetailKey);

  final Record record;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(1),
        child: AppFlexer.isSmallScreen(context)
            ? Row(children: [
                Expanded(
                    flex: 7,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller
                                .getSpeciesByID(record.speciesID)!
                                .venacular,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 0.1),
                          Text(
                            controller.getSpeciesByID(record.speciesID)!.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0,
                                fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 0.1),
                          Text(
                            record.getDateDisplayTS(),
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 11.0,
                            ),
                          ),
                        ])),
              ])
            : Row(children: [
                Expanded(
                    flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller
                                .getSpeciesByID(record.speciesID)!
                                .venacular,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 0.1),
                          const Text(
                            "SPECIES",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                          )
                        ])),
                Expanded(
                    flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.getSpeciesByID(record.speciesID)!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 0.1),
                          const Text(
                            "SCIENTIFIC NAME",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                          )
                        ])),
                Expanded(
                    flex: 2,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.speciesTally.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 0.1),
                          const Text(
                            "COUNT",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                          )
                        ])),
              ]));
  }
}

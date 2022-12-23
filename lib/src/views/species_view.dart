import 'dart:collection';
import 'package:eudoria/src/app_builder.dart';
import 'package:eudoria/src/widgets/app_drawer_widget.dart';
import 'package:eudoria/src/widgets/species_dialog_widget.dart';
import 'package:flutter/material.dart';

import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_model.dart';
import 'package:eudoria/src/app_security.dart';
import 'package:eudoria/src/utils/lookup_util.dart';
import 'package:eudoria/src/views/settings_view.dart';
import 'package:eudoria/src/widgets/app_topbar_widget.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SpeciesView extends StatefulWidget with LookupView {
  const SpeciesView({Key? key, required this.controller}) : super(key: key);

  static const viewName = 'species';
  static const viewIndex = 3;

  final AppController controller;

  @override
  State<SpeciesView> createState() => _SpeciesViewState();

  @override
  void initLookup() {
    // TODO: implement initLookup
  }
}

class SpeciesSearch {
  static List<Species> getOrdered(
      Map<int, Species> species, String enteredKeyword) {
    List<Species> ordered = [];

    Map<int, Species> sorted = SplayTreeMap.from(species,
        (key1, key2) => species[key1]!.name.compareTo(species[key2]!.name));

    if (enteredKeyword.isNotEmpty) {
      sorted.forEach((k, v) => {
            if ((v.name.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
                    v.venacular
                        .toLowerCase()
                        .contains(enteredKeyword.toLowerCase())) &&
                v.kingdomId != 'UNKNOWN')
              {ordered.add(v)}
          });
    } else {
      sorted.forEach((k, v) => {
            if (v.kingdomId != 'UNKNOWN') {ordered.add(v)}
          });
    }

    return ordered;
  }
}

class _SpeciesViewState extends State<SpeciesView> {
  double opacity = 0;

  // This list holds the data for the list view
  List<Species> _foundSpecies = [];

  @override
  initState() {
    widget.initLookup();
    // at the beginning, all users are shown
    _foundSpecies = SpeciesSearch.getOrdered(widget.controller.species, '');

    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Species> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = SpeciesSearch.getOrdered(widget.controller.species, '');
    } else {
      results =
          SpeciesSearch.getOrdered(widget.controller.species, enteredKeyword);
      // results = widget.controller.transactions.reversed
      //     .where((reading) => reading.systolic == 146)
      //     // reading["systolic"].toLowerCase().contains(enteredKeyword.toLowerCase()))
      //     .toList();
    }

    // Refresh the UI
    setState(() {
      _foundSpecies = results;
    });
  }

  void _handleSpeciesDialog(Species s) {
    widget.controller.addSpecies(s);
    widget.controller.saveApplication();
    _runFilter('');
  }

  void _manageSpeciesAction(BuildContext c, Species s) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return SpeciesDialog(
            mContext: c, species: s, onChanged: _handleSpeciesDialog);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final ScrollController scrollController = ScrollController();
    double scrollPosition = 0;
    var screenSize = MediaQuery.of(context).size;

    opacity = scrollPosition < screenSize.height * 0.40
        ? scrollPosition / (screenSize.height * 0.40)
        : 1;

    Species s;

    return Scaffold(
        appBar: !widget.controller.usingBackButton
            ? widget.controller.accessManager.aMode == AppMode.mobile
                ? AppBar(toolbarHeight: 0)
                : AppFlexer.isSmallScreen(context)
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
            : AppBar(
                // backbutton,
                elevation: 0,
                title: Text(
                  'Species',
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
                      // height: screenSize.height * 0.88,
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
                              BoxConstraints(maxWidth: screenSize.width * 0.88),
                          child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                    child: TextField(
                                        onChanged: (value) => _runFilter(value),
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            labelText: 'Search Species',
                                            suffixIcon: Icon(Icons.search)))),
                              ])),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: screenSize.width * 0.97,
                              maxHeight: screenSize.height * 0.88),
                          child: _foundSpecies.isNotEmpty
                              ? ListView.builder(
                                  restorationId: 'speciesView',
                                  itemCount: _foundSpecies.length,
                                  itemBuilder:
                                      (BuildContext context, int index) => Card(
                                          key: ValueKey(
                                              _foundSpecies[index].speciesId),
                                          color: AppStyler.themeData(context)
                                              .cardColor,
                                          elevation: 4,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 1),
                                          child: ListTile(
                                            leading: SpeciesID(
                                                controller: widget.controller,
                                                species: _foundSpecies[index]),
                                            title: SpeciesDetail(
                                              controller: widget.controller,
                                              species: _foundSpecies[index],
                                            ),
                                            onTap: () {
                                              widget.controller.lookup ==
                                                          null ||
                                                      !widget.controller.lookup!
                                                          .isActive
                                                  ? null
                                                  : _manageSpeciesAction(
                                                      context,
                                                      _foundSpecies[index]);
                                            },
                                            trailing: widget.controller
                                                            .lookup ==
                                                        null ||
                                                    !widget.controller.lookup!
                                                        .isActive
                                                ? null
                                                : Checkbox(
                                                    value: widget.controller
                                                            .lookup!.lookupID ==
                                                        _foundSpecies[index]
                                                            .speciesId,
                                                    onChanged: (val) {
                                                      widget.controller.lookup!
                                                              .lookupID =
                                                          _foundSpecies[index]
                                                              .speciesId;
                                                      setState(() {});
                                                    }),
                                          )))
                              : const Text(
                                  'No Results Found',
                                  style: TextStyle(fontSize: 24),
                                )),
                    ])))
                  ])))
            ]))),
        floatingActionButton: widget.controller.lookup == null ||
                !widget.controller.lookup!.isActive
            ? widget.controller.appUser.canAccess(SettingsView.viewIndex)
                ? FloatingActionButton(
                    onPressed: () => {
                      s = Species(
                          speciesId: DateTime.now().microsecondsSinceEpoch,
                          name: '',
                          venacular: '',
                          genus: '',
                          other: '',
                          classId: 'UNKNOWN',
                          kingdomId: 'UNKNOWN',
                          canDelete: false),
                      _manageSpeciesAction(context, s),
                    },
                    child: const Icon(Icons.add),
                  )
                : null
            : null);
  }
}

class SpeciesID extends StatelessWidget {
  const SpeciesID({
    required this.controller,
    required this.species,
    Key? speciesIDKey,
  }) : super(key: speciesIDKey);

  final Species species;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.all(5),
        width: screenSize.width * 0.08,
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                species.getAvatar(),
              ])),
        ]));
  }
}

class SpeciesDetail extends StatelessWidget {
  const SpeciesDetail({
    required this.controller,
    required this.species,
    Key? speciesDetailKey,
  }) : super(key: speciesDetailKey);

  final Species species;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        child: AppFlexer.isSmallScreen(context)
            ? Row(children: [
                Expanded(
                    // flex: 7,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                        species.venacular,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 0.1),
                      Text(
                        species.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          fontSize: 12.0,
                        ),
                      ),
                    ]))
              ])
            : Row(children: [
                Expanded(
                    // flex: 5,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                        species.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 0.1),
                      const Text(
                        "NAME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                      )
                    ])),
                Expanded(
                    // flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                        species.venacular,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 0.1),
                      const Text(
                        "COMMON NAME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                      )
                    ])),
              ]));
  }
}

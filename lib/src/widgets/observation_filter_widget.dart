import 'package:eudoria/src/app_builder.dart';
import 'package:flutter/material.dart';
import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_model.dart';
import 'package:eudoria/src/utils/filter_util.dart';
import 'package:eudoria/src/widgets/tag_textfield_widget.dart';

import 'package:intl/intl.dart';

class ObservationFilter extends StatefulWidget with TagWidget {
  const ObservationFilter(
      {Key? key, required this.onChanged, required this.controller})
      : super(key: key);

  final AppController controller;

  final ValueChanged<Map<int, Record>> onChanged;

  @override
  State<ObservationFilter> createState() => _ObservationFilterState();

  @override
  void initTagWidget() {
    if (controller.tags.isActive) {
      controller.tags.isActive = false;
    } else {
      controller.tags.setTagState('kingdomOptionTags', Species.kingdomList);
      controller.tags.setTagState('classOptionTags', Species.classList);
      controller.tags.setTagState('kingdomTags', []);
      controller.tags.setTagState('classTags', []);
    }
  }
}

class _ObservationFilterState extends State<ObservationFilter> {
  List<String> selectedKingdom = [];
  List<String> selectedClass = [];

  bool isSelectedKingdom = false;
  bool isSelectedClass = false;

  DateTime? pickedSDate;
  DateTime? pickedEDate;

  TextEditingController dateStart = TextEditingController();
  TextEditingController dateEnd = TextEditingController();

  @override
  void initState() {
    widget.initTagWidget();

    dateStart.text = "";
    dateEnd.text = "";

    super.initState();
  }

  @override
  void dispose() {
    // widget.controller.tags.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // double scrollPosition = 0;
    var screenSize = MediaQuery.of(context).size;

    // var buttonTheme = AppStyler.themeData(context).buttonTheme;

    return SingleChildScrollView(
        child: SimpleDialog(
            // backgroundColor: Colors.amber,
            contentPadding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 12.0),
            insetPadding: const EdgeInsets.all(10),
            title: Text('Filter Search',
                style: TextStyle(
                    color: AppStyler.themeData(context).primaryColorDark)),
            children: <Widget>[
          Container(
              // body-container with fixed height.
              height: screenSize.height * 0.70,
              width: screenSize.width,
              // color: AppStyler.themeData(context).canvasColor,
              child: SizedBox(
                  width: screenSize.width,
                  child: Row(children: [
                    Expanded(
                        child: Column(children: [
                      // SizedBox(height: screenSize.height * 0.01),
                      ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity,
                            maxHeight: double.infinity,
                          ),
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
                                    'DATE RANGE',
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
                                    padding: const EdgeInsets.all(10),
                                    width: double.infinity,
                                    height: screenSize.height * 0.10,
                                    decoration: BoxDecoration(
                                        color: AppStyler.themeData(context)
                                            .backgroundColor),
                                    child: Center(
                                        child: TextField(
                                      controller:
                                          dateStart, //editing controller of this TextField
                                      decoration: const InputDecoration(
                                          // icon: Icon(Icons
                                          //     .calendar_today), //icon of text field
                                          hintText: "Filter just one day...",
                                          helperText: "Enter Start Date",
                                          suffixIcon: Icon(
                                              size: 20,
                                              Icons.calendar_month_outlined)),
                                      readOnly:
                                          true, //set it true, so that user will not able to edit text
                                      onTap: () async {
                                        pickedSDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101));

                                        if (pickedSDate != null) {
                                          // print(
                                          //     pickedSDate); //pickedDate output format => 2021-03-10 00:00:00.000

                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(pickedSDate!);
                                          // print(
                                          //     formattedDate); //formatted date output using intl package =>  2021-03-16
                                          //you can implement different kind of Date Format here according to your requirement

                                          setState(() {
                                            dateStart.text =
                                                formattedDate; //set output date to TextField value.
                                          });
                                        } else {
                                          // print("Date is not selected");
                                        }
                                      },
                                    ))),
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    width: double.infinity,
                                    height: screenSize.height * 0.10,
                                    decoration: BoxDecoration(
                                        color: AppStyler.themeData(context)
                                            .backgroundColor),
                                    child: Center(
                                        child: TextField(
                                      controller:
                                          dateEnd, //editing controller of this TextField
                                      decoration: const InputDecoration(
                                          // icon: Icon(Icons
                                          //     .calendar_today), //icon of text field
                                          // labelText: "Enter Date",
                                          helperText: "Enter End Date",
                                          suffixIcon: Icon(
                                              size: 20,
                                              Icons.calendar_month_outlined)),
                                      readOnly:
                                          true, //set it true, so that user will not able to edit text
                                      onTap: () async {
                                        pickedEDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(
                                                2000), //DateTime.now() - not to allow to choose before today.
                                            lastDate: DateTime(2101));

                                        if (pickedEDate != null) {
                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(pickedEDate!);
                                          //you can implement different kind of Date Format here according to your requirement

                                          setState(() {
                                            dateEnd.text =
                                                formattedDate; //set output date to TextField value.
                                          });
                                        } else {
                                          // print("Date is not selected");
                                        }
                                      },
                                    ))),
                              ]))),
                      SizedBox(height: screenSize.height * 0.01),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: screenSize.width * 0.97,
                              maxHeight: screenSize.height * 0.15),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade300),
                              child: Column(children: [
                                TagTextFieldWidget(
                                    title: 'Kingdom',
                                    appController: widget.controller),
                              ]))),
                      SizedBox(height: screenSize.height * 0.01),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: screenSize.width * 0.97,
                              maxHeight: screenSize.height * 0.15),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade300),
                              child: Column(children: [
                                TagTextFieldWidget(
                                    title: 'Class',
                                    appController: widget.controller),
                              ]))),
                      SizedBox(height: screenSize.height * 0.01),
                    ])),
                  ]))),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            const Text('  '),
            TextButton(
              onPressed: () {
                Map<int, Record> nRecords = {};
                for (var r in widget.controller.records.entries) {
                  nRecords.update(
                    r.value.timestamp,
                    (value) => r.value,
                    ifAbsent: () => r.value,
                  );
                }
                widget.onChanged(nRecords);

                Navigator.of(context).pop();
              },
              child: const Text('RESET'),
            ),
            const Text('  '),
            TextButton(
              onPressed: () {
                // widget.controller.filter!.isActive = false;

                Map<int, Record> nRecords = {};
                for (var r in widget.controller.records.entries) {
                  nRecords.update(
                    r.value.timestamp,
                    (value) => r.value,
                    ifAbsent: () => r.value,
                  );
                }

                FilterRecordsByDate f =
                    FilterRecordsByDate(nRecords, pickedSDate, pickedEDate);
                widget.controller.filter!.setSuccessor(f);

                selectedClass = widget.controller.tags.getTagState('classTags')
                    as List<String>;
                if (selectedClass.isNotEmpty) {
                  List<int>? speciesIDs =
                      widget.controller.getSpeciesByClassID(selectedClass);

                  if (speciesIDs!.isNotEmpty) {
                    FilterRecordsBySpecies f =
                        FilterRecordsBySpecies(nRecords, speciesIDs);
                    widget.controller.filter!.setSuccessor(f);
                  }
                }

                selectedKingdom = widget.controller.tags
                    .getTagState('kingdomTags') as List<String>;
                if (selectedKingdom.isNotEmpty) {
                  List<int>? speciesIDs =
                      widget.controller.getSpeciesByKingdomID(selectedKingdom);

                  if (speciesIDs!.isNotEmpty) {
                    FilterRecordsBySpecies f =
                        FilterRecordsBySpecies(nRecords, speciesIDs);
                    widget.controller.filter!.setSuccessor(f);
                  }
                }

                widget.controller.filter!.handle();
                widget.onChanged(nRecords);
                Navigator.of(context).pop();
              },
              child: const Text('SEARCH'),
            ),
            const Text('  '),
          ]),
        ]));
  }
}

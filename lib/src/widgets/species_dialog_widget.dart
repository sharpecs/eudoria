import 'package:eudoria/src/app_builder.dart';
import 'package:flutter/material.dart';
import 'package:eudoria/src/app_model.dart';

class SpeciesDialog extends StatefulWidget {
  const SpeciesDialog({
    required this.mContext,
    required this.species,
    required this.onChanged,
    Key? speciesDetailKey,
  }) : super(key: speciesDetailKey);

  final Species species;
  final BuildContext mContext;
  final ValueChanged<Species> onChanged;

  @override
  State<SpeciesDialog> createState() => _SpeciesDialogState();
}

class _SpeciesDialogState extends State<SpeciesDialog> {
  late final bool isAdd;

  @override
  initState() {
    isAdd = widget.species.name.isEmpty ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(widget.mContext).size;
    return SingleChildScrollView(
        child: AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
      insetPadding: const EdgeInsets.all(10),
      // title: Text(
      //     widget.species.name.isEmpty ? 'ADD NEW SPECIES' : 'UPDATE SPECIES',
      //     style:
      //         TextStyle(color: AppStyler.themeData(context).primaryColorDark)),
      content: Container(
          // body-container with fixed height.
          color: null,
          child: SizedBox(
              height: screenSize.height * 0.80,
              width: screenSize.width,
              child: Row(children: [
                Expanded(
                    child: Column(children: [
                  SizedBox(height: screenSize.height * 0.01),
                  ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: screenSize.width * 0.97),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppStyler.themeData(context).backgroundColor,
                          ),
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
                                  decoration: const InputDecoration(
                                    labelText: 'Species Name',
                                    // helperText: 'User Name',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter species';
                                    }
                                    return null;
                                  },
                                  initialValue: widget.species.name,
                                  onTap: () {},
                                  onChanged: (value) {
                                    widget.species.name = value;
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
                                  decoration: const InputDecoration(
                                    labelText: 'Common Name',
                                    // helperText: 'User Name',
                                  ),
                                  initialValue: widget.species.venacular,
                                  onTap: () {},
                                  onChanged: (value) {
                                    widget.species.venacular = value;
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
                                  decoration: const InputDecoration(
                                    labelText: 'Other Name',
                                    // helperText: 'User Name',
                                  ),
                                  initialValue: widget.species.other,
                                  onTap: () {},
                                  onChanged: (value) {
                                    widget.species.other = value;
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
                                  decoration: const InputDecoration(
                                    labelText: 'Taxonomy Genus',
                                    // helperText: 'User Name',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please taxonomic genus';
                                    }
                                    return null;
                                  },
                                  initialValue: widget.species.genus,
                                  onTap: () {},
                                  onChanged: (value) {
                                    widget.species.genus = value;
                                  },
                                )),
                            SizedBox(height: screenSize.height * 0.04),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: DropdownButton<String>(
                                // Read the selected themeMode from the controller
                                value: widget.species.classId,
                                // Call the updateThemeMode method any time the user selects a theme.
                                onChanged: (String? value) {
                                  widget.species.classId = value!;
                                  setState(() {});
                                },
                                items: Species.classList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: DropdownButton<String>(
                                // Read the selected themeMode from the controller
                                value: widget.species.kingdomId,
                                // Call the updateThemeMode method any time the user selects a theme.
                                onChanged: (String? value) {
                                  widget.species.kingdomId = value!;
                                  setState(() {});
                                },
                                items: Species.kingdomList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ]))),
                ]))
              ]))),
      actions: [
        TextButton(
          onPressed: () {
            widget.onChanged(widget.species);
            Navigator.of(context).pop();
          },
          child: widget.species.name.isEmpty
              ? const Text('ADD')
              : const Text('UPDATE'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
      ],
    ));
  }
}

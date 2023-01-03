import 'package:eudoria/src/app_builder.dart';
import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_model.dart';
import 'package:eudoria/src/widgets/observation_alert_widget.dart';
import 'package:flutter/material.dart';

class ObservationOption extends StatelessWidget {
  const ObservationOption({
    required this.controller,
    required this.record,
    required this.onChanged,
    Key? readingOpKey,
  }) : super(key: readingOpKey);

  final Record record;
  final AppController controller;
  final ValueChanged<Record> onChanged;

  static const _optionTitles = [
    'MAP',
    'VIEW',
    'DELETE',
  ];

  void _showOption(BuildContext c, int index) {
    if (index == 0) {
      controller.lookup!.isActive = true;
      controller.lookup!.lookupID = record.timestamp;
      controller.backButtonOn();
      controller.routerIndex = controller.lookup!.pushLookup();
    } else if (index == 1) {
      showDialog<void>(
        context: c,
        builder: (context) {
          return ObservationAlert(record: record, appController: controller);
        },
      );
    } else {
      showDialog<void>(
        context: c,
        builder: (context) {
          return AlertDialog(
            content: Text('CONFIRM ${_optionTitles[index]}'),
            actions: [
              TextButton(
                onPressed: () {
                  if (index == 2) {
                    controller.observation.records.remove(record.timestamp);
                    onChanged(record);
                  }
                  Navigator.of(context).pop();
                },
                child: Text(_optionTitles[index].toUpperCase()),
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
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.all(0),
        width: screenSize.width * 0.24,
        child: AppFlexer.isSmallScreen(context)
            ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                if (record.atMCWetland()) ...[
                  IconButton(
                      iconSize: 18,
                      onPressed: () => _showOption(context, 0),
                      icon: const Icon(Icons.map_outlined)),
                ],
                if (!record.atMCWetland()) ...[
                  IconButton(
                      iconSize: 18,
                      onPressed: () => _showOption(context, 1),
                      icon: const Icon(Icons.remove_red_eye_outlined)),
                ],
                if (controller.accessManager.authToRecord) ...[
                  IconButton(
                      iconSize: 18,
                      onPressed: () => _showOption(context, 2),
                      icon: const Icon(Icons.delete_forever))
                ],
              ])
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (record.atMCWetland()) ...[
                    TextButton(
                        onPressed: () => _showOption(context, 0),
                        child: Text(_optionTitles[0])),
                  ],
                  if (!record.atMCWetland()) ...[
                    TextButton(
                        onPressed: () => _showOption(context, 1),
                        child: Text(_optionTitles[1]))
                  ],
                  if (controller.accessManager.authToRecord) ...[
                    TextButton(
                        onPressed: () => _showOption(context, 2),
                        child: Text(_optionTitles[2]))
                  ],
                ],
              ));
  }
}

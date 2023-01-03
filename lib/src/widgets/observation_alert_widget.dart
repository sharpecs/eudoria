import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_model.dart';
import 'package:flutter/material.dart';

class ObservationAlert extends StatelessWidget {
  const ObservationAlert(
      {super.key, required this.record, required this.appController});

  final AppController appController;
  final Record record;

  @override
  Widget build(BuildContext context) {
    Species? s = appController.getSpeciesByID(record.speciesID);
    Observer? o = appController.getObserverByID(record.observerID);
    var screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
      insetPadding: const EdgeInsets.all(20),
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(style: const TextStyle(fontStyle: FontStyle.normal), s!.venacular),
      ]),
      content: Container(
          // body-container with fixed height.
          color: null,
          child: Row(children: [
            Expanded(
              child: Column(children: [
                // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //   Text(
                //       style: const TextStyle(fontStyle: FontStyle.normal),
                //       s!.venacular),
                // ]),
                // SizedBox(height: screenSize.height * 0.02),
                if (record.imageURL.isNotEmpty) ...[
                  Image.network(record.imageURL,
                      // width: screenSize.width * 0.20,
                      height: screenSize.height * 0.50,
                      loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })
                ],
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                      style: const TextStyle(fontWeight: FontWeight.normal),
                      '${o!.name} | ${record.getDateDisplayTS()}'),
                ]),
                const Spacer(),
                Text(
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                    s.name),
                Text(textAlign: TextAlign.center, s.other),
                Text(record.getTagsDisplay()),
                const Spacer(),
              ]),
            )
          ])),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE'),
        ),
      ],
    );
  }
}

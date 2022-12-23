import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_model.dart';

class MapMCWetlandWidget extends StatefulWidget {
  const MapMCWetlandWidget({super.key, required this.appController});

  final AppController appController;

  @override
  State<MapMCWetlandWidget> createState() => _MapMCWetlandState();
}

class _MapMCWetlandState extends State<MapMCWetlandWidget> {
  final GlobalKey<RefreshIndicatorState> _mapRefreshKey =
      GlobalKey<RefreshIndicatorState>();

  String carte = "assets/images/map_mcw.png";
  ui.Image? image;
  bool isImageloaded = false;
  late TransformationController controller;
  int height = 0;
  int width = 0;

  late Map<int, Record> mappedRecords = {};

  @override
  void initState() {
    super.initState(); //init state

    if (widget.appController.lookup != null &&
        widget.appController.lookup!.isActive) {
      int id = widget.appController.lookup!.lookupID;
      Record? r = widget.appController.getRecordByID(id);
      mappedRecords.update(
        r!.timestamp,
        (value) => r,
        ifAbsent: () => r,
      );
    } else {
      mappedRecords.addAll(widget.appController.records);
    }

    init(); // inii image load
  }

  Future<void> init() async {
    Matrix4 matrix4 = Matrix4(2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
    controller = TransformationController(matrix4);

    final ByteData data = await rootBundle.load(carte);
    image = await loadImage(Uint8List.view(data.buffer));

    height = image!.height;
    width = image!.width;
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  void _showAction(BuildContext context, Record r) async {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Image.network(r.imageURL,
              loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const MaterialApp(home: null);
    }
    return InteractiveViewer(
        transformationController: controller, //pas très utile mais bon
        // minScale: 0.1,
        // maxScale: 5.0,
        constrained: false,
        child: Stack(children: [
          CustomPaint(
            size: Size(image!.width.toDouble(), image!.height.toDouble()),
            foregroundPainter:
                TestPainter(image!, widget.appController.records),
          ),
          ...mappedRecords.entries
              .map((observation) => Positioned(
                    left: observation.value.getMapPosition().dx * width,
                    top: observation.value.getMapPosition().dy * height,
                    child: Tooltip(
                      message: widget.appController
                          .getSpeciesByID(observation.value.speciesID)!
                          .venacular,
                      padding: const EdgeInsets.all(20),
                      showDuration: const Duration(seconds: 10),
                      decoration: const ShapeDecoration(
                        color: Colors.blue,
                        shape: ToolTipCustomShape(),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                      child: IconButton(
                          // iconSize: 20,
                          color: Colors.red.withOpacity(0.7),
                          onPressed: () {
                            _showAction(context, observation.value);
                          },
                          icon: const Icon(Icons.info, size: 10)),
                    ),
                  ))
              .toList(),
        ]));
  }
}

class TestPainter extends CustomPainter {
  final Map<int, Record> recs;
  final ui.Image image;
  TestPainter(this.image, this.recs);

  final textStyle = ui.TextStyle(
    color: Colors.black,
    fontSize: 15,
  );
  final paragraphStyle = ui.ParagraphStyle(
    textDirection: TextDirection.ltr,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final pwhi = Paint()..color = Colors.white;
    // final pred = Paint()..color = Colors.red;
    canvas.drawImage(image, const Offset(0.0, 0.0), pwhi);

    // for (var element in recs.entries) {
    //   canvas.drawCircle(_getOffset(element.value), 5, pred);
    //   // canvas.drawParagraph(paragraph, _getOffset(element.value));
    // }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ToolTipCustomShape extends ShapeBorder {
  final bool usePadding;

  const ToolTipCustomShape({this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect =
        Rect.fromPoints(rect.topLeft, rect.bottomRight - const Offset(0, 20));
    return Path()
      ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 3)))
      ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
      ..relativeLineTo(10, 20)
      ..relativeLineTo(10, -20)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

import 'dart:convert';
import 'dart:io';

import 'package:eudoria/src/app_exception.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:eudoria/src/app_model.dart';
import 'package:eudoria/src/app_service.dart';
import 'package:eudoria/src/services/scheme_service.dart';

/// Applies a plugin for finding commonly used locations on the filesystem.
/// see:
/// https://pub.dev/packages/path_provider
class PlatformService implements AppService {
  @override
  Future<ThemeMode> themeMode() async => ThemeMode.light;

  @override
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  // 1. Set the correct local path (in Documents directory).
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // 2. Create a reference to the file location.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/eudoria.txt');
  }

  // Read from persisted file and return an Observation.
  @override
  Future<Observation> getStoredObservation() async {
    late Observation observation;

    try {
      final file = await _localFile;

      if (file.existsSync()) {
        String jsonText = file.readAsStringSync();
        double bytes = 0;
        utf8.encode(jsonText).forEach((e) => bytes++);
        final parsed = jsonDecode(jsonText);
        observation = Observation.fromJson(parsed["observation"]);
        observation.size = bytes;
      } else {
        await importObservation().then((theObservation) {
          observation = theObservation;
        });
      }
    } catch (e) {
      throw PlatformServiceException(
          id: DateTime.now().microsecondsSinceEpoch,
          code: 'PlatformService.getStoredObservation()',
          text: e.toString());
    }
    return observation;
  }

  @override
  Future<bool> storeObservation(Observation observation) async {
    try {
      final file = await _localFile;

      Object contents = observation.toJson();

      file.writeAsString(json.encode(contents));
    } catch (e) {
      throw PlatformServiceException(
        id: DateTime.now().microsecondsSinceEpoch,
        code: 'PlatformService.storeObservation()',
        text: e.toString(),
      );
    }
    return true;
  }

  @override
  Future<Observation> importObservation() async {
    late Observation observation;
    var parsed = {};
    try {
      String jsonText = await rootBundle.loadString("assets/eudoria.json");
      double bytes = 0;
      utf8.encode(jsonText).forEach((e) => bytes++);
      parsed = json.decode(jsonText);
      observation = Observation.fromJson(parsed["observation"]);
      observation.size = bytes;
    } catch (e) {
      throw PlatformServiceException(
        id: DateTime.now().microsecondsSinceEpoch,
        code: 'PlatformService.importObservation()',
        text: e.toString(),
      );
    }

    return observation;
  }

  @override
  Future<void> exportObservation(Observation observation) async {
    try {
      SchemeService service = SchemeService();
      service.exportObservation(observation);
    } catch (e) {
      throw PlatformServiceException(
        id: DateTime.now().microsecondsSinceEpoch,
        code: 'PlatformService.exportObservation()',
        text: e.toString(),
      );
    }
  }
}

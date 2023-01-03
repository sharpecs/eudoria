import 'dart:convert';

import 'package:eudoria/src/app_exception.dart';
import 'package:eudoria/src/app_security.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:eudoria/src/app_model.dart';
import 'package:eudoria/src/app_service.dart';

/// Utilises a plugin for launching the URL with supported schemes. Required as
/// a strategy to export the Application Observation.
///
/// see:
/// https://pub.dev/packages/url_launcher
class SchemeService implements AppService {
  @override
  Future<void> exportObservation(Observation observation) async {
    Object contents = observation.toJson();
    String body = json.encode(contents);
    SecureAppUser user = observation.appUser;

    var url = Uri.parse("mailto:${user.email}?subject=Observations&body=$body");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      throw SchemeServiceException(
        id: DateTime.now().microsecondsSinceEpoch,
        code: 'PlatformService.exportObservation()',
        text: e.toString(),
      );
    }
  }

  @override
  Future<Observation> getStoredObservation() {
    throw UnimplementedError();
  }

  @override
  Future<Observation> importObservation() {
    throw UnimplementedError();
  }

  @override
  Future<bool> storeObservation(Observation observation) {
    throw UnimplementedError();
  }

  @override
  Future<ThemeMode> themeMode() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateThemeMode(ThemeMode theme) {
    throw UnimplementedError();
  }
}

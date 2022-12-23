import 'package:flutter/material.dart';
import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_security.dart';
import 'package:eudoria/src/app_service.dart';

import 'src/app.dart';

void main() async {
  // Set up the Controller, which will glue user settings to multiple Widgets.
  final AppController appController = AppController(PlatformService());

  // Load the user's preferred theme while the splash screen is displayed. This
  // prevents a sudden theme change when the app is first displayed.
  await appController.loadSettings(AppMode.mobile);
  await appController.loadApplication();

  // Run the app and pass in the Controller. The app listens to the Controller
  // for changes, then passes it further down to the View.
  runApp(MyApp(appController: appController));
}

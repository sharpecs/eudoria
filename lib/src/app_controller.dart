import 'package:eudoria/src/app_exception.dart';
import 'package:eudoria/src/app_router.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:eudoria/src/app_security.dart';
import 'package:eudoria/src/app_service.dart';
import 'package:eudoria/src/app_model.dart';
import 'package:eudoria/src/utils/filter_util.dart';
import 'package:eudoria/src/utils/lookup_util.dart';
import 'package:eudoria/src/widgets/tag_textfield_widget.dart';

/// A class that many Widgets can interact with to establish application state.
///
/// Controllers glue Data Services to Flutter Widgets. Centralising state means
/// all widgets will be rebuilt when the Controller notifies (declarative).
class AppController with AppProvider, ChangeNotifier {
  /// Constructs a new controller with a required dedicated [AppService].
  AppController(this._appService);

  /// A varable to control navigational paths defined by the [MaterialApp].
  int _routerIndex = 0;

  /// Allows widgets to identify a navigational path.
  int get routerIndex => _routerIndex;

  /// Allows Widgets to set a navigational path.
  set routerIndex(int idx) {
    _routerIndex = idx;

    if (_routerIndex == 1) {
      // apply this condition to set any objects when routing.
    }

    if (appUser.canAccess(_routerIndex)) {
      notifyListeners();
    }
  }

  // Make Service a private variable so it is not used directly.
  late SecureAppManager accessManager;

  // Make Service a private variable so it is not used directly.
  final AppService _appService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  /// Loads any platform-centric application settings via the [AppService].
  Future<void> loadSettings(AppMode aMode) async {
    accessManager = SecureAppManager(aMode);
    _themeMode = await _appService.themeMode();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  bool _backButton = false;

  bool get usingBackButton => _backButton;
  backButtonOn() => _backButton = true;
  backButtonOff() => _backButton = false;

  bool get isWebsite => accessManager.aMode == AppMode.web ? true : false;

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _appService.updateThemeMode(newThemeMode);
  }

  // Lookup feature.
  LookupDirectorUtil? _lookup;
  LookupDirectorUtil? get lookup => _lookup;
  void setLookup(LookupDirectorUtil aLookup) => {_lookup = aLookup};

  // Search Filtering feature.
  FilterDirectorUtil? _filter;
  FilterDirectorUtil? get filter => _filter;
  void setFilter(FilterDirectorUtil aFilter) => {_filter = aFilter};

  // Tag widget feature (third party).
  final TagWidgetDirector _tags = TagWidgetUtil();
  TagWidgetDirector get tags => _tags;

  /// Load the application state. It may loaded from a local database or http.
  ///
  /// Throws an Error.
  Future<bool> loadApplication() async {
    bool success = false;

    // Ensure file system is bound to flutter framework.
    WidgetsFlutterBinding.ensureInitialized();

    try {
      isWebsite
          ? await _appService.importObservation().then((theObservation) {
              setApplicationObservation(theObservation);
            })
          : await _appService.getStoredObservation().then((theObservation) {
              setApplicationObservation(theObservation);
            });
      accessManager.authorise(appUser);
      if (!accessManager.auth) {
        Observer o = Observer(
            observerID: appUser.id, name: appUser.name, email: appUser.email);
        addObserver(o);
      }
      routerIndex = appUser.permissions.credentials.first;
    } catch (e) {
      e as AppException;
      throw ErrorDescription('${e.code} -> ${e.text}');
    }

    // Setup recoverable error handling for flutter builds.
    exceptions.remove(0);
    FlutterError.onError = (details) {
      // FlutterError.presentError(details);
      AppException e = AppException(
          id: DateTime.now().microsecondsSinceEpoch,
          code: InitIndex(routerIndex).routePath.toString(),
          text: details.exceptionAsString());
      addException(e);
      saveApplication();
      if (kReleaseMode) exit(1);
    };

    return success;
  }

  /// Save the application state. Either to a local database or via http.
  ///
  /// Throws an Error.
  Future<bool> saveApplication() async {
    bool success = false;
    try {
      if (accessManager.authToSave) {
        await _appService.storeObservation(observation).then((success) {});
      }
    } catch (e) {
      e as AppException;
      throw ErrorDescription('${e.code} -> ${e.text}');
    }

    return success;
  }

  /// Reset the application state. Clear and set Application to default values.
  ///
  /// Throws an Error.
  Future<bool> resetApplication() async {
    bool success = false;

    try {
      // 1. use service to delete saved state.
      // 2. use Provider to clear state in memory.

    } catch (e) {
      e as AppException;
      throw ErrorDescription('${e.code} -> ${e.text}');
    }

    return success;
  }

  Future<bool> exportApplication() async {
    bool success = false;

    try {
      if (accessManager.authToSave) {
        await _appService.exportObservation(observation).then((success) {});
      }
    } catch (e) {
      e as AppException;
      throw ErrorDescription('${e.code} -> ${e.text}');
    }

    return success;
  }
}

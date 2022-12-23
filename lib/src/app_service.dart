import 'package:eudoria/src/app_model.dart';
import 'package:flutter/material.dart';

export 'package:eudoria/src/services/platform_service.dart';

/// Centralises logic across several services and aggregates behavior
/// to provide a uniform service layer for the AppController.
abstract class AppService {
  // colour theme mode for application.
  Future<ThemeMode> themeMode();

  // operation to update colour theme mode for application.
  Future<void> updateThemeMode(ThemeMode theme);

  // Retrieves stored Observation for the Application.
  Future<Observation> getStoredObservation();

  // Imports an external Observation into the Application.
  Future<Observation> importObservation();

  // Stores the current state of the Application Observation.
  Future<bool> storeObservation(Observation observation);

  // Exports the current Application Observation.
  Future<void> exportObservation(Observation observation);
}

import 'package:flutter/material.dart';

import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_router.dart';
import 'package:eudoria/src/widgets/app_navbar_widget.dart';

export 'package:eudoria/src/views/settings_view.dart';
export 'package:eudoria/src/views/landing_view.dart';
export 'package:eudoria/src/views/observation_view.dart';
export 'package:eudoria/src/views/map_view.dart';
export 'package:eudoria/src/views/record_view.dart';
export 'package:eudoria/src/views/species_view.dart';

// Available Route Paths
mixin AppRouter {}

// 0
class LandingViewPath with AppRouter {
  static const pathIndex = LandingView.viewIndex;
  static const path = '/home';
}

// 1
class ObservationViewPath with AppRouter {
  static const pathIndex = ObservationView.viewIndex;
  static const path = '/observation';
}

// 2
class MapViewPath with AppRouter {
  static const pathIndex = MapView.viewIndex;
  static const path = '/map';
}

// 3
class RecordViewPath with AppRouter {
  static const pathIndex = RecordView.viewIndex;
  static const path = '/record';
}

// 4
class SpeciesViewPath with AppRouter {
  static const pathIndex = SpeciesView.viewIndex;
  static const path = '/species';
}

// 5
class SettingsViewPath with AppRouter {
  static const pathIndex = SettingsView.viewIndex;
  static const path = '/settings';
}

class ViewsRouteInformationParser extends RouteInformationParser<AppRouter> {
  @override
  Future<AppRouter> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location.toString());

    if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == RecordView.viewName) {
      return RecordViewPath();
    }
    if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == MapView.viewName) {
      return MapViewPath();
    }
    if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == SpeciesView.viewName) {
      return SpeciesViewPath();
    }
    if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == ObservationView.viewName) {
      return ObservationViewPath();
    }
    if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == LandingView.viewName) {
      return LandingViewPath();
    }
    if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == SettingsView.viewName) {
      return SettingsViewPath();
    }

    return landing.routePath;
  }

  @override
  RouteInformation restoreRouteInformation(AppRouter configuration) {
    if (configuration is LandingViewPath) {
      return const RouteInformation(location: LandingViewPath.path);
    }
    if (configuration is SettingsViewPath) {
      return const RouteInformation(location: SettingsViewPath.path);
    }
    if (configuration is ObservationViewPath) {
      return const RouteInformation(location: ObservationViewPath.path);
    }
    if (configuration is RecordViewPath) {
      return const RouteInformation(location: RecordViewPath.path);
    }
    if (configuration is SpeciesViewPath) {
      return const RouteInformation(location: SpeciesViewPath.path);
    }
    if (configuration is MapViewPath) {
      return const RouteInformation(location: MapViewPath.path);
    }

    return const RouteInformation(location: '/404');
  }
}

class InitIndex {
  List<AppRouter> paths = [
    ObservationViewPath(),
    MapViewPath(),
    RecordViewPath(),
    SpeciesViewPath(),
    SettingsViewPath(),
    LandingViewPath(),
  ];

  final int idx;

  InitIndex(this.idx);

  AppRouter get routePath => paths[idx];
}

late InitIndex landing;

class ViewsRouterDelegate extends RouterDelegate<AppRouter>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouter> {
  // ignore: annotate_overrides
  final GlobalKey<NavigatorState> navigatorKey;

  AppController appController;

  // ViewsAppState appState = ViewsAppState();

  ViewsRouterDelegate(this.appController)
      : navigatorKey = GlobalKey<NavigatorState>() {
    appController.addListener(notifyListeners);
    landing = InitIndex(appController.appUser.permissions.credentials.first);
  }

  @override
  AppRouter get currentConfiguration {
    if (appController.routerIndex == ObservationViewPath.pathIndex) {
      return ObservationViewPath();
    }
    if (appController.routerIndex == MapViewPath.pathIndex) {
      return MapViewPath();
    }
    if (appController.routerIndex == RecordViewPath.pathIndex) {
      return RecordViewPath();
    }
    if (appController.routerIndex == SpeciesViewPath.pathIndex) {
      return SpeciesViewPath();
    }
    if (appController.routerIndex == SettingsViewPath.pathIndex) {
      return SettingsViewPath();
    }

    return LandingViewPath();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: AppNavbarWidget(
            appController: appController,
          ),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        notifyListeners();
        return true;
      },
    );
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> setNewRoutePath(AppRouter path) async {
    if (path is ObservationViewPath) {
      appController.routerIndex = ObservationViewPath.pathIndex;
    }
    if (path is LandingViewPath) {
      appController.routerIndex = LandingViewPath.pathIndex;
    }
    if (path is RecordViewPath) {
      appController.routerIndex = RecordViewPath.pathIndex;
    }
    if (path is SpeciesViewPath) {
      appController.routerIndex = SpeciesViewPath.pathIndex;
    }
    if (path is SettingsViewPath) {
      appController.routerIndex = SettingsViewPath.pathIndex;
    }
  }
}

class InnerRouterDelegate extends RouterDelegate<AppRouter>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouter> {
  InnerRouterDelegate(this._appController);

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AppController _appController;
  // allow inner router controller to be available or external actions.
  AppController get controller => _appController;

  // set appState(ViewsAppState value) {
  //   if (value == _appState) {
  //     return;
  //   }
  //   _appState = value;
  //   notifyListeners();
  // }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_appController.routerIndex == RecordView.viewIndex) ...[
          MaterialPage(
            key: ValueKey(_appController.routerIndex),
            child: RecordView(controller: _appController),
          ),
        ],
        if (_appController.routerIndex == ObservationView.viewIndex) ...[
          MaterialPage(
            key: ValueKey(_appController.routerIndex),
            child: ObservationView(controller: _appController),
          ),
        ],
        if (_appController.routerIndex == LandingView.viewIndex) ...[
          MaterialPage(
            key: ValueKey(_appController.routerIndex),
            child: LandingView(controller: _appController),
          ),
        ],
        if (_appController.routerIndex == MapView.viewIndex) ...[
          MaterialPage(
            key: ValueKey(_appController.routerIndex),
            child: MapView(controller: _appController),
          ),
        ],
        if (_appController.routerIndex == SpeciesView.viewIndex) ...[
          MaterialPage(
            key: ValueKey(_appController.routerIndex),
            child: SpeciesView(controller: _appController),
          ),
        ],
        if (_appController.routerIndex == SettingsView.viewIndex) ...[
          MaterialPage(
            key: ValueKey(_appController.routerIndex),
            child: SettingsView(controller: _appController),
          ),
        ],
      ],
      onPopPage: (route, result) {
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> setNewRoutePath(AppRouter path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }

  // void _handleBookTapped(Book book) {
  //   appState.selectedBook = book;
  //   notifyListeners();
  // }
}

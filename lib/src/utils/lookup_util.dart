import 'package:eudoria/src/app_router.dart';

/// Utility that promotes the use of a list view by another view for searching
/// and selecting attributes. This approach encapsulates collective behaviour
/// in a separate (concrete) Mediator object to preserve state.
abstract class LookupDirectorUtil {
  bool isActive = false; // flag indicating lookup status.
  int lookupID = 0; // unique id recognised by all views.
  int _viewRouteIndex = 0; // view calling the lookup.
  int _lookupRouteIndex = 0; // route for the lookup view with search.
  final List<Map<String, Object>> _transientState = [];

  int popLookup() {
    return _viewRouteIndex;
  }

  int pushLookup() {
    return _lookupRouteIndex;
  }

  /// Temporarily set a form field state when the lookup isActive.
  /// The lookup will call a setState when popping which will initialise.
  void setFieldState(String name, Object field) {
    bool found = false;
    for (var element in _transientState) {
      if (element.containsKey(name)) {
        found = true;
        element[name] = field;
      }
    }
    if (!found) _transientState.add({name: field});
  }

  /// Retrieve the form field state when lookup is not active and the view
  /// is being initialised to restore any field settings.
  Object? getFieldState(String name) {
    Object? found;
    for (var element in _transientState) {
      if (element.containsKey(name)) {
        found = element[name];
      }
    }

    return found;
  }
}

// An interface for communication with other views for looking up or searching.
abstract class LookupView {
  /// Define this Lookup View by initialising.
  void initLookup();
}

/// Implements cooperative behaviour by coordinating communication between a
/// concrete lookup view and the calling view.
class ConcreteLookupDirector extends LookupDirectorUtil {
  ConcreteLookupDirector(int routeIndex) {
    super._viewRouteIndex = routeIndex;
    super._lookupRouteIndex = LandingView.viewIndex;
  }
}

// /// Implements cooperative behaviour by coordinating communication between
// /// the species lookup view and the calling view.
class SpeciesLookupDirector extends LookupDirectorUtil {
  SpeciesLookupDirector(int routeIndex) {
    super._viewRouteIndex = routeIndex;
    super._lookupRouteIndex = SpeciesView.viewIndex;
  }
}

// /// Implements cooperative behaviour by coordinating communication between
// /// the map view and the calling view.
class MapLookupDirector extends LookupDirectorUtil {
  MapLookupDirector(int routeIndex) {
    super._viewRouteIndex = routeIndex;
    super._lookupRouteIndex = MapView.viewIndex;
  }
}

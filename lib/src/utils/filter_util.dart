import 'package:eudoria/src/app_model.dart';

/// Utility that promotes the use of a [FilteringDialog] for filtering the rows
/// available in a List View. This approach encapsulates collective behaviour
/// in a separate (concrete) Mediator object to preserve state.
abstract class FilterDirectorUtil {
  bool isActive = false; // flag indicating lookup status.
  int lookupID = 0; // unique id recognised by all views.
  int _viewRouteIndex = 0; // view calling the lookup.
  int _filterRouteIndex = 0; // route for the lookup view with search.
  final List<Map<String, Object>> _transientState = [];

  int popFilter() {
    return _viewRouteIndex;
  }

  int pushFilter() {
    return _filterRouteIndex;
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

  /// Method for handling any requests which this director is responsible for.
  handle();

  /// Method for adding the [FilteringChain] to directors responsibilities.
  setSuccessor(FilteringChain s);
}

/// A chaining option for allowing multiple filtering responsibilities to be
/// assigned to the [FilterDirectorUtil].
abstract class FilteringChain {
  FilteringChain? _successor;

  /// Method that provides the operation to handle the filtering.
  filter();

  /// The next filtering operation to be handled.
  FilteringChain? get successor => _successor;

  /// Sets the next filtering operation.
  setSuccessor(FilteringChain s) {
    if (_successor != null) {
      _successor!.setSuccessor(s);
    } else {
      _successor = s;
    }
  }
}

// An interface for communication with other views for searching with a filter.
abstract class FilteringDialog {
  /// Define this filter View by initialising.
  void initFilter();
}

/// A concrete [FilterDirectorUtil] that implements cooperative behaviour by
/// coordinating communication between the list view and the filtering dialog.
class FilteringChainDirector extends FilterDirectorUtil {
  FilteringChain? _chain;

  @override
  handle() {
    if (_chain == null) {
      return;
    }
    if (_chain!.successor != null) {
      _chain!.successor!.filter();
    } else {
      _chain!.filter();
    }
  }

  @override
  setSuccessor(FilteringChain s) {
    if (_chain != null) {
      _chain!.setSuccessor(s);
      _chain!.filter();
    } else {
      _chain = s;
    }
  }
}

class FilterRecordsByDate extends FilteringChain {
  Map<int, Record>? _records;
  int _startDate = 0;
  int _endDate = 0;

  FilterRecordsByDate(
      Map<int, Record> fRecords, DateTime? sDate, DateTime? eDate) {
    _records = fRecords;
    DateTime start = sDate ?? DateTime(2022);
    DateTime end = eDate ?? sDate ?? DateTime(2101);
    _startDate = start.millisecondsSinceEpoch * 1000;
    _endDate = end.millisecondsSinceEpoch * 1000;
  }

  @override
  filter() {
    _records!.removeWhere((k, v) {
      return k < _startDate && k < _endDate;
    });
    if (successor != null) successor!.filter();
  }
}

class FilterRecordsBySpecies extends FilteringChain {
  Map<int, Record>? _records;
  List<int>? _speciesIDs;

  FilterRecordsBySpecies(Map<int, Record> fRecords, List<int> species) {
    _records = fRecords;
    _speciesIDs = species;
  }

  @override
  filter() {
    _records!.removeWhere((k, v) => !_speciesIDs!.contains(v.speciesID));
    if (successor != null) successor!.filter();
  }
}

class FilterRecordsOnCondition extends FilteringChain {
  Map<int, Record>? _records;
  String? _condition;

  FilterRecordsOnCondition(Map<int, Record> fRecords, String condition) {
    _records = fRecords;
    _condition = condition;
  }

  @override
  filter() {
    List<int> foundKey = [];
    for (var r in _records!.entries) {
      if (r.value.conditionalTags.isEmpty) {
        foundKey.add(r.key);
      }
      for (var c in r.value.conditionalTags) {
        if (!c.toLowerCase().contains(_condition!.toLowerCase())) {
          foundKey.add(r.key);
        }
      }
    }
    _records!.removeWhere((k, v) => foundKey.contains(k));

    if (successor != null) successor!.filter();
  }
}

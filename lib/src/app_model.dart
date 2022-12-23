import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:eudoria/src/app_security.dart';

/// A class used to expose this application model domain and provide a simple
/// state management with usage of a controller.
///
/// see:
/// https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
mixin AppProvider {
  late Observation? _observation;
  late Record? _record;

  Map<int, Species> get species => _observation!.species;
  Map<int, Record> get records => _observation!.records;
  Map<int, Observer> get observers => _observation!.observers;
  SecureAppUser get appUser => _observation!.appUser;
  Observation get observation => _observation!;

  set record(Record r) => _record = r;
  Record get record => _record!;

  set locations(List<String> l) => _observation!.locations = l;
  List<String> get locations => _observation!.locations;

  Species getSpeciesUnknown() {
    Species unknown = _observation!.species.values
        .firstWhere((s) => s.kingdomId == 'UNKNOWN');

    return unknown;
  }

  Species? getSpeciesByID(int id) {
    Species? s;

    _observation!.species.forEach((key, value) {
      if (key == id) {
        s = value;
      }
    });

    return s;
  }

  List<int>? getSpeciesByClassID(List<String> classIDs) {
    List<int>? s = [];

    _observation!.species.forEach((key, value) {
      if (classIDs.contains(value.classId)) {
        s.add(value.speciesId);
      }
    });

    return s;
  }

  List<int>? getSpeciesByKingdomID(List<String> kingdomIDs) {
    List<int>? s = [];

    _observation!.species.forEach((key, value) {
      if (kingdomIDs.contains(value.kingdomId)) {
        s.add(value.speciesId);
      }
    });

    return s;
  }

  Observer? getObserverByID(int id) {
    Observer? o;

    _observation!.observers.forEach((key, value) {
      if (key == id) {
        o = value;
      }
    });

    return o;
  }

  Record? getRecordByID(int id) {
    Record? r;

    _observation!.records.forEach((key, value) {
      if (key == id) {
        r = value;
      }
    });

    return r;
  }

  void setApplicationObservation(Observation aObservation) =>
      _observation = aObservation;

  void addRecord(Record aRecord) {
    _observation!.records.update(
      aRecord.timestamp,
      (existingValue) => aRecord,
      ifAbsent: () => aRecord,
    );
  }

  void addObserver(Observer anObserver) {
    _observation!.observers.update(
      anObserver.observerID,
      (existingValue) => anObserver,
      ifAbsent: () => anObserver,
    );
  }

  void addSpecies(Species aSpecies) {
    _observation!.species.update(
      aSpecies.speciesId,
      (existingValue) => aSpecies,
      ifAbsent: () => aSpecies,
    );
  }
}

class Observation {
  Map<int, Species> species;
  Map<int, Record> records;
  Map<int, Observer> observers;
  SecureAppUser appUser;
  List<String> locations = [];
  double size = 0;

  // A default species when none is available.
  static final Observation blank = Observation(
      species: {},
      records: {},
      observers: {},
      appUser: SecureAppUser(id: 0, name: '', email: ''),
      locations: []);

  Observation(
      {required this.species,
      required this.records,
      required this.observers,
      required this.appUser,
      required this.locations});

  /// A factory that takes in a map (JSON) and returns the correct data object.
  factory Observation.fromJson(List list) {
    List<SecureAppUser> registered = list[0]["registered"]
        .map<SecureAppUser>((json) => SecureAppUser.fromJson(json))
        .toList();

    List<Species> lSpecies = list[1]["species"]
        .map<Species>((json) => Species.fromJson(json))
        .toList();

    if (lSpecies.isEmpty) {
      lSpecies.add(Species.unknown);
    }

    Map<int, Species> nSpecies = {};

    for (var e in lSpecies) {
      nSpecies.update(
        e.speciesId,
        (value) => e,
        ifAbsent: () => e,
      );
    }

    List<Observer> lObservers = list[2]["observers"]
        .map<Observer>((json) => Observer.fromJson(json))
        .toList();

    Map<int, Observer> nObservers = {};

    for (var e in lObservers) {
      nObservers.update(
        e.observerID,
        (value) => e,
        ifAbsent: () => e,
      );
    }

    //Observation Records Map.
    Map<int, Record> nRecords = {};
    for (Map e in list) {
      if (e.keys.contains('records')) {
        List<Record> lRecords =
            e['records'].map<Record>((json) => Record.fromJson(json)).toList();

        for (var r in lRecords) {
          nRecords.update(
            r.timestamp,
            (value) => r,
            ifAbsent: () => r,
          );
        }
      }
    }

    // Observation Locations List.
    List<String> nLocations = [];
    for (Map element in list) {
      if (element.keys.contains('locations')) {
        element['locations'].toList().forEach((l) => nLocations.add(l));
      }
    }
    if (nLocations.isEmpty) nLocations.add("OTHER");

    return Observation(
        species: nSpecies,
        records: nRecords,
        observers: nObservers,
        appUser: registered[0],
        locations: nLocations);
  }

  /// A function to convert the current object to a map for storing as JSON.
  Map<String, dynamic> toJson() => {
        "observation": [
          {
            "registered": [appUser.toJson()]
          },
          {"species": species.entries.map<Species>((s) => s.value).toList()},
          {
            "observers":
                observers.entries.map<Observer>((o) => o.value).toList()
          },
          {"records": records.entries.map<Record>((r) => r.value).toList()},
          {"locations": locations.toList()}
        ]
      };
}

/// A related group of organisms belonging to a category of dominion.
class TaxonKingdom {}

/// A related group of organisms based on distinct layout of organ systems.
enum TaxonClass { mammal, bird, reptile }

/// Organisms conforming to certain fixed properties.
class Species {
  late final int speciesId;
  String name;
  String venacular;
  String other;
  String genus;
  String classId;
  String kingdomId;
  bool canDelete;

  static const String kingdomUnknown = 'UNKNOWN';
  static const String kingdomAnimal = 'ANIMAL';
  static const String kingdomPlant = 'PLANT';
  static const String kingdomFungi = 'FUNGI';
  static const String kingdomBacteria = 'BACTERIA';
  static const String kingdomAlgae = 'ALGAE';

  static List<String> kingdomList = <String>[
    kingdomUnknown,
    kingdomAnimal,
    kingdomPlant,
    kingdomFungi,
    kingdomBacteria,
    kingdomAlgae
  ];

  static const List<String> classList = <String>[
    'UNKNOWN',
    'MAMMAL',
    'BIRD',
    'REPTILE',
    'AMPHIBIAN',
    'FISH',
    'ANTHROPOD',
    'FERN',
    'MONOCOTYLEDON',
    'DICOTYLEDON',
    'CONIFER',
    'AGARICOMYCETE'
  ];

  // A default species when none is available.
  static final Species unknown = Species(
    speciesId: DateTime.now().microsecondsSinceEpoch,
    name: 'Unknown',
    venacular: '',
    genus: 'Unknown',
    other: '',
    classId: 'UNKNOWN',
    kingdomId: kingdomUnknown,
    canDelete: false,
  );

  // constructor.
  Species({
    required this.speciesId,
    required this.name,
    required this.venacular,
    required this.genus,
    required this.other,
    required this.classId,
    required this.kingdomId,
    required this.canDelete,
  });

  /// A factory that takes in a map (JSON) and returns the correct data object.
  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      speciesId: json['i'] as int,
      name: json['n'] as String,
      venacular: json['v'] as String,
      genus: json['g'] as String,
      other: json['o'] as String,
      classId: json['c'] as String,
      kingdomId: json['k'] as String,
      canDelete: json['d'] as bool,
    );
  }

  /// A function to convert the current object to a map for storing as JSON.
  Map<String, dynamic> toJson() => {
        "i": speciesId,
        "n": name,
        "v": venacular,
        "g": genus,
        "o": other,
        "c": classId,
        "k": kingdomId,
        "d": canDelete,
      };

  CircleAvatar getAvatar() {
    var ico = Icons.pets;
    // pets, forrest, alt_route, egg_alt, android, air, compost
    // .local_florist_outlined

    switch (kingdomId) {
      case kingdomUnknown:
        {
          ico = Icons.question_mark;
        }
        break;
      case kingdomPlant:
        {
          ico = Icons.local_florist_outlined;
        }
        break;
      case kingdomAnimal:
        {
          ico = Icons.pets;
        }
        break;
      case kingdomFungi:
        {
          ico = Icons.android;
        }
        break;
      case kingdomBacteria:
        {
          ico = Icons.coronavirus_outlined;
        }
        break;
      case kingdomAlgae:
        {
          ico = Icons.air;
        }
        break;
    }
    return CircleAvatar(
        radius: 19,
        backgroundColor: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Icon(ico)]));
  }
}

/// A recorded observation.
class Observer {
  final int observerID;
  String name;
  String email;

  // constructor.
  Observer({
    required this.observerID,
    required this.name,
    required this.email,
  });

  factory Observer.fromJson(Map<String, dynamic> json) {
    return Observer(
        observerID: json['i'] as int,
        name: json['n'] as String,
        email: json['e'] as String);
  }

  /// A function to convert the current object to a map for storing as JSON.
  Map<String, dynamic> toJson() => {
        "i": observerID,
        "n": name,
        "e": email,
      };
}

/// A recorded observation.
class Record {
  final int timestamp;
  int speciesTally;
  int speciesID;
  int observerID;
  double? longitude;
  double? latitude;
  String imageURL;
  String locality;
  List<String> conditionalTags;

  // constructor.
  Record({
    required this.timestamp,
    required this.longitude,
    required this.latitude,
    required this.speciesTally,
    required this.speciesID,
    required this.observerID,
    required this.imageURL,
    required this.locality,
    required this.conditionalTags,
  });

  DateTime getTimestamp() => DateTime.fromMicrosecondsSinceEpoch(timestamp);

  /// A factory that takes in a map (JSON) and returns the correct data object.
  factory Record.fromJson(Map<String, dynamic> json) {
    List<String> nTags = [];
    for (var e in json['c']) {
      nTags.add(e.toString());
    }

    return Record(
        timestamp: json['t'] as int,
        longitude: json['y'] as double,
        latitude: json['x'] as double,
        speciesTally: json['q'] as int,
        speciesID: json['s'] as int,
        observerID: json['o'] as int,
        imageURL: json['i'] as String,
        locality: json['l'] as String,
        conditionalTags: nTags);
  }

  /// A function to convert the current object to a map for storing as JSON.
  Map<String, dynamic> toJson() => {
        "t": timestamp,
        "y": longitude,
        "x": latitude,
        "q": speciesTally,
        "s": speciesID,
        "o": observerID,
        "i": imageURL,
        "l": locality,
        "c": conditionalTags,
      };

  // pets, forrest, alt_route, egg_alt, android, air, compost
  // .local_florist_outlined

  CircleAvatar getAvatar() {
    return CircleAvatar(
        radius: 19,
        backgroundColor: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [Icon(Icons.compost)]));
  }

  String getDateDisplayTS() {
    var formatter = DateFormat('EEE, d/M/y');
    String formattedTime = DateFormat('kk:mm:ss a').format(getTimestamp());
    String formattedDate = formatter.format(getTimestamp());
    return '$formattedDate $formattedTime';
  }

  String _formatDateMonth() {
    var formatter = DateFormat('d MMM');
    String formattedDate = formatter.format(getTimestamp());
    return formattedDate;
  }

  String _formatDateYear() {
    var formatter = DateFormat('yyyy');
    String formattedDate = formatter.format(getTimestamp());
    return formattedDate;
  }

  Widget getDateDisplay() {
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          _formatDateMonth(),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 0.1),
        Text(
          _formatDateYear(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10.0,
          ),
        )
      ]),
    ]);
  }

  Offset getMapPosition() {
    double x = ((longitude! - 116) * 1000000 * 0.131 + 350) / 1000;
    double y = ((-1 * latitude! - 32.08) * 1000000 * 0.153 + 270) / 1000;

    return Offset(x, y);
  }
}

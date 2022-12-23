import 'package:eudoria/src/app_builder.dart';
import 'package:flutter/material.dart';

import 'package:textfield_tags/textfield_tags.dart';

import 'package:eudoria/src/app.dart';
import 'package:eudoria/src/app_controller.dart';

class TagTextFieldWidget extends StatefulWidget with TagWidget {
  const TagTextFieldWidget({
    Key? key,
    required this.title,
    required this.appController,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final AppController appController;

  @override
  State<TagTextFieldWidget> createState() => _TagTextFieldState();

  @override
  void initTagWidget() {
    appController.tags.isActive = true;
  }
}

class _TagTextFieldState extends State<TagTextFieldWidget> {
  late double _distanceToField;
  late TextfieldTagsController _controller;
  late List<String> tags = [];
  late List<String> initags = [];
  late List<String> optags = [];
  String stateTag = '';

  static const List<String> _pickCondition = <String>[
    'flowering',
    'injured',
    'sick',
    'botulism',
    'wild',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    // if (!widget.appController.tags.isActive &&
    //     widget.appController.routerIndex == RecordView.viewIndex) {
    //   _controller.dispose();
    // }
  }

  @override
  void initState() {
    super.initState();
    stateTag = '${widget.title.toLowerCase()}Tags';
    var val = widget.appController.tags.getTagState(stateTag) as List;
    if (val.isNotEmpty) initags = val as List<String>;
    var oTag = '${widget.title.toLowerCase()}OptionTags';
    val = widget.appController.tags.getTagState(oTag) as List;
    if (val.isNotEmpty) optags = val as List<String>;
    _controller = TextfieldTagsController();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.97,
            maxHeight: screenSize.height * 0.15),
        child: Container(
            // width: 100,
            // height: screenSize.height * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppStyler.themeData(context).primaryColorDark,
            ),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        Text(
                          ' ${widget.title.toUpperCase()}',
                          style: TextStyle(
                            color: Colors.blueGrey.shade100,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 3,
                          ),
                        )
                      ]),
                      Column(children: [
                        // Icon(Icons.close)
                        InkWell(
                          child: Icon(
                            Icons.cancel,
                            size: 20.0,
                            color: Colors.blueGrey[100],
                          ),
                          onTap: () {
                            _controller.clearTags();
                          },
                        )
                      ]),
                    ]),
                Expanded(
                    child: Container(
                  width: double.infinity,
                  // height: screenSize.height * 0.12,
                  decoration: BoxDecoration(
                      color: AppStyler.themeData(context).backgroundColor),
                  child: Autocomplete<String>(
                    optionsViewBuilder: (context, onSelected, options) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Material(
                            elevation: 4.0,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final dynamic option =
                                      options.elementAt(index);
                                  return TextButton(
                                    onPressed: () {
                                      onSelected(option);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: Text(
                                          '#$option',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 74, 137, 92),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return optags.where((String option) {
                        return option
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selectedTag) {
                      _controller.addTag = selectedTag;
                    },
                    fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                      return TextFieldTags(
                        textEditingController: ttec,
                        focusNode: tfn,
                        textfieldTagsController: _controller,
                        initialTags: initags,
                        textSeparators: const [' ', ','],
                        letterCase: LetterCase.normal,
                        validator: (String tag) {
                          if (tag == 'php') {
                            return 'No, please just no';
                          } else if (_controller.getTags!.contains(tag)) {
                            return 'you already entered that';
                          }
                          return null;
                        },
                        inputfieldBuilder:
                            (context, tec, fn, error, onChanged, onSubmitted) {
                          return ((context, sc, tags, onTagDelete) {
                            widget.appController.tags
                                .setTagState(stateTag, tags);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                controller: tec,
                                focusNode: fn,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 74, 137, 92),
                                        width: 3.0),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 74, 137, 92),
                                        width: 3.0),
                                  ),
                                  helperText: 'Enter ${widget.title}',
                                  // helperStyle: const TextStyle(
                                  //   color: Color.fromARGB(255, 74, 137, 92),
                                  // ),
                                  hintText: _controller.hasTags
                                      ? ''
                                      : "Select ${widget.title.toLowerCase()} tag...",
                                  errorText: error,
                                  prefixIconConstraints: BoxConstraints(
                                      maxWidth: _distanceToField * 0.74),
                                  prefixIcon: tags.isNotEmpty
                                      ? SingleChildScrollView(
                                          controller: sc,
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: tags.map((String tag) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  // color: Color.fromARGB(
                                                  //     255, 74, 137, 92),
                                                  color: AppStyler.themeData(
                                                          context)
                                                      .primaryColorDark),
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      '#$tag',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onTap: () {
                                                      //print("$tag selected");
                                                    },
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  InkWell(
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      size: 14.0,
                                                      color: Color.fromARGB(
                                                          255, 233, 233, 233),
                                                    ),
                                                    onTap: () {
                                                      onTagDelete(tag);
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                        )
                                      : null,
                                ),
                                onChanged: onChanged,
                                onSubmitted: onSubmitted,
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                  // ElevatedButton(
                  //   style: ButtonStyle(
                  //     backgroundColor: MaterialStateProperty.all<Color>(
                  //       const Color.fromARGB(255, 74, 137, 92),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     _controller.clearTags();
                  //   },
                  //   child: const Text('CLEAR TAGS'),
                  // ),
                ))
              ],
            )));
  }
}

abstract class TagWidgetDirector {
  bool isActive = false; // flag indicating status.

  Map<String, List<String>>? _transientTags = <String, List<String>>{};

  /// Temporarily set a form field state when the lookup isActive.
  /// The lookup will call a setState when popping which will initialise.
  void setTagState(String name, List<String> field) {
    _transientTags!.update(
      name,
      (value) => field,
      ifAbsent: () => field,
    );
  }

  /// Retrieve the form field state when lookup is not active and the view
  /// is being initialised to restore any field settings.
  Object? getTagState(String name) {
    Object? found;
    _transientTags!.forEach((key, value) {
      if (key == name) {
        found = value;
      }
    });

    return found;
  }

  void dispose() {
    assert(() {
      if (!isActive) {
        return true;
      }
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$this was disposed with an active TagWidgetDirector.'),
        ErrorDescription(
          '$runtimeType created a Ticker via its SingleTickerProviderStateMixin, but at the time '
          'dispose() was called on the mixin, that Ticker was still active. The Ticker must '
          'be disposed before calling super.dispose().',
        ),
        ErrorHint(
          'Tickers used by AnimationControllers '
          'should be disposed by calling dispose() on the AnimationController itself. '
          'Otherwise, the ticker will leak.',
        ),
        // _transientTags!.describeForError('The offending ticker was'),
      ]);
    }());
    _transientTags = <String, List<String>>{};
  }
}

// An interface for communication with other views when using widget.
abstract class TagWidget {
  /// Define this Lookup View by initialising.
  void initTagWidget();
}

/// Implements cooperative behaviour by coordinating communication between
/// this Tag widget and the calling view.
class TagWidgetUtil extends TagWidgetDirector {}

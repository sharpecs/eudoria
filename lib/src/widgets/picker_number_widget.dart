import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class PickerNumber extends StatefulWidget {
  const PickerNumber({
    Key? key,
    required this.title,
    required this.iniVal,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<int> onChanged;
  final String title;
  final int iniVal;

  @override
  State<PickerNumber> createState() => _PickerNumberState();
}

class _PickerNumberState extends State<PickerNumber> {
  int _currentValue = 0;
  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.title, style: Theme.of(context).textTheme.headline6),
        NumberPicker(
          value: isInit ? widget.iniVal : _currentValue,
          minValue: 0,
          maxValue: 9,
          itemHeight: 25,
          itemWidth: 70,
          onChanged: (value) => setState(() {
            _currentValue = value;
            isInit = false;
            widget.onChanged(_currentValue);
          }),
        ),
      ],
    );
  }
}

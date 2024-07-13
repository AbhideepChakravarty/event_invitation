import 'package:flutter/material.dart';

class ISDDropdownWidget extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const ISDDropdownWidget({super.key, required this.initialValue, required this.onChanged});

  @override
  _ISDDropdownWidgetState createState() => _ISDDropdownWidgetState();
}

class _ISDDropdownWidgetState extends State<ISDDropdownWidget> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.purple[700]),
      underline: Container(
        height: 2,
        color: Colors.purple[700],
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.onChanged(newValue);
        });
      },
      items: <String>['+1', '+91', '+44', '+61']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

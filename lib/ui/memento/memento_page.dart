import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MementoPage extends StatelessWidget {
  final String mementoRef;
  const MementoPage({super.key, required this.mementoRef});

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text("Mememto Page"),
    );
  }
}

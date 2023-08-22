import 'package:event_invitation/navigation/nav_data.dart';
import 'package:flutter/material.dart';

class Unknown extends StatelessWidget {
  final ValueChanged<EventAppNavigatorData> onTap;

  const Unknown({Key? key, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unknown Page"),
      ),
      //drawer: FastServerAdminDrawer(navSignal: this.onTap),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: const Center(child: Text("This page could not be found.")),
      ),
    );
  }
}

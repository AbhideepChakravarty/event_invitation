import 'package:event_invitation/ui/memento/components/memento_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../navigation/nav_data.dart';
import '../../navigation/router_deligate.dart';

class MementoPage extends StatefulWidget {
  final String mementoRef;
  const MementoPage({super.key, required this.mementoRef});

  @override
  State<MementoPage> createState() => _MementoPageState();
}

class _MementoPageState extends State<MementoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationScale;
  late Animation<double> _rotateAnimation;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationScale = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(_controller);
  }

  void _toggleButtons() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Memento'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            if (isUploading)
              Container(
                color: Colors.red,
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: const Text(
                  'Upload in progress...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    const TabBar(
                      tabs: [
                        Tab(text: 'Photos'),
                        Tab(text: 'Albums'),
                      ],
                      labelColor: Colors
                          .black, // Choose a color that contrasts with the AppBar color
                      unselectedLabelColor: Colors
                          .grey, // Choose a lighter color for unselected tabs
                      labelStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold), // Style for text
                      unselectedLabelStyle: TextStyle(fontSize: 16.0),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Replace with your actual widgets
                          MementoView(mementoId: widget.mementoRef, type: 1),
                          MementoView(mementoId: widget.mementoRef, type: 2),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          mini: true,
          backgroundColor: Colors.deepPurple.shade900,
          foregroundColor: Colors.white,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.cloud_upload_outlined),
              label: 'Upload Media',
              onTap: () {
                print('Upload CHILD');
                var onTap =
                    Provider.of<EventAppRouterDelegate>(context, listen: false)
                        .routeTrigger;
                onTap(EventAppNavigatorData.upload(widget.mementoRef, {}));
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.photo_album_outlined),
              label: 'Create Album',
              onTap: () {
                print('Album CHILD');
                var onTap =
                    Provider.of<EventAppRouterDelegate>(context, listen: false)
                        .routeTrigger;
                onTap(EventAppNavigatorData.upload(widget.mementoRef, {"album" : true}));
              },
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

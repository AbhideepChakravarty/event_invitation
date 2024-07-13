import 'package:event_invitation/ui/pages/memento/components/memento_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import '../../../navigation/nav_data.dart';
import '../../../navigation/router_deligate.dart';

class MementoPage extends StatefulWidget {
  final String mementoRef;
  const MementoPage({super.key, required this.mementoRef});

  @override
  State<MementoPage> createState() => _MementoPageState();
}

class _MementoPageState extends State<MementoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _photosScrollController;
  late ScrollController _albumsScrollController;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _photosScrollController = ScrollController();
    _albumsScrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _photosScrollController.dispose();
    _albumsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memento'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Photos'),
            Tab(text: 'Albums'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle:
              const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 16.0),
        ),
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
            child: TabBarView(
              controller: _tabController,
              children: [
                // Photos tab
                MementoView(
                  mementoId: widget.mementoRef,
                  type: 1,
                  scrollController: _photosScrollController,
                ),
                // Albums tab
                MementoView(
                  mementoId: widget.mementoRef,
                  type: 2,
                  scrollController: _albumsScrollController,
                ),
              ],
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
              var onTap =
                  Provider.of<EventAppRouterDelegate>(context, listen: false)
                      .routeTrigger;
              onTap(EventAppNavigatorData.upload(
                  widget.mementoRef, {"album": true}));
            },
          ),
        ],
      ),
    );
  }
}

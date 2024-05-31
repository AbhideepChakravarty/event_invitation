import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_invitation/services/memento/memento_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/memento/file_upload_data.dart';
import '../../../services/memento/memnto_service.dart';
import 'album_list_widget.dart';
import 'photo_list_view.dart';

class MementoView extends StatefulWidget {
  final String mementoId;
  final int type;

  const MementoView({super.key, required this.mementoId, required this.type});

  @override
  State<MementoView> createState() => _MementoViewState();
}

class _MementoViewState extends State<MementoView> {
  StreamSubscription<DocumentSnapshot>? _uploadStreamSubscription;
  

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uploadId =
          Provider.of<UploadManager>(context, listen: false).currentUploadId;
      if (uploadId != null) {
        _startListeningToUpload(uploadId);
      }
    });
  }

  void _startListeningToUpload(String uploadId) {
    _uploadStreamSubscription = FirebaseFirestore.instance
        .collection('uploadMetadata')
        .doc(uploadId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data()!['status'] == 10) {
        print("Publish completed.");
        Provider.of<UploadManager>(context, listen: false)
            .setCurrentUploadId = null;
        _showRefreshSnackbar();
      }
    }, onError: (error) {
      print("Error listening to upload: $error");
    });
  }

  void _showRefreshSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Publish completed! Please refresh the page to see your uploaded content.'),
        //action: SnackBarAction(
        //  label: 'Refresh',
        //  onPressed: _refreshContent,
        //),
        duration: Duration(seconds: 5),
      ),
    );
  }

  

  @override
  void dispose() {
    _uploadStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MementoContent>(
      future: MementoService.fetchMementoContent(widget.mementoId, widget.type),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final mementoContent = snapshot.data!;

        if (widget.type == 1) {
          return MediaListWidget(mementoContent: mementoContent);
        } else if (widget.type == 2) {
          return AlbumListWidget(
            mementoContent: mementoContent
          );
        } else {
          throw ArgumentError('Unsupported memento type: ${widget.type}');
        }
      },
    );
  }
}

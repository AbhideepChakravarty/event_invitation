import 'package:event_invitation/navigation/nav_data.dart';
import 'package:event_invitation/navigation/router_deligate.dart';
import 'package:event_invitation/services/memento/uplaod_metadata_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../services/memento/file_upload_data.dart';
import '../../../services/memento/upload_metadata_data.dart';
import 'animated_publish_button.dart'; // Adjust the import based on your project structure
import 'upload_media_tile.dart'; // Adjust the import based on your project structure
// Import your UploadManager class

class UploadPage extends StatefulWidget {
  final String mementoRef;
  final bool albumFlag;

  const UploadPage(
      {super.key, required this.mementoRef, required this.albumFlag});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final UploadMetadataService uploadMetadataService = UploadMetadataService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  void _pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      String uploadId = await _getUploadId(widget.mementoRef);
      final uploadManager = Provider.of<UploadManager>(context, listen: false);
      for (var file in result.files) {
        try {
          uploadManager.startUpload(file, widget.mementoRef, uploadId);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload file: ${file.name}'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("This is album page ? ${widget.albumFlag}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Media"),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<UploadManager>(
        builder: (context, uploadManager, child) {
          final uploads = uploadManager.uploads;
          final overallProgress = uploadManager.getOverallProgress();
          final isAllUploadedOrCancelled = uploads.every(
              (upload) => upload.uploadProgress >= 1.0 || upload.isCancelled);

          var showGrid = uploads.isNotEmpty;
          return Column(
            children: [
              widget.albumFlag ? _createAlbumComponent(context) : Container(),
              if (showGrid)
                Expanded(
                  child: _buildThumbnailGrid(uploads),
                ),
              if (!showGrid)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 60),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 2,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(12),
                      // To create a dashed border effect, you might need a custom painter or use an existing package like `flutter_dash`.
                    ),
                    child: Column(
                      mainAxisAlignment: widget.albumFlag
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_upload,
                          size: 64,
                          color: Colors.blueAccent,
                        ),
                        const Text(
                          'DRAG FILES HERE',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Drag & drop files here\nor browse your device',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _pickMedia,
                          child: const Text("BROWSE FILES"),
                        ),
                      ],
                    ),
                  ),
                ),
              if (showGrid)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedProgressPublishButton(
                    progress: overallProgress,
                    onPressed: isAllUploadedOrCancelled
                        ? () => _publishButtonPressed()
                        : null,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _publishButtonPressed() async {
    //print("Publishing..........................");

    // If albumFlag is true, check if the title is not empty
    if (widget.albumFlag && _titleController.text.isEmpty) {
      // Show a SnackBar if the title is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The title cannot be empty for an album.'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Stop the flow if the title is empty
    }

    // Get the path of the files uploaded using the UploadManager
    var uploadManager = Provider.of<UploadManager>(context, listen: false);
    final List<String> filePaths = uploadManager.uploadPaths;

    UploadMetadata uploadMetadata;

    if (widget.albumFlag) {
      // Populate the UploadMetadataDTO
      final albumMetadata = AlbumMetadata(
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        tags: _tagsController.text.isNotEmpty
            ? _tagsController.text.split(',')
            : null,
        userId: FirebaseAuth.instance.currentUser?.uid,
        uploadTime: DateTime.now().toIso8601String(),
      );

      uploadMetadata = UploadMetadata(
        firebaseStoragePaths: filePaths,
        albumMetadata: albumMetadata,
        mementoId: widget.mementoRef,
      );
    } else {
      // Populate the UploadMetadataDTO
      uploadMetadata = UploadMetadata(
          firebaseStoragePaths: filePaths, mementoId: widget.mementoRef);
    }
    uploadMetadata.uploadId = uploadManager.uploadId;
    // Invoke the UploadMetadataService method createUploadMetaData

    uploadMetadataService.createUploadMetadata(uploadMetadata);
    uploadManager.setCurrentUploadId = uploadManager.uploadId;
    uploadManager.resetUpload;
    var navData = EventAppNavigatorData.memento(widget.mementoRef);
    var onTap = Provider.of<EventAppRouterDelegate>(context, listen: false)
        .routeTrigger;
    onTap(navData);
  }

  Widget _buildThumbnailGrid(List<FileUploadModel> uploads) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: uploads.length,
      itemBuilder: (context, index) {
        final uploadModel = uploads[index];
        return UploadMediaTile(
          uploadModel: uploadModel,
        );
      },
    );
  }

  Future<String> _getUploadId(String mementoRef) async {
    // Populate the UploadMetadataDTO
    final uploadMetadata = UploadMetadata(mementoId: widget.mementoRef);

    // Invoke the UploadMetadataService method createUploadMetaData

    return await uploadMetadataService.createUploadMetadata(uploadMetadata)
        as String;
  }

  Widget _createAlbumComponent(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.grey, width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'Tags (comma separated)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

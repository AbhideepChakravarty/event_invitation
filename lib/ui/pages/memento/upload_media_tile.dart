import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/memento/file_upload_data.dart';

class UploadMediaTile extends StatelessWidget {
  final FileUploadModel uploadModel;

  const UploadMediaTile({
    Key? key,
    required this.uploadModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isVideo = uploadModel.file.extension == 'mp4' ||
        uploadModel.file.extension!.toLowerCase() == 'mp4';
    return Container(
      margin: const EdgeInsets.all(4),
      width: 80,
      height:
          100, // Adjust height to accommodate file name and progress indicator
      child: Stack(
        children: [
          // Image or video icon display logic
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isVideo
                  ? Container(
                      color: Colors.black45,
                      child: const Icon(Icons.play_circle_outline,
                          color: Colors.white, size: 48),
                    )
                  : Image.memory(uploadModel.file.bytes!, fit: BoxFit.cover),
            ),
          ),
          // Progress indicator logic
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: uploadModel.uploadProgress,
              backgroundColor: Colors.grey.withAlpha(150),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          // Cancel button logic
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () {
                // Directly use UploadManager for cancellation
                final uploadManager =
                    Provider.of<UploadManager>(context, listen: false);
                uploadManager.cancelUpload(uploadModel.file.name);
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.red, size: 20),
              ),
            ),
          ),
          // File name display logic
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                uploadModel.file.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

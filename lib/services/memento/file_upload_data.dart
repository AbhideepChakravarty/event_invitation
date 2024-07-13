
import 'package:collection/collection.dart';
import 'package:event_invitation/firebase_opti.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FileUploadModel {
  PlatformFile file;
  double uploadProgress;
  bool isCancelled;
  String mementoRef;
  String? uploadPath;

  FileUploadModel({
    required this.file,
    required this.mementoRef,
    this.uploadProgress = 0.0,
    this.isCancelled = false,
    this.uploadPath,
  });
}

class UploadManager with ChangeNotifier {
  static final UploadManager _instance = UploadManager._internal();

  factory UploadManager() {
    return _instance;
  }

  UploadManager._internal();

  // Rest of the class implementation...

   List<FileUploadModel> _uploads = [];
   Map<String, UploadTask> _ongoingUploads = {};
   Map<String, String> _uploadPaths = {};
  String? _uploadId;
  String? _currentUploadId;

  get resetUpload {
    _uploads = [];
    _ongoingUploads = {};
    _uploadId = null;
    _uploadPaths = {};
   
  }

  List<FileUploadModel> get uploads => _uploads;

  void startUpload(PlatformFile file, String mementoRef, String uploadId) {
    _uploadId = uploadId;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';
    final sanitizedFileName = file.name.replaceAll(RegExp(r'[^\w\.]+'), '_');
    final filePath = '$userId/$mementoRef/$uploadId/$sanitizedFileName';

    String bucket =
        "gs://${DefaultFirebaseOptions.currentPlatform.projectId}-memento";
    final fileRef =
        FirebaseStorage.instanceFor(bucket: bucket).ref().child(filePath);
    // Print the file size in GB or MB based on the file size
    final fileSize = file.size;
    final fileSizeInMB = fileSize / (1024 * 1024);
    final fileSizeInGB = fileSizeInMB / 1024;
    //find the content type of the file based on the file extension. Any video or image file can be uploaded, e.g. png, bmp, jpg, jpeg, gif, mp4, etc.
    final contentType =
        file.extension == 'mp4' ? 'video/mp4' : 'image/${file.extension}';

    final uploadTask = fileRef.putData(
      file.bytes!,
      SettableMetadata(contentType: contentType),
    );

    // Create a new upload model
    final uploadModel = FileUploadModel(
      file: file,
      mementoRef: mementoRef,
    );
    _uploads.add(uploadModel);
    _ongoingUploads[file.name] = uploadTask;
    _uploadPaths[file.name] = filePath;

    // Listen to the snapshot events for progress updating
    uploadTask.snapshotEvents.listen(
      (event) {
        final progress = event.bytesTransferred / event.totalBytes;
        // Update the model's progress
        uploadModel.uploadProgress = progress;
        notifyListeners(); // Notify UI of changes
      },
      onError: (error) {
        // Handle any error that occurs during the listening of snapshot events
        uploadModel.isCancelled = true;
        notifyListeners();
      },
    );

    // Handle completion
    uploadTask.whenComplete(() async {
      if (uploadModel.isCancelled) {
        // If cancelled, delete the uploaded file
        await _deleteFileFromStorage(filePath);
      } else {
        print("Upload complete for ${file.name} without cancellation.");
        // Otherwise, set the upload path on successful upload
        uploadModel.uploadPath = await fileRef.getDownloadURL();
      }
      _ongoingUploads.remove(file.name);
      //_uploadPaths.remove(file.name);
      notifyListeners(); // Notify UI of changes
    });
  }

  void cancelUpload(String fileId) {
    print("_uploads: $_uploads");
    // Find the upload model by fileId
    final uploadModel =
        _uploads.firstWhereOrNull((model) => model.file.name == fileId);
    print("Found upload model: $uploadModel for fileId: $fileId");
    if (uploadModel != null) {
      uploadModel.isCancelled = true; // Mark the upload as cancelled

      // Cancel the Firebase upload task if it's ongoing
      final uploadTask = _ongoingUploads[fileId];
      if (uploadTask != null) {
        print(
            "Found in ongoing uploads. Canceling upload for ${uploadModel.file.name}");

        uploadTask.cancel();
        _ongoingUploads
            .remove(fileId); // Remove the task from tracking once canceled
      }

      // Attempt to delete the file from Firebase Storage if it has been partially uploaded
      _deleteFileFromStorage(_uploadPaths[fileId] ?? "");

      // Remove the model from the uploads list and notify listeners to update the UI
      _uploads.remove(uploadModel);
      notifyListeners();
    }
  }

  Future<void> _deleteFileFromStorage(String filePath) async {
    print("Trying to delete file from storage: $filePath");
    if (filePath.isNotEmpty) {
      try {
        await FirebaseStorage.instance.ref(filePath).delete();
        print("Deleted $filePath from Firebase Storage.");
      } catch (e) {
        print("Error deleting $filePath from Firebase Storage: $e");
      }
    }
  }

  // Helper method to find first element or return null
  T? firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
    for (T item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  double getOverallProgress() {
    final activeUploads =
        _uploads.where((model) => !model.isCancelled).toList();
    if (activeUploads.isEmpty) {
      return 1.0; // All uploads are either cancelled or completed
    }
    final totalProgress =
        activeUploads.fold(0.0, (sum, model) => sum + model.uploadProgress);
    return totalProgress / activeUploads.length;
  }

  void _startHugeFileUpload(
      PlatformFile file, String mementoRef, String filePath) {
    // Implement the upload task for huge files
    print("Starting huge file upload for: ${file.name}");
    // Implement the upload task for huge files using firebase storage
  }

  //Write a getter to return the _uploadPaths
  List<String> get uploadPaths => _uploadPaths.values.toList();
  String? get uploadId => _uploadId;

  set setCurrentUploadId (String? id) {
    _currentUploadId = id;
  }

  String? get currentUploadId => _currentUploadId;
}

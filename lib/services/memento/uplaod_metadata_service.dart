import 'dart:convert';

import '../helper/base_rest_service.dart';
import 'upload_metadata_data.dart';


class UploadMetadataService extends RestService {
  UploadMetadataService._privateConstructor() : super();

  static final UploadMetadataService _instance =
      UploadMetadataService._privateConstructor();

  factory UploadMetadataService() {
    return _instance;
  }

  Future<String?> createUploadMetadata(UploadMetadata uploadMetadata) async {
    try {
      // Convert UploadMetadata to JSON
      final Map<String, dynamic> uploadMetadataJson = uploadMetadata.toJson();
      print(
          'Creating upload metadata: ${json.encode(uploadMetadataJson)}'
      );

      // Make a POST request to create the upload metadata
      final response = await post('/uploads', uploadMetadataJson);

      if (response.statusCode == 201) {
        // Successfully created the upload metadata
        print('Upload metadata created successfully.');
        
        // Assuming the response body contains the path of the created Firestore document
        // Example response body: {"documentPath": "path/to/document"}
        final responseBody = json.decode(response.body);
        return responseBody['uploadId'];
      } else {
        // Handle errors, e.g., failed to create the upload metadata
        print(
            'Failed to create upload metadata. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print('Error creating upload metadata: $e');
      return null;
    }
  }
}

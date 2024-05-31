class UploadMetadata {
  List<String>? firebaseStoragePaths;
  AlbumMetadata? albumMetadata;
  String? uploader;
  String? uploadId;
  String mementoId;


  /*
  Status in FS:
    0 - Uploading
    1 - Uploaded
    2 - Compressing
    3 - Published
  */

  /*
  Type in FS:
    1 - Bulk Upload
    2 - Album
    3 - Posts
    
  */

  
  UploadMetadata({
    this.firebaseStoragePaths,
    this.albumMetadata,
    this.uploader,
    this.uploadId,
    required this.mementoId,
 
  });

  factory UploadMetadata.fromJson(Map<String, dynamic> json) => UploadMetadata(
        firebaseStoragePaths: List<String>.from(json['firebaseStoragePaths']),
        albumMetadata: json['albumMetadata'] != null
            ? AlbumMetadata.fromJson(json['albumMetadata'])
            : null,
        uploader: json['uploader'],
        uploadId: json['uploadId'],
        mementoId: json['mementoId'],
      );

  Map<String, dynamic> toJson() => {
        'firebaseStoragePaths': firebaseStoragePaths,
        'albumMetadata': albumMetadata?.toJson(),
        'uploader': uploader,
        'uploadId': uploadId,
        'mementoId': mementoId,
      };
}

class AlbumMetadata {
  String title;
  String? description;
  List<String>? tags;
  String? userId;
  String? uploadTime;

  AlbumMetadata({
    required this.title,
    this.description,
    this.tags,
    this.userId,
    this.uploadTime,
  });

  factory AlbumMetadata.fromJson(Map<String, dynamic> json) => AlbumMetadata(
        title: json['title'],
        description: json['description'],
        tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
        userId: json['userId'],
        uploadTime: json['uploadTime'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'tags': tags,
        'userId': userId,
        'uploadTime': uploadTime,
      };
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'album.dart';

class AlbumService {
  AlbumService._privateConstructor();
  static final AlbumService _instance = AlbumService._privateConstructor();
  factory AlbumService() {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, Album> _albumCache = {};

  Future<List<Album>> fetchAlbums(List<String> uploadIds) async {
    List<Album> albums = [];

    // Always fetch from the database and update the cache
    for (String uploadId in uploadIds) {
      try {
        var doc = await _firestore.collection('uploadMetadata').doc(uploadId).get();
        if (doc.exists) {
          var data = doc.data();
          var title = data?['title'] ?? 'Untitled Album';

          var contentSnapshot = await _firestore.collection('uploadMetadata/$uploadId/content').limit(1).get();
          String thumbnailUrl = '';
          int itemCount = 0;

          if (contentSnapshot.docs.isNotEmpty) {
            thumbnailUrl = contentSnapshot.docs.first.data()['thumbnailURL'] ?? '';
            itemCount = data?["uploadedFiles"].length ?? 0;
          }

          Album album = Album(
            title: title,
            itemCount: itemCount,
            thumbnailUrl: thumbnailUrl,
            docdata: data as Map<String, dynamic>,
            albumContentList: contentSnapshot,
            albumRef: uploadId,
          );

          // Update the cache with the new data
          _albumCache[uploadId] = album;
          albums.add(album);
        }
      } catch (e) {
        print('Error fetching album with uploadId $uploadId: $e');
      }
    }

    return albums;
  }

  // Getter method to get album from cache
  Album? getAlbumFromCache(String uploadId) {
    return _albumCache[uploadId];
  }
}

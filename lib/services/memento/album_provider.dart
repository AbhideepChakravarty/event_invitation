import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'album.dart';

class AlbumProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Album> _albumList = [];
  bool _isFetching = false;
  int _lastFetchedIndex = 0;
  final int _batchSize = 10;
  String? _errorMessage;

  static final AlbumProvider _instance = AlbumProvider._internal();

  factory AlbumProvider() {
    return _instance;
  }

  AlbumProvider._internal();

  List<Album> get albumList => _albumList;
  bool get isFetching => _isFetching;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNextBatch(List<String> uploadIds) async {
    if (_isFetching) return;

    _isFetching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<String> nextUploadIds = uploadIds.skip(_lastFetchedIndex).take(_batchSize).toList();
      if (nextUploadIds.isEmpty) {
        _isFetching = false;
        notifyListeners();
        return;
      }

      List<Album> newAlbums = await _fetchAlbums(nextUploadIds);
      _albumList.addAll(newAlbums);
      _lastFetchedIndex += newAlbums.length;
      _isFetching = false;
      notifyListeners();
    } catch (e) {
      _isFetching = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<List<Album>> _fetchAlbums(List<String> uploadIds) async {
    List<Album> albums = [];
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

          albums.add(Album(
            title: title,
            itemCount: itemCount,
            thumbnailUrl: thumbnailUrl,
            docdata: data as Map<String, dynamic>,
            albumContentList: contentSnapshot,
            albumRef: uploadId,
          ));
        }
      } catch (e) {
        print('Error fetching album with uploadId $uploadId: $e');
      }
    }
    return albums;
  }

  Future<void> refresh(List<String> uploadIds) async {
    _albumList.clear();
    _lastFetchedIndex = 0;
    await fetchNextBatch(uploadIds);
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'media_content.dart'; // Assuming this contains the MediaContent definition

class AlbumMediaProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MediaContent> _mediaList = [];
  bool _isFetching = false;
  String? _errorMessage;
  String? _currentAlbumRef;

  static final AlbumMediaProvider _instance = AlbumMediaProvider._internal();

  factory AlbumMediaProvider() {
    return _instance;
  }

  AlbumMediaProvider._internal();

  List<MediaContent> get mediaList => _mediaList;
  bool get isFetching => _isFetching;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMedia(String albumRef) async {
    if (_isFetching || _currentAlbumRef == albumRef) return;

    _isFetching = true;
    _errorMessage = null;
    _currentAlbumRef = albumRef;
    notifyListeners();

    try {
      var mediaSnapshot = await _firestore.collection('uploadMetadata/$albumRef/content').get();
      List<MediaContent> mediaList = mediaSnapshot.docs.map((doc) {
        var data = doc.data();
        return MediaContent(
          thumbnailUrl: data['thumbnailURL'] ?? '', 
          compressedMediaURL: data['compressedMediaURL'] ?? '', 
          originalMediaURL: data['originalMediaURL'] ?? '', 
          // Add other fields as needed
        );
      }).toList();

      _mediaList = mediaList;
      _isFetching = false;
      notifyListeners();
    } catch (e) {
      _isFetching = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> refresh(String albumRef) async {
    _mediaList.clear();
    _currentAlbumRef = null;
    await fetchMedia(albumRef);
  }

  void clearData() {
    _mediaList.clear();
    _currentAlbumRef = null;
    _errorMessage = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'album.dart';
import 'album_service.dart';

class AlbumProvider with ChangeNotifier {
  final AlbumService _albumService = AlbumService();
  final List<Album> _albumList = [];
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
    if (_isFetching) {
      print("This happened!!!!");
      return;
    }

    _isFetching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<String> nextUploadIds =
          uploadIds.skip(_lastFetchedIndex).take(_batchSize).toList();
      if (nextUploadIds.isEmpty) {
        _isFetching = false;
        notifyListeners();
        return;
      }

      List<Album> newAlbums = await _albumService.fetchAlbums(nextUploadIds);
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

  Future<void> refresh(List<String> uploadIds) async {
    _albumList.clear();
    _lastFetchedIndex = 0;
    await fetchNextBatch(uploadIds);
  }
}

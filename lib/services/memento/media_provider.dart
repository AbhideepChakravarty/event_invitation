import 'package:flutter/material.dart';
import '../../../services/memento/media_content.dart';
import 'memnto_service.dart';

class MediaProvider with ChangeNotifier {
  final MementoService _mediaService = MementoService();
  List<MediaContent> _contentList = [];
  bool _isLoading = false;
  late PaginationHandler _paginationHandler;

  List<MediaContent> get contentList => _contentList;
  PaginationHandler get paginationHandler => _paginationHandler;
  bool get isLoading => _isLoading;

  MediaProvider._privateConstructor();

  static final MediaProvider _instance = MediaProvider._privateConstructor();

  factory MediaProvider() {
    return _instance;
  }

  void initialize(List<String> uploadIds) {
    _paginationHandler = PaginationHandler(allUploadIds: uploadIds);
    _fetchNextPage();
  }

  Future<void> _fetchNextPage() async {
    if (_paginationHandler.hasMoreIds() && !_isLoading) {
      _isLoading = true;
      notifyListeners();
      List<String> nextUploadIds = _paginationHandler.getNextUploadIds();
      List<MediaContent> nextPageContent = await _mediaService.fetchContentFromUploadIds(nextUploadIds);
      _contentList.addAll(nextPageContent);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() => _fetchNextPage();
}

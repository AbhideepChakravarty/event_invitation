import 'package:cloud_firestore/cloud_firestore.dart';

import 'media_content.dart';
import 'memento_content.dart';

class MementoService {
  static final firestore = FirebaseFirestore.instance;
  static Future<MementoContent> fetchMementoContent(
      String mementoId, int type) async {
    final contentRef = firestore
        .collection('mementoes')
        .doc(mementoId)
        .collection('content')
        .where('type', isEqualTo: type);

    final querySnapshot = await contentRef.get();

    final uploadIds = querySnapshot.docs
        .map((doc) => doc.get('uploadId') as String)
        .whereType<String>()
        .toList()
        .reversed
        .toList();

    return MementoContent(uploadIds: uploadIds);
  }

  // Fetches a list of media content based on a list of upload IDs
  Future<List<MediaContent>> fetchContent(List<String> uploadIds) async {
    List<MediaContent> contentList = [];
    for (String uploadId in uploadIds) {
      // Add the fetched contents to the list
      List<MediaContent> uploadContents =
          await fetchContentFromUploadId(uploadId);
      contentList.addAll(uploadContents);
    }
    return contentList;
  }

  // Fetches media content from a specific upload ID
  Future<List<MediaContent>> fetchContentFromUploadId(String uploadId) async {
    final contentRef = firestore
        .collection('uploadMetadata')
        .doc(uploadId)
        .collection('content');

    final querySnapshot = await contentRef.get();
    return querySnapshot.docs
        .map((doc) => MediaContent.fromFirestore(doc))
        .toList();
  }

  Future<List<MediaContent>> fetchContentFromUploadIds(
      List<String> uploadIds) async {
    List<MediaContent> content = [];
    for (var element in uploadIds) {
      content.addAll(await fetchContentFromUploadId(element));
    }

    return content;
  }
}

/*
class PaginationHandler {
  final int batchSize;
  int lastFetchedIndex = -1;
  final List<String> allUploadIds;

  PaginationHandler({required this.allUploadIds, this.batchSize = 10});

  bool hasMoreIds() {
   //print("More uploadIds? " + (lastFetchedIndex + 1 < allUploadIds.length).toString());
    return lastFetchedIndex + 1 < allUploadIds.length;
  }

  List<String> getNextUploadIds() {
    if (!hasMoreIds()) {
      return [];
    }

    int startIndex = lastFetchedIndex + 1;
    int endIndex = startIndex + batchSize;
    if (endIndex > allUploadIds.length) {
      endIndex = allUploadIds.length;
    }

    lastFetchedIndex = endIndex - 1;

    return allUploadIds.sublist(startIndex, endIndex);
  }
}
*/

class PaginationHandler {
  final List<String> allUploadIds;
  int lastFetchedIndex = -1;
  final int batchSize = 10;

  PaginationHandler({required this.allUploadIds});

  bool hasMoreIds() {
    return lastFetchedIndex < allUploadIds.length - 1;
  }

  List<String> getNextUploadIds() {
    if (!hasMoreIds()) return [];
    int start = lastFetchedIndex + 1;
    int end = start + batchSize <= allUploadIds.length
        ? start + batchSize
        : allUploadIds.length;
    lastFetchedIndex = end - 1;
    return allUploadIds.sublist(start, end);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String title;
  final int itemCount;
  final String thumbnailUrl;
  final Map<String, dynamic> docdata;
  final QuerySnapshot<Map<String, dynamic>> albumContentList;
  final String albumRef;

  Album({
    required this.title,
    required this.itemCount,
    required this.thumbnailUrl,
    required this.docdata,
    required this.albumRef,
    required this.albumContentList,
  });
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'page_data.dart';

class PageService {
  Future<PageData> fetchPageData(String pageRef, String languageCode) async {
    final pageDoc =
        await FirebaseFirestore.instance.collection('pages').doc(pageRef).get();

    if (!pageDoc.exists) {
      throw Exception('Page not found');
    }

    final headerImage = pageDoc['header'];
    final textBlockRef = "${pageDoc['textBlock']}-$languageCode";

    final textBlockDoc = await FirebaseFirestore.instance
        .collection('textBlocks')
        .doc(textBlockRef)
        .get();

    if (!textBlockDoc.exists) {
      throw Exception('Text block not found');
    }

    final title = textBlockDoc['title'];

    final contentList = await _fetchContentList(pageDoc, languageCode);

    return PageData(
      pageRef: pageRef,
      title: title,
      headerImage: headerImage,
      contentList: contentList,
    );
  }

  Future<List<PageContent>> _fetchContentList(
      DocumentSnapshot pageDoc, String languageCode) async {
    final contentList = <PageContent>[];

    final contentCollection =
        pageDoc.reference.collection('content').orderBy("seq");
    final contentDocs = await contentCollection.get();

    for (final contentDoc in contentDocs.docs) {
      final contentType = contentDoc['type'];

      if (contentType == 'text') {
        final textBlockRef = "${contentDoc['textBlock']}-$languageCode";
        final textBlockDoc = await FirebaseFirestore.instance
            .collection('textBlocks')
            .doc(textBlockRef)
            .get();

        if (!textBlockDoc.exists) {
          throw Exception('Text block not found');
        }

        final text = textBlockDoc['text'];
        contentList.add(TextContent(text: text));
      } else if (contentType == 'image') {
        final imageUrl = contentDoc['url'];
        contentList.add(ImageContent(image: Uri.parse(imageUrl)));
      } else if (contentType == 'imageCarousel') {
        final imageUrls = List<String>.from(contentDoc['images']);
        final images = imageUrls.map((url) => Uri.parse(url)).toList();
        contentList.add(ImageCarouselContent(imageList: images));
      } else if (contentType == 'audio') {
        final audioUrl = contentDoc['url'];
        contentList.add(AudioContent(audio: Uri.parse(audioUrl)));
      }
      // Add more conditions for other content types
    }

    return contentList;
  }
}

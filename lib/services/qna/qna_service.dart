import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/language_provider.dart';

import 'qna_data.dart'; // Import the necessary dependencies

class QnAService {
  Future<QnAData> fetchData(String pageRef, BuildContext context) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false)
        .locale
        .languageCode;
    print("Fetching QnA data in language code: " + lang);

    try {
      final qnasCollection = FirebaseFirestore.instance.collection('qnas');
      final qnaDoc = await qnasCollection.doc(pageRef).get();

      final textBlock = qnaDoc['textBlock'] as String;
      final textBlockRef = '$textBlock-$lang';
      print("Text Block Ref: " + textBlockRef.toString());
      final textBlockDoc = await FirebaseFirestore.instance
          .collection('textBlocks')
          .doc(textBlockRef)
          .get();
      print("Text Block with id exists: " + textBlockDoc.exists.toString());
      final title = textBlockDoc['title'] as String;
      print("Found title as " + title.toString());
      final qnas = textBlockDoc.reference.collection('qnas').orderBy('seq');
      final qnaList = await qnas.get();
      print("QnA count is " + qnaList.size.toString());
      List<QnAItem> items = [];
      for (final qnaDoc in qnaList.docs) {
        final question = qnaDoc['q'] as String;
        final answer = qnaDoc['a'] as String;
        items.add(QnAItem(question: question, answer: answer));
      }

      return QnAData(qnaRef: pageRef, title: title, items: items);
    } catch (e) {
      print('Error fetching QnA data: $e');
      throw Exception('Failed to fetch QnA data');
    }
  }
}

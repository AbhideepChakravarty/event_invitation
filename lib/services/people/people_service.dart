import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the required package
import '../helper/language_provider.dart';
import 'people_data.dart'; // Import the PeopleData and related classes

class PeopleService {
  Future<PeopleData> fetchData(String peopleRef, BuildContext context) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false)
        .locale
        .languageCode;

    try {
      //print("Fetching people data for $peopleRef");
      final peopleDoc = await FirebaseFirestore.instance
          .collection('people')
          .doc(peopleRef)
          .get();

      final textBlock = peopleDoc['textBlock'];

      final textBlockRef = '$textBlock-$lang';
      final textBlockDoc = await FirebaseFirestore.instance
          .collection('textBlocks')
          .doc(textBlockRef)
          .get();

      final title = textBlockDoc['title'];
      final description = textBlockDoc['desc'];
      //print("Worked on people data for $peopleRef upto entries");
      final entries = <PeopleEntry>[];
      final entriesSnapshot =
          await peopleDoc.reference.collection('entries').orderBy('seq').get();
      //print("objects fetched: ${entriesSnapshot.docs.length}");
      for (var entryDoc in entriesSnapshot.docs) {
        final entryImage = entryDoc['image'];
        final int entryImageAlign = entryDoc['imageAlign'];
        final entryTextBlock = entryDoc['textBlock'];

        final entryTextBlockRef = '$entryTextBlock-$lang';
        final entryTextBlockDoc = await FirebaseFirestore.instance
            .collection('textBlocks')
            .doc(entryTextBlockRef)
            .get();

        final entryName = entryTextBlockDoc['name'];
        final entryRelation = entryTextBlockDoc['relation'];
        final entryDesc = entryTextBlockDoc['desc'];
        final ImageAlignment entryImageAlignment =
            ImageAlignment.values[entryImageAlign];
        var visibility = true;
        if (entryDoc.data().containsKey("visibility") &&
            entryDoc['visibility'] != null) {
          visibility = entryDoc['visibility'];
          //print("For entry $entryName, visibility is $visibility");
        }

        entries.add(PeopleEntry(
          name: entryName,
          image: entryImage,
          relation: entryRelation,
          description: entryDesc,
          imageAlignment: entryImageAlignment,
          visbility: visibility,
        ));
      }

      return PeopleData(
        title: title,
        description: description,
        entries: entries,
      );
    } catch (e) {
      //print('Error fetching people data: $e');
      throw Exception('Failed to fetch people data');
    }
  }
}

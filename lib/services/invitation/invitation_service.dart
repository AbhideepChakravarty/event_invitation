import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helper/language_provider.dart';
import 'invitation_data.dart';
import 'invitation_tile.dart';

class InvitationService {
  final CollectionReference invitationsCollection =
      FirebaseFirestore.instance.collection('invitations');

  final CollectionReference textBlockCollection =
      FirebaseFirestore.instance.collection('textBlocks');

  Future<InvitationData> fetchData(
      String invitationCode, BuildContext context) async {
    print("Fetching invitation with code as " + invitationCode);

    final invitationQuery = await invitationsCollection
        .where('invitationCode', isEqualTo: invitationCode)
        .get();

    if (invitationQuery.size == 0) {
      throw Exception("Invitation not found");
    }

    final documentSnapshot = invitationQuery.docs.first;

    final tilesQuerySnapshot = await invitationsCollection
        .doc(documentSnapshot.id)
        .collection('tiles')
        .orderBy("seq")
        .get();

    List<InvitationTileData> tiles = [];

    for (QueryDocumentSnapshot tileSnapshot in tilesQuerySnapshot.docs) {
      final textBlock = tileSnapshot['textBlock'];
      final tileData = await _getTileText(textBlock, tileSnapshot, context);
      if (tileData != null) {
        tiles.add(tileData);
      }
    }

    InvitationData invitationData = InvitationData(
      primaryText: documentSnapshot['primaryText'],
      secondaryText: documentSnapshot['secondaryText'],
      invitationCode: documentSnapshot['invitationCode'],
      invitationImage: documentSnapshot['invitationImage'],
      invitationDetailsImg: documentSnapshot['invitationDetailsImg'],
      tiles: tiles,
    );

    return invitationData;
  }

  Future<InvitationTileData?> _getTileText(String textBlock,
      QueryDocumentSnapshot tileSnapshot, BuildContext context) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false)
        .locale
        .languageCode;
    InvitationTileData? tileData;
    try {
      print("Working with " + textBlock + "-" + lang);
      await textBlockCollection
          .doc("$textBlock-$lang")
          .get()
          .then((textBlockDoc) {
        if (textBlockDoc.exists) {
          String title = textBlockDoc['title'];
          Uri imageUri = Uri.parse(tileSnapshot['tileImage']);
          Map<String, dynamic> textBlockData =
              textBlockDoc.data() as Map<String, dynamic>;
          //print the textBlockData map here
          print(textBlockData);

          String? footer = textBlockData.containsKey('footer')
              ? textBlockDoc['footer'] // Use "footer" if present
              : null; // Check if "footer" is present

          tileData = InvitationTileData(
            title: title,
            image: imageUri,
            footer: footer, // Assign "footer" value if present, otherwise null
            // Add more fields as needed
          );
        } else {
          print("TextBlock document not found.");
        }
      });
    } catch (e) {
      print(
          "Error fetching textBlock document: $textBlock-$lang ${e.toString()}");
    }

    return tileData;
  }
}

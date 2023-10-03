import 'package:event_invitation/services/invitation/invitation_notifier.dart';
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

    final invitationDoc = await invitationsCollection.doc(invitationCode).get();

    if (!invitationDoc.exists) {
      throw Exception("Invitation not found");
    }

    //final documentSnapshot = invitationDoc.data() as Map<String, dynamic>;

    InvitationData invitationData = InvitationData(
      primaryText: invitationDoc['primaryText'],
      secondaryText: invitationDoc['secondaryText'],
      invitationCode: invitationDoc['invitationCode'],
      invitationImage: invitationDoc['invitationImage'],
      invitationDetailsImg: invitationDoc['invitationDetailsImg'],
      dbId: invitationDoc.id,
    );
    Provider.of<InvitationProvider>(context, listen: false)
        .setInvitation(invitationData);
    return invitationData;
  }

  Future<List<InvitationTileData>> getInvitationTileData(
      String invitationId, String lang) async {
    final tilesQuerySnapshot = await invitationsCollection
        .doc(invitationId)
        .collection('tiles')
        .orderBy("seq")
        .get();

    List<InvitationTileData> tiles = [];

    for (QueryDocumentSnapshot tileSnapshot in tilesQuerySnapshot.docs) {
      final textBlock = tileSnapshot['textBlock'];
      final tileData = await _getTileText(textBlock, tileSnapshot, lang);
      if (tileData != null) {
        tiles.add(tileData);
      }
    }
    return tiles;
  }

  Future<InvitationTileData?> _getTileText(
      String textBlock, QueryDocumentSnapshot tileSnapshot, String lang) async {
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

          // Check if "type" key exists in tileSnapshot
          String? type = tileSnapshot['type'];

          // Check if "ref" key exists in tileSnapshot
          String? ref = tileSnapshot['ref'];

          tileData = InvitationTileData(
            title: title,
            image: imageUri,
            footer: footer, // Assign "footer" value if present, otherwise null
            // Add more fields as needed
            type: type ?? "",
            ref: ref ?? "",
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

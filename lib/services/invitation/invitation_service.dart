import 'package:event_invitation/services/invitation/invitation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helper/language_provider.dart';
import 'invitation_data.dart';
import 'invitation_tile.dart';

class InvitationService {
  // Private constructor
  InvitationService._();

  // Static instance variable
  static final InvitationService _instance = InvitationService._();

  // Public factory method to access the instance
  factory InvitationService() {
    return _instance;
  }
  final CollectionReference invitationsCollection =
      FirebaseFirestore.instance.collection('invitations');

  final CollectionReference textBlockCollection =
      FirebaseFirestore.instance.collection('textBlocks');

  final Map<String, InvitationData> _retrievedInvitations = {};
  final Map<String, int> _fetchCounts = {};

  Future<InvitationData> fetchData(String invitationCode) async {
    print("Fetching invitation with code as " + invitationCode);
    return _fetchAndCacheData(invitationCode);
    /*if (_fetchCounts.containsKey(invitationCode)) {
      int counter = _fetchCounts[invitationCode] ?? 0;
      if (counter >= 5) {
        return _fetchAndCacheData(invitationCode);
      } else if (_retrievedInvitations.containsKey(invitationCode)) {
        return _retrievedInvitations[invitationCode]!;
      } else {
        _fetchCounts[invitationCode] = ++counter;
        return _fetchAndCacheData(invitationCode);
      }
    } else {
      return _fetchAndCacheData(invitationCode);
    }*/
  }

  Future<InvitationData> _fetchAndCacheData(String invitationCode) async {
    final invitationDoc = await invitationsCollection.doc(invitationCode).get();

    if (!invitationDoc.exists) {
      print("Invitation not found");
      throw Exception("Invitation not found");
    }
    print("Found invitation");
    InvitationData invitationData = InvitationData(
      primaryText: invitationDoc['primaryText'],
      secondaryText: invitationDoc['secondaryText'],
      invitationCode: invitationDoc['invitationCode'],
      invitationImage: invitationDoc['invitationImage'],
      invitationDetailsImg: invitationDoc['invitationDetailsImg'],
      dbId: invitationDoc.id,
    );
    invitationData.videoUrl = invitationDoc['videoUrl'];
    invitationData.thumbnailURL = invitationDoc['thumbnailURL'];
    
    if (invitationDoc['primaryTextColor'] != null) {
      invitationData.primaryTextColor = invitationDoc['primaryTextColor'];
    }
    _retrievedInvitations[invitationCode] = invitationData;
    _fetchCounts[invitationCode] = 1; // Reset the counter to 0
    print("Invitation data fetched successfully");
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

    for (var tileSnapshot in tilesQuerySnapshot.docs) {
      // If the invitationDoc contains a "visibility" key, then fetch its value

      final textBlock = tileSnapshot['textBlock'];
      final InvitationTileData? tileData =
          await _getTileText(textBlock, tileSnapshot, lang);
      if (tileSnapshot.data().containsKey("visibility") && tileSnapshot['visibility'] != null) {
        bool visibility = tileSnapshot['visibility'];
        tileData!.visibility = visibility;
        print("For invitation $tileData.title, visibility is $visibility");
      }
      if (tileData != null && tileData.visibility) {
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

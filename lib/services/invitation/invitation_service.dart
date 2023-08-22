import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'invitation_data.dart';
import 'invitation_notifier.dart';

class InvitationService {
  final CollectionReference invitationsCollection =
      FirebaseFirestore.instance.collection('invitations');

  Future<InvitationData> fetchData(String invitationCode) async {
    print("Fetching invitation with code as " + invitationCode);
    final querySnapshot = await invitationsCollection
        .where('invitationCode', isEqualTo: invitationCode)
        .get();

    final documentSnapshot = querySnapshot.docs.first;

    InvitationData invitationData = InvitationData(
      primaryText: documentSnapshot['primaryText'],
      secondaryText: documentSnapshot['secondaryText'],
      invitationCode: documentSnapshot['invitationCode'],
      invitationImage: documentSnapshot['invitationImage'],
      invitationDetailsImg: documentSnapshot['invitationDetailsImg'],
    );

    return invitationData;
  }
}

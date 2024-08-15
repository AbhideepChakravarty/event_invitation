import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_invitation_data.dart';

class UserInvitationService {
  final CollectionReference userInvitationCollection =
      FirebaseFirestore.instance.collection('userInvitations');

  Future<List<UserInvitationData>> fetchDataForGuest(String phoneNumber) async {
    //print("Received phone number as $phoneNumber");
    final querySnapshot = await userInvitationCollection
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    final List<UserInvitationData> userInvitations = [];

    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      userInvitations.add(UserInvitationData(
        active: data['active'] ?? false,
        eventImage: data['eventImage'] ?? '',
        eventType: data['eventType'] ?? '',
        invitationCode: data['invitationCode'] ?? '',
        userInvitationType: data['userInvitationType'] ?? 0,
        phoneNumber: data['phoneNumber'] ?? '',
        primaryText: data['primaryText'] ?? '',
      ));
    }

    return userInvitations;
  }
}

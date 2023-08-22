import 'package:flutter/material.dart';

import 'invitation_data.dart';

class InvitationProvider extends ChangeNotifier {
  InvitationData? _invitationData;

  InvitationData? get invitationData => _invitationData;

  void setInvitation(InvitationData invitationData) {
    _invitationData = invitationData;
  }
}

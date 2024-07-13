
class UserInvitationData {
  final bool active;
  final String eventImage;
  final String eventType;
  final String invitationCode;
  final int userInvitationType;
  final String phoneNumber;
  final String primaryText;

  UserInvitationData({
    required this.active,
    required this.eventImage,
    required this.eventType,
    required this.invitationCode,
    required this.userInvitationType,
    required this.phoneNumber,
    required this.primaryText,
  });

  factory UserInvitationData.fromFirestore(Map<String, dynamic> data) {
    return UserInvitationData(
      active: data['active'] ?? false,
      eventImage: data['eventImage'] ?? '',
      eventType: data['eventType'] ?? '',
      invitationCode: data['invitationCode'] ?? '',
      userInvitationType: data['userInvitationType'] ?? 0,
      phoneNumber: data['phoneNumber'] ?? '',
      primaryText: data['primaryText'] ?? '',
    );
  }
}

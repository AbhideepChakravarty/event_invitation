import 'invitation_tile.dart';

class InvitationData {
  late String? dbId;
  final String primaryText;
  final String secondaryText;
  final String invitationCode;
  final String invitationImage;
  final String invitationDetailsImg;
  late List<InvitationTileData>? tiles;

  InvitationData(
      {required this.primaryText,
      required this.secondaryText,
      required this.invitationCode,
      required this.invitationImage,
      required this.invitationDetailsImg,
      this.tiles,
      this.dbId});
}

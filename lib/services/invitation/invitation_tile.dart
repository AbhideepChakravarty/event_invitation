class InvitationTileData {
  final String title;
  final String? footer;
  final Uri image;
  final String type;
  final String ref;

  InvitationTileData({
    required this.title,
    this.footer,
    required this.image,
    required this.type,
    required this.ref,
  });
}

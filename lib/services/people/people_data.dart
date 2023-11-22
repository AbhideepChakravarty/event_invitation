class PeopleData {
  final String title;
  final String description;
  final List<PeopleEntry> entries;

  PeopleData({
    required this.title,
    required this.description,
    required this.entries,
  });
}

class PeopleEntry {
  final String name;
  final String image;
  final String relation;
  final String description;
  final ImageAlignment imageAlignment;
  bool visbility = true;

  PeopleEntry({
    required this.name,
    required this.image,
    required this.relation,
    required this.description,
    required this.imageAlignment,
    this.visbility = true,
  });

  get isVisible => visbility;
}

enum ImageAlignment {
  left,
  center,
  right,
}

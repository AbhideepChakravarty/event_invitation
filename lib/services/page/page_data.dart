class PageData {
  final String pageRef;
  final String title;
  final String headerImage;
  List<PageContent> contentList;

  PageData(
      {required this.pageRef,
      required this.title,
      required this.headerImage,
      required this.contentList});
}

class PageContent {
  final String type;

  PageContent({required this.type});
}

class TextContent extends PageContent {
  final String text;
  TextContent({required this.text}) : super(type: "text");
}

class ImageContent extends PageContent {
  final Uri image;
  ImageContent({required this.image}) : super(type: "image");
}

class ImageCarouselContent extends PageContent {
  final List<Uri> imageList;
  ImageCarouselContent({required this.imageList})
      : super(type: "imageCarousel");
}

class AudioContent extends PageContent {
  final Uri audio;
  AudioContent({required this.audio}) : super(type: "audio");
}

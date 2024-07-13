import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../services/memento/media_content.dart';
import '../../../../services/memento/media_provider.dart';
import '../../../../services/memento/memento_content.dart';
import 'fullscreen_view.dart';

class MediaListWidget extends StatefulWidget {
  final MementoContent mementoContent;
  final ScrollController scrollController;

  const MediaListWidget(
      {Key? key, required this.mementoContent, required this.scrollController})
      : super(key: key);

  @override
  _MediaListWidgetState createState() => _MediaListWidgetState();
}

class _MediaListWidgetState extends State<MediaListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      mediaProvider.initialize(widget.mementoContent.uploadIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                !mediaProvider.isLoading) {
              mediaProvider.fetchNextPage();
            }
            return false;
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: mediaProvider.contentList.length,
            itemBuilder: (context, index) {
              MediaContent mediaContent = mediaProvider.contentList[index];
              return GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => FullScreenMediaPage(initialPage: index),
                )),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: mediaContent.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/memento/album_media_provider.dart'; // Your existing provider
import '../../../../services/memento/media_content.dart';
import 'fullscreen_album_media_page.dart'; // New page for full-screen view

class AlbumDetailPage extends StatefulWidget {
  final String albumRef;

  const AlbumDetailPage({Key? key, required this.albumRef}) : super(key: key);

  @override
  _AlbumDetailPageState createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final albumMediaProvider =
          Provider.of<AlbumMediaProvider>(context, listen: false);
      albumMediaProvider.fetchMedia(widget.albumRef);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album Details')),
      body: Consumer<AlbumMediaProvider>(
        builder: (context, albumMediaProvider, child) {
          if (albumMediaProvider.errorMessage != null) {
            return Center(
                child: Text('Error: ${albumMediaProvider.errorMessage}'));
          }

          if (albumMediaProvider.isFetching &&
              albumMediaProvider.mediaList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !albumMediaProvider.isFetching) {
                albumMediaProvider.fetchMedia(widget.albumRef);
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
              itemCount: albumMediaProvider.mediaList.length,
              itemBuilder: (context, index) {
                MediaContent mediaContent = albumMediaProvider.mediaList[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => FullScreenAlbumMediaPage(
                        initialPage: index, albumRef: widget.albumRef),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/memento/album_media_provider.dart';
import '../../../services/memento/media_content.dart';


class AlbumMediaWidget extends StatefulWidget {
  final String albumRef;

  const AlbumMediaWidget({Key? key, required this.albumRef}) : super(key: key);

  @override
  _AlbumMediaWidgetState createState() => _AlbumMediaWidgetState();
}

class _AlbumMediaWidgetState extends State<AlbumMediaWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final albumMediaProvider = Provider.of<AlbumMediaProvider>(context, listen: false);
      albumMediaProvider.fetchMedia(widget.albumRef);
    });
  }

  @override
  void dispose() {
    final albumMediaProvider = Provider.of<AlbumMediaProvider>(context, listen: false);
    albumMediaProvider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Album Media')),
      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<AlbumMediaProvider>(context, listen: false).refresh(widget.albumRef);
        },
        child: Consumer<AlbumMediaProvider>(
          builder: (context, albumMediaProvider, child) {
            if (albumMediaProvider.errorMessage != null) {
              return Center(child: Text('Error: ${albumMediaProvider.errorMessage}'));
            }

            if (albumMediaProvider.isFetching && albumMediaProvider.mediaList.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: albumMediaProvider.mediaList.length,
              itemBuilder: (context, index) {
                MediaContent mediaContent = albumMediaProvider.mediaList[index];
                return MediaTile(mediaContent: mediaContent);
              },
            );
          },
        ),
      ),
    );
  }
}

class MediaTile extends StatelessWidget {
  final MediaContent mediaContent;

  const MediaTile({Key? key, required this.mediaContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(mediaContent.thumbnailUrl, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}

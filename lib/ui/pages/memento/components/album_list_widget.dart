import 'package:event_invitation/services/memento/memento_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/memento/album_provider.dart';
import 'album_tile.dart';

class AlbumListWidget extends StatefulWidget {
  final MementoContent mementoContent;
  final ScrollController scrollController;

  const AlbumListWidget(
      {Key? key, required this.mementoContent, required this.scrollController})
      : super(key: key);

  @override
  _AlbumListWidgetState createState() => _AlbumListWidgetState();
}

class _AlbumListWidgetState extends State<AlbumListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
      if (albumProvider.albumList.isEmpty) {
        albumProvider.fetchNextBatch(widget.mementoContent.uploadIds);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
      if (!albumProvider.isFetching) {
        albumProvider.fetchNextBatch(widget.mementoContent.uploadIds);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Provider.of<AlbumProvider>(context, listen: false)
            .refresh(widget.mementoContent.uploadIds);
      },
      child: Consumer<AlbumProvider>(
        builder: (context, albumProvider, child) {
          if (albumProvider.errorMessage != null) {
            return Center(child: Text('Error: ${albumProvider.errorMessage}'));
          }

          return Stack(
            children: [
              GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: albumProvider.albumList.length,
                itemBuilder: (context, index) {
                  return AlbumTile(album: albumProvider.albumList[index]);
                },
              ),
              if (albumProvider.isFetching)
                const Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

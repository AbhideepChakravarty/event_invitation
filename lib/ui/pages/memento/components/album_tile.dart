import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../navigation/nav_data.dart';
import '../../../../navigation/router_deligate.dart';
import '../../../../services/memento/album.dart';

class AlbumTile extends StatelessWidget {
  final Album album;

  const AlbumTile({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Album code ${album.albumRef}");

        var onTap = Provider.of<EventAppRouterDelegate>(context, listen: false)
            .routeTrigger;
        onTap(EventAppNavigatorData.albumDetails(album.albumRef, {}));
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(album.thumbnailUrl, fit: BoxFit.cover),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                album.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('${album.itemCount} items',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../navigation/nav_data.dart';
import '../../../../navigation/router_deligate.dart';
import '../../../../services/invitation/invitation_tile.dart';
import '../../../helpers/theme/font_provider.dart';

class InvitationTile extends StatelessWidget {
  final InvitationTileData tile;
  const InvitationTile({super.key, required this.tile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          var onTap =
              Provider.of<EventAppRouterDelegate>(context, listen: false)
                  .routeTrigger;
          var data = _getEventAppNavigatorDataByTileType(tile);
          onTap(data);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white // Rounded corners
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                        tile.image.toString()), // Use the image URI
                    fit: BoxFit.cover,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tile.title,
                      style: Provider.of<FontProvider>(context)
                          .secondaryTextFont
                          .copyWith(fontSize: 24, color: Colors.black)),
                ),
              ),
              if (tile.footer != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tile.footer!,
                      style: Provider.of<FontProvider>(context)
                          .descriptionTextFont
                          .copyWith(fontSize: 16, color: Colors.black)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _getEventAppNavigatorDataByTileType(InvitationTileData tile) {
    EventAppNavigatorData data;
    switch (tile.type) {
      case "page":
        data = EventAppNavigatorData.page(tile.ref, {});
        break;
      case "mp3":
        data = EventAppNavigatorData.page(tile.ref, {});
        break;
      case "image":
        data = EventAppNavigatorData.page(tile.ref, {});
        break;
      case "people":
        data = EventAppNavigatorData.people(tile.ref);
        break;
      case "qna":
        data = EventAppNavigatorData.qna(tile.ref);
        break;
      default:
        data = EventAppNavigatorData.unknown();
    }
    return data;
  }
}

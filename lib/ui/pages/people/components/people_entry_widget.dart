import 'package:flutter/material.dart';

import '../../../../services/people/people_data.dart';

class PeopleEntryWidget extends StatelessWidget {
  final PeopleEntry entry;

  const PeopleEntryWidget({required this.entry, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Entry data: " + entry.imageAlignment.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.imageAlignment == ImageAlignment.center)
              _buildCenterImageWidget(context),
            Row(
              children: [
                if (entry.imageAlignment == ImageAlignment.left)
                  _buildImageWidget(context),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        entry.imageAlignment == ImageAlignment.left
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: entry.imageAlignment == ImageAlignment.center
                            ? Alignment.center
                            : entry.imageAlignment == ImageAlignment.left
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                        child: Text(
                          entry.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: entry.imageAlignment == ImageAlignment.center
                            ? Alignment.center
                            : entry.imageAlignment == ImageAlignment.left
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                        child: Text(
                          entry.relation,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (entry.imageAlignment == ImageAlignment.right)
                  SizedBox(width: 12),
                if (entry.imageAlignment == ImageAlignment.right)
                  _buildImageWidget(context),
              ],
            ),
            SizedBox(height: 12),
            Text(
              entry.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor, // Use your theme color here
          width: 2, // You can adjust the border width
        ),
        image: DecorationImage(
          image: NetworkImage(entry.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCenterImageWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor, // Use your theme color here
          width: 2, // You can adjust the border width
        ),
        image: DecorationImage(
          image: NetworkImage(entry.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

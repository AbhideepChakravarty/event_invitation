import 'package:event_invitation/services/invitation/invitation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/invitation/invitation_data.dart';
import '../../../services/invitation/invitation_service.dart';
import 'components/inviation_video_tile.dart';

class InvitationDetailsPage extends StatefulWidget {
  final String invitationCode;
  const InvitationDetailsPage({Key? key, required this.invitationCode})
      : super(key: key);
  @override
  _InvitationDetailsPageState createState() => _InvitationDetailsPageState();
}

class _InvitationDetailsPageState extends State<InvitationDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  final InvitationService _invitationService = InvitationService();
  double _scrollOffset = 0.0;
  late InvitationData _invitationData;

  @override
  void initState() {
    super.initState();
    /*_scrollController.addListener(() {
      setState(() {
        print("Scroll offset = " + _scrollController.offset.toString());
        _scrollOffset = _scrollController.offset;
      });
    });*/
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InvitationData>(
      future: _invitationService.fetchData(widget.invitationCode, context),
      builder: (BuildContext context, AsyncSnapshot<InvitationData> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is being fetched
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          ); // Show a loading indicator or placeholder
        } else if (snapshot.hasError) {
          // If there's an error
          return const Center(
            child: Text('Error loading data.'),
          );
        } else if (!snapshot.hasData) {
          // If data is not available
          return const Center(
            child: Text('No data available.'),
          );
        } else {
          // Data is available, build the scaffold
          _invitationData = snapshot.data!;

          return Scaffold(
            body: Stack(
              children: [
                _buildBackgroundImage(),
                _buildContent(),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildBackgroundImage() {
    double opacity = (_scrollOffset / 100).clamp(0.0, 1.0);

    return Container(
      child: Stack(
        children: [
          Opacity(
            opacity: 1 - opacity,
            child: Image.network(
              _invitationData.invitationDetailsImg,
              width: double.infinity,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Opacity(
            opacity: opacity,
            child: Container(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.6), // Space for background image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                _invitationData.primaryText,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Add more content here
          const InviationVideoTile(),
          const SizedBox(height: 20),
          ..._buildInvitationTiles(context),
        ],
      ),
    );
  }

  List<Widget> _buildInvitationTiles(BuildContext context) {
    List<Widget> tiles = [];
    for (var tile in _invitationData.tiles) {
      tiles.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
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
                    child: Text(
                      tile.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (tile.footer != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      tile.footer!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      tiles.add(const SizedBox(height: 20));
    }
    return tiles;
  }
}

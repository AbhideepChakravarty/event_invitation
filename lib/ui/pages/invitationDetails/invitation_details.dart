import 'package:event_invitation/services/helper/language_provider.dart';
import 'package:event_invitation/services/invitation/invitation_notifier.dart';
import 'package:event_invitation/ui/helpers/theme/font_provider.dart';
import 'package:event_invitation/ui/pages/invitationDetails/components/invitation_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/invitation/invitation_data.dart';
import '../../../services/invitation/invitation_service.dart';
import '../../../services/invitation/invitation_tile.dart';
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
      future: _invitationService.fetchData(widget.invitationCode),
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
          Provider.of<InvitationProvider>(context, listen: false)
              .setInvitation(_invitationData);
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
    double primaryTextFontSize =
        MediaQuery.of(context).size.height > 800 ? 60 : 50;
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
              child: Text(_invitationData.primaryText,
                  style: Provider.of<FontProvider>(context)
                      .primaryTextFont
                      .copyWith(
                        fontSize: primaryTextFontSize,
                        color: Colors.amber[600],
                      )),
            ),
          ),
          // Add more content here
          _invitationData.videoUrl != null
              ? InviationVideoTile(
                  videoUrl: _invitationData.videoUrl ?? '',
                  thumbnailURL: _invitationData.thumbnailURL ?? '')
              : Container(),
          const SizedBox(height: 20),
          _buildInvitationTiles(context),
        ],
      ),
    );
  }

  Widget _buildInvitationTiles(BuildContext context) {
    return FutureBuilder<List<InvitationTileData>>(
      future: _getInvitationTiles(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No invitation tiles available.');
        } else {
          List<Widget> tileList = [];
          for (var tile in snapshot.data!) {
            tileList.add(InvitationTile(tile: tile));
            tileList.add(const SizedBox(height: 20));
          }

          print("Size of tiles = " + tileList.length.toString());
          return Column(children: tileList);
        }
      },
    );
  }

  Future<List<InvitationTileData>> _getInvitationTiles(
      BuildContext context) async {
    String lang = Provider.of<LanguageProvider>(context).locale.languageCode;
    List<InvitationTileData> invitationTiles = (await _invitationService
        .getInvitationTileData(_invitationData.dbId!, lang));
    return invitationTiles;
  }

  /*List<Widget> _buildInvitationTiles(BuildContext context) {
    List<Widget> tiles = [];
    String lang = Provider.of<LanguageProvider>(context).locale.languageCode;
    List<InvitationTileData> invitationTiles =
         _invitationService.getInvitationTileData(
            _invitationData.dbId!, lang);
    for (var tile in _invitationData.tiles) {
      tiles.add(InvitationTile(tile: tile));
      tiles.add(const SizedBox(height: 20));
    }
    return tiles;
  }*/
}

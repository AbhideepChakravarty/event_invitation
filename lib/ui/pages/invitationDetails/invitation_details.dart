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
        ],
      ),
    );
  }

  Widget _buildAppBar(String imageUrl) {
    double opacity = _scrollOffset / 100;

    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.5,
      flexibleSpace: Stack(
        children: [
          Opacity(
            opacity: 1 - opacity,
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
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

  Widget _buildSliverList(String primaryText) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              primaryText,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'WeddingStyleFont',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          // Add more content here
        ],
      ),
    );
  }

  Widget _buildScrollableContainer() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
    );
  }

  // ... Other methods
}




/*class _InvitationDetailsPageState extends State<InvitationDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InvitationData? invitationData =
        Provider.of<InvitationProvider>(context).invitationData;
    if (invitationData == null) {
      print("Found invitation data as null");
      //Call InvitationService to fetch data by sending invitationCode

      InvitationService().fetchData(widget.invitationCode).then((value) {
        Provider.of<InvitationProvider>(context, listen: false)
            .setInvitation(value);
        invitationData = value;
      });
    }
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(invitationData!.invitationDetailsImg),
          _buildScrollableContent(invitationData!.primaryText),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
          _buildScrollableContainer(),
        ],
      ),
    );
  }

  Widget _buildScrollableContainer() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 300, // Adjust height as needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
      ),
    );
  }

  /*Widget _buildBackgroundImage(String imageUrl) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Transform.scale(
        scale: 1.0 + _scrollOffset * 0.001, // Adjust scaling factor
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }*/

  Widget _buildBackgroundImage(String imageUrl) {
    double opacity = _scrollOffset /
        100; // Adjust the divisor for desired opacity change rate

    return Container(
      constraints: BoxConstraints.expand(),
      child: Transform.scale(
        scale: 1.0 + _scrollOffset * 0.001,
        child: Stack(
          children: [
            Opacity(
              opacity: 1 - opacity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
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
      ),
    );
  }

  Widget _buildScrollableContent(String primaryText) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Text(
              primaryText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'WeddingStyleFont',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Add more content here
        ],
      ),
    );
  }
}*/

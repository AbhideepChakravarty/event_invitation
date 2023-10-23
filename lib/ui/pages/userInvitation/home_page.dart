import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_invitation/auth/firebase_auth.dart';
import 'package:event_invitation/navigation/nav_data.dart';
import 'package:event_invitation/navigation/router_deligate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/userInvitations/user_invitation_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String phoneNumber = FirebaseAuthHelper().getUser!.phoneNumber!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Center(
              child: Text(
                'Your Invitations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userInvitations')
                  .where('phoneNumber', isEqualTo: phoneNumber)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final invitations = snapshot.data?.docs ?? [];

                if (invitations.isEmpty) {
                  return const Center(child: Text('No invitations available.'));
                }

                return ListView.builder(
                  itemCount: invitations.length,
                  itemBuilder: (context, index) {
                    final invitationData = UserInvitationData.fromFirestore(
                      invitations[index].data() as Map<String, dynamic>,
                    );

                    Widget card = Card(
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Image.network(
                                  invitationData.eventImage,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit
                                      .cover, // Ensure the image covers the entire box
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      10), // Add spacing between the image and text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      invitationData.primaryText,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      invitationData.eventType,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                    if (invitationData.active) {
                      return GestureDetector(
                        onTap: () {
                          print("Tap on " + invitationData.primaryText);
                          var onTap = Provider.of<EventAppRouterDelegate>(
                                  context,
                                  listen: false)
                              .routeTrigger;
                          var data = EventAppNavigatorData.invitationDetails(
                              invitationData.invitationCode);
                          onTap(data);
                        },
                        child: card,
                      );
                    }
                    return _getDisabledCard(card, context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDisabledCard(Widget card, BuildContext context) {
    //create a widget to make the card as child and make it look disabled and grey out
    return Opacity(
      opacity: 0.5,
      child: AbsorbPointer(
        absorbing: true,
        child: card,
      ),
    );
  }
}

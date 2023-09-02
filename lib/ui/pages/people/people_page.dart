import 'package:event_invitation/ui/pages/people/components/people_entry_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/people/people_data.dart';
import '../../../services/people/people_service.dart';

class PeoplePage extends StatelessWidget {
  final String peopleRef;

  const PeoplePage({Key? key, required this.peopleRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final peopleService = PeopleService();

    return FutureBuilder<PeopleData>(
      future: peopleService.fetchData(peopleRef, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }

        final peopleData = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(peopleData.title),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(peopleData.description),
                ),
                ...peopleData.entries
                    .map((entry) => PeopleEntryWidget(entry: entry)),
              ],
            ),
          ),
        );
      },
    );
  }
}

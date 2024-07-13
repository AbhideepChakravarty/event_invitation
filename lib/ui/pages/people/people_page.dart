import 'package:event_invitation/ui/pages/people/components/people_entry_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/people/people_data.dart';
import '../../../services/people/people_service.dart';
import '../../helpers/theme/font_provider.dart';

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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final peopleData = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(peopleData.title,
                style: Provider.of<FontProvider>(context)
                    .secondaryTextFont
                    .copyWith(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: peopleData.description == "" ? Container() : Text(peopleData.description,
                        style: Provider.of<FontProvider>(context)
                            .descriptionTextFont
                            .copyWith(fontSize: 16, color: Colors.black))),
                ...peopleData.entries
                    .map((entry) { 
                      print("Entry: ${entry.name} is ${entry.isVisible}");
                      return entry.isVisible ? PeopleEntryWidget(entry: entry) : Container();
                      }),
              ],
            ),
          ),
        );
      },
    );
  }
}

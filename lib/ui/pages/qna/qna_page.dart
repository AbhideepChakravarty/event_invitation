import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/qna/qna_data.dart';
import '../../../services/qna/qna_service.dart';
import '../../helpers/theme/font_provider.dart';

class QnAPage extends StatelessWidget {
  final String qnaRef;
  final QnAService qnaService = QnAService();

  QnAPage({super.key, required this.qnaRef});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QnAData>(
      future: qnaService.fetchData(qnaRef, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        } else {
          final qnaData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(qnaData.title,
                  style: Provider.of<FontProvider>(context)
                      .secondaryTextFont
                      .copyWith(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
              automaticallyImplyLeading: false,
            ),
            body: ListView.builder(
              itemCount: qnaData.items.length,
              itemBuilder: (context, index) {
                final item = qnaData.items[index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(item.question,
                        style: Provider.of<FontProvider>(context)
                            .descriptionTextFont
                            .copyWith(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8), // Add gap
                        Text(item.answer,
                            style: Provider.of<FontProvider>(context)
                                .descriptionTextFont
                                .copyWith(fontSize: 16, color: Colors.black))
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../../services/qna/qna_data.dart';
import '../../../services/qna/qna_service.dart';

class QnAPage extends StatelessWidget {
  final String qnaRef;
  final QnAService qnaService = QnAService();

  QnAPage({required this.qnaRef});

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
              title: Text(qnaData.title),
              automaticallyImplyLeading: false,
            ),
            body: ListView.builder(
              itemCount: qnaData.items.length,
              itemBuilder: (context, index) {
                final item = qnaData.items[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      item.question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8), // Add gap
                        Text(item.answer),
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

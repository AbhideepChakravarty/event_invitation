class QnAData {
  final String qnaRef;
  final String title;
  final List<QnAItem> items;

  QnAData({required this.qnaRef, required this.title, required this.items});
}

class QnAItem {
  final String question;
  final String answer;

  QnAItem({required this.question, required this.answer});
}

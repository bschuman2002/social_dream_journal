class JournalEntry {
  final int id;
  final int userId;
  final DateTime date;
  bool privacy;
  final int sleepScore;
  final String text;

  JournalEntry(
      {required this.id,
      required this.userId,
      required this.date,
      required this.privacy,
      required this.sleepScore,
      required this.text});

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      userId: json['userID'],
      date: DateTime.parse(json['date']),
      privacy:  json['privacy'] == "true",
      sleepScore: json['sleepScore'],
      text: json['text'],
    );
  }
}

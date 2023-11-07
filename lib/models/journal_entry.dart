class JournalEntry {
  final int id;
  final int userId;
  final DateTime date;
  final bool privacy;
  final int sleepScore;
  final String text;

  JournalEntry(
      {required this.id,
      required this.userId,
      required this.date,
      required this.privacy,
      required this.sleepScore,
      required this.text});
}

abstract class TambahSavingEvent {}

class SubmitSavingEvent extends TambahSavingEvent {
  final int userId;
  final String title;
  final int targetAmount;
  final DateTime deadline;

  SubmitSavingEvent({
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.deadline,
  });
}

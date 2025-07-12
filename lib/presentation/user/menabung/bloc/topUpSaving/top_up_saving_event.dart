abstract class TopUpSavingEvent {}

class SubmitTopUpSaving extends TopUpSavingEvent {
  final int savingId;
  final int userId;
  final int amount;

  SubmitTopUpSaving({
    required this.savingId,
    required this.userId,
    required this.amount,
  });
}

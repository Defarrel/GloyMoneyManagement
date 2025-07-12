abstract class WithdrawSavingEvent {}

class SubmitWithdrawSaving extends WithdrawSavingEvent {
  final int savingId;
  final int userId;
  final int amount;

  SubmitWithdrawSaving({
    required this.savingId,
    required this.userId,
    required this.amount,
  });
}

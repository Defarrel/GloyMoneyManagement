abstract class SavingDetailEvent {}

class LoadSavingDetailEvent extends SavingDetailEvent {
  final int savingId;

  LoadSavingDetailEvent(this.savingId);
}

abstract class RiwayatSavingEvent {}

class LoadRiwayatSaving extends RiwayatSavingEvent {
  final int savingId;
  LoadRiwayatSaving(this.savingId);
}

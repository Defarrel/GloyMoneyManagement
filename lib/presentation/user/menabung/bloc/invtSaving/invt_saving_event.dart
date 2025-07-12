abstract class InvtSavingEvent {}

class LoadUsers extends InvtSavingEvent {}

class SendInvitation extends InvtSavingEvent {
  final int savingId;
  final int receiverId;
  final int senderId;

  SendInvitation({
    required this.savingId,
    required this.receiverId,
    required this.senderId,
  });
}

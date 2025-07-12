part of 'notifikasi_bloc.dart';

sealed class NotifikasiEvent extends Equatable {
  const NotifikasiEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifikasiEvent extends NotifikasiEvent {}

class RespondInvitationEvent extends NotifikasiEvent {
  final int id;
  final String status;

  const RespondInvitationEvent({required this.id, required this.status});

  @override
  List<Object> get props => [id, status];
}

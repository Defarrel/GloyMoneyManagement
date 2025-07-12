part of 'notifikasi_bloc.dart';

sealed class NotifikasiState extends Equatable {
  const NotifikasiState();

  @override
  List<Object> get props => [];
}

class NotifikasiInitial extends NotifikasiState {}

class NotifikasiLoading extends NotifikasiState {}

class NotifikasiLoaded extends NotifikasiState {
  final List<InvtResponseModel> notifications;

  const NotifikasiLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotifikasiError extends NotifikasiState {
  final String message;

  const NotifikasiError(this.message);

  @override
  List<Object> get props => [message];
}

class NotifikasiResponded extends NotifikasiState {
  final String message;

  const NotifikasiResponded(this.message);

  @override
  List<Object> get props => [message];
}

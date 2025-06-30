part of 'tambahpensiun_bloc.dart';

abstract class TambahpensiunState extends Equatable {
  const TambahpensiunState();

  @override
  List<Object> get props => [];
}

class TambahpensiunInitial extends TambahpensiunState {}

class TambahpensiunLoading extends TambahpensiunState {}

class TambahpensiunSuccess extends TambahpensiunState {
  final String message;

  const TambahpensiunSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class TambahpensiunFailure extends TambahpensiunState {
  final String error;

  const TambahpensiunFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class DeadlinePicked extends TambahpensiunState {
  final String deadline;

  const DeadlinePicked(this.deadline);

  @override
  List<Object> get props => [deadline];
}

part of 'topuppensiun_bloc.dart';

abstract class TopupPensiunState extends Equatable {
  const TopupPensiunState();

  @override
  List<Object?> get props => [];
}

class TopupPensiunInitial extends TopupPensiunState {}

class TopupPensiunLoading extends TopupPensiunState {}

class TopupPensiunSuccess extends TopupPensiunState {}

class TopupPensiunFailure extends TopupPensiunState {
  final String message;

  const TopupPensiunFailure(this.message);

  @override
  List<Object?> get props => [message];
}

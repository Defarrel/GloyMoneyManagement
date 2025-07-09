part of 'pensiunscreen_bloc.dart';

abstract class PensiunScreenState extends Equatable {
  const PensiunScreenState();

  @override
  List<Object?> get props => [];
}

class PensiunScreenInitial extends PensiunScreenState {}

class PensiunScreenLoading extends PensiunScreenState {}

class PensiunScreenLoaded extends PensiunScreenState {
  final PensionResponseModel pension;

  const PensiunScreenLoaded(this.pension);

  @override
  List<Object?> get props => [pension];
}

class PensiunScreenError extends PensiunScreenState {
  final String message;

  const PensiunScreenError(this.message);

  @override
  List<Object?> get props => [message];
}

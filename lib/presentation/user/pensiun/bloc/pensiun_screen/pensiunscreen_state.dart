part of 'pensiunscreen_bloc.dart';

abstract class PensiunscreenState extends Equatable {
  const PensiunscreenState();

  @override
  List<Object?> get props => [];
}

class PensiunscreenInitial extends PensiunscreenState {}

class PensiunscreenLoading extends PensiunscreenState {}

class PensiunscreenLoaded extends PensiunscreenState {
  final PensionResponseModel data;

  const PensiunscreenLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class PensiunscreenError extends PensiunscreenState {
  final String message;

  const PensiunscreenError(this.message);

  @override
  List<Object?> get props => [message];
}

part of 'mainpensiun_bloc.dart';

abstract class MainpensiunState extends Equatable {
  const MainpensiunState();

  @override
  List<Object?> get props => [];
}

class MainpensiunInitial extends MainpensiunState {}

class MainpensiunLoading extends MainpensiunState {}

class MainpensiunLoaded extends MainpensiunState {
  final PensionResponseModel? pension; 

  const MainpensiunLoaded(this.pension);

  @override
  List<Object?> get props => [pension];
}

class MainpensiunError extends MainpensiunState {
  final String message;

  const MainpensiunError(this.message);

  @override
  List<Object?> get props => [message];
}

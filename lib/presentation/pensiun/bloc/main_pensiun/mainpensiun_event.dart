part of 'mainpensiun_bloc.dart';

abstract class MainpensiunEvent extends Equatable {
  const MainpensiunEvent();

  @override
  List<Object?> get props => [];
}

class FetchMainPensiun extends MainpensiunEvent {}

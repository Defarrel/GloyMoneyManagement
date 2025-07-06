part of 'pensiunscreen_bloc.dart';

abstract class PensiunscreenEvent extends Equatable {
  const PensiunscreenEvent();

  @override
  List<Object> get props => [];
}

class LoadPensionData extends PensiunscreenEvent {}

part of 'pensiunscreen_bloc.dart';

abstract class PensiunScreenEvent extends Equatable {
  const PensiunScreenEvent();

  @override
  List<Object?> get props => [];
}

class FetchPensionData extends PensiunScreenEvent {}

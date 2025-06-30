part of 'tambahpensiun_bloc.dart';

abstract class TambahpensiunEvent extends Equatable {
  const TambahpensiunEvent();

  @override
  List<Object> get props => [];
}

class SubmitTambahPensiun extends TambahpensiunEvent {
  final int targetAmount;
  final String deadline;

  const SubmitTambahPensiun({
    required this.targetAmount,
    required this.deadline,
  });

  @override
  List<Object> get props => [targetAmount, deadline];
}

class SelectDeadline extends TambahpensiunEvent {
  final BuildContext context;

  const SelectDeadline(this.context);

  @override
  List<Object> get props => [context];
}

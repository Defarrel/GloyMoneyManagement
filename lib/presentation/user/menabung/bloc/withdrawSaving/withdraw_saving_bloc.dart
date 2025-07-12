import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/models/request/menabung/join_menabung_request_model.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'withdraw_saving_event.dart';
import 'withdraw_saving_state.dart';

class WithdrawSavingBloc extends Bloc<WithdrawSavingEvent, WithdrawSavingState> {
  final SavingRepository repository;

  WithdrawSavingBloc(this.repository) : super(WithdrawSavingInitial()) {
    on<SubmitWithdrawSaving>((event, emit) async {
      emit(WithdrawSavingLoading());

      final request = JointSavingRequestModel(
        userId: event.userId,
        amount: event.amount,
      );

      final result = await repository.withdrawFromSaving(event.savingId, request);

      result.fold(
        (err) => emit(WithdrawSavingFailure(err)),
        (msg) => emit(WithdrawSavingSuccess(msg)),
      );
    });
  }
}

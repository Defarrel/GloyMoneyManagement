import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/models/request/menabung/join_menabung_request_model.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/topUpSaving/top_up_saving_event.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/topUpSaving/top_up_saving_state.dart';

class TopUpSavingBloc extends Bloc<TopUpSavingEvent, TopUpSavingState> {
  final SavingRepository repository;

  TopUpSavingBloc(this.repository) : super(TopUpSavingInitial()) {
    on<SubmitTopUpSaving>((event, emit) async {
      emit(TopUpSavingLoading());
      final request = JointSavingRequestModel(
        userId: event.userId,
        amount: event.amount,
      );
      final result = await repository.contributeToSaving(event.savingId, request);
      result.fold(
        (err) => emit(TopUpSavingFailure(err)),
        (msg) => emit(TopUpSavingSuccess(msg)),
      );
    });
  }
}

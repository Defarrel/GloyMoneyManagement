import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/request/pensiun/pensiun_amount_request_model.dart.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

part 'withdrawpensiun_event.dart';
part 'withdrawpensiun_state.dart';

class WithdrawpensiunBloc extends Bloc<WithdrawpensiunEvent, WithdrawpensiunState> {
  final PensionRepository _repo = PensionRepository(ServiceHttpClient());

  WithdrawpensiunBloc() : super(WithdrawpensiunInitial()) {
    on<SubmitWithdrawPensiun>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitWithdrawPensiun event,
    Emitter<WithdrawpensiunState> emit,
  ) async {
    emit(WithdrawpensiunLoading());

    final result = await _repo.withdrawPension(
      PensiunAmountRequestModel(amount: event.amount),
    );

    result.fold(
      (err) => emit(WithdrawpensiunFailure(err)),
      (_) => emit(WithdrawpensiunSuccess()),
    );
  }
}

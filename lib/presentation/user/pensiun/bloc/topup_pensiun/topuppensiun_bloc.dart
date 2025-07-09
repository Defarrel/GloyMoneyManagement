import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/request/pensiun/pensiun_amount_request_model.dart.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

part 'topuppensiun_event.dart';
part 'topuppensiun_state.dart';

class TopupPensiunBloc extends Bloc<TopupPensiunEvent, TopupPensiunState> {
  final PensionRepository _repo = PensionRepository(ServiceHttpClient());

  TopupPensiunBloc() : super(TopupPensiunInitial()) {
    on<SubmitTopupPensiun>(_onSubmitTopupPensiun);
  }

  Future<void> _onSubmitTopupPensiun(
    SubmitTopupPensiun event,
    Emitter<TopupPensiunState> emit,
  ) async {
    emit(TopupPensiunLoading());

    final result = await _repo.topUpPension(
      PensiunAmountRequestModel(amount: event.amount),
    );

    result.fold(
      (err) => emit(TopupPensiunFailure(err)),
      (_) => emit(TopupPensiunSuccess()),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/request/pensiun/pensiun_request_model.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';

part 'tambahpensiun_event.dart';
part 'tambahpensiun_state.dart';

class TambahpensiunBloc extends Bloc<TambahpensiunEvent, TambahpensiunState> {
  final PensionRepository repository;

  TambahpensiunBloc(this.repository) : super(TambahpensiunInitial()) {
    on<SubmitTambahPensiun>(_onSubmitTambahPensiun);
  }

  Future<void> _onSubmitTambahPensiun(
    SubmitTambahPensiun event,
    Emitter<TambahpensiunState> emit,
  ) async {
    emit(TambahpensiunLoading());

    final request = AddPensionRequestModel(
      targetAmount: event.targetAmount,
      deadline: event.deadline,
    );

    final result = await repository.addPension(request);

    result.fold(
      (failure) => emit(TambahpensiunFailure(error: failure)),
      (success) => emit(TambahpensiunSuccess(message: success)),
    );
  }
}

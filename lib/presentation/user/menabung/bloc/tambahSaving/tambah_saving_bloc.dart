import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/models/request/menabung/menabung_request_model.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'tambah_saving_event.dart';
import 'tambah_saving_state.dart';

class TambahSavingBloc extends Bloc<TambahSavingEvent, TambahSavingState> {
  final SavingRepository repository;

  TambahSavingBloc(this.repository) : super(TambahSavingInitial()) {
    on<SubmitSavingEvent>((event, emit) async {
      emit(TambahSavingLoading());
      final model = SavingRequestModel(
        userId: event.userId,
        title: event.title,
        targetAmount: event.targetAmount,
        deadline: event.deadline.toIso8601String(),
      );
      final result = await repository.createSaving(model);
      result.fold(
        (err) => emit(TambahSavingFailure(err)),
        (_) => emit(TambahSavingSuccess()),
      );
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/data/models/request/pensiun/pensiun_request_model.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:intl/intl.dart';

part 'tambahpensiun_event.dart';
part 'tambahpensiun_state.dart';

class TambahpensiunBloc extends Bloc<TambahpensiunEvent, TambahpensiunState> {
  final PensionRepository repository;

  TambahpensiunBloc(this.repository) : super(TambahpensiunInitial()) {
    on<SubmitTambahPensiun>(_onSubmitTambahPensiun);
    on<SelectDeadline>(_onSelectDeadline);
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

  Future<void> _onSelectDeadline(
    SelectDeadline event,
    Emitter<TambahpensiunState> emit,
  ) async {
    final selected = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(selected);
      emit(DeadlinePicked(formatted));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/savingScreen/saving_event.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/savingScreen/saving_state.dart';

class SavingBloc extends Bloc<SavingEvent, SavingState> {
  final SavingRepository repository;

  SavingBloc(this.repository) : super(SavingInitial()) {
    on<LoadAllSavingEvent>(_onLoadAll);
    on<LoadSavingDetailEvent>(_onLoadDetail);
  }

  Future<void> _onLoadAll(
    LoadAllSavingEvent event,
    Emitter<SavingState> emit,
  ) async {
    emit(SavingLoading());
    final result = await repository.getAllSavings();
    result.fold(
      (err) => emit(SavingError(err)),
      (data) => emit(SavingLoaded(data)),
    );
  }

  Future<void> _onLoadDetail(
    LoadSavingDetailEvent event,
    Emitter<SavingState> emit,
  ) async {
    final result = await repository.getSavingDetail(event.id);
    result.fold(
      (err) => event.onError?.call(err),
      (data) => event.onSuccess?.call(data),
    );
  }
}

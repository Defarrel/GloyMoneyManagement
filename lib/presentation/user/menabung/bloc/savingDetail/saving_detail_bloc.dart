import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'saving_detail_event.dart';
import 'saving_detail_state.dart';

class SavingDetailBloc extends Bloc<SavingDetailEvent, SavingDetailState> {
  final SavingRepository repository;

  SavingDetailBloc(this.repository) : super(SavingDetailInitial()) {
    on<LoadSavingDetailEvent>((event, emit) async {
      emit(SavingDetailLoading());
      final result = await repository.getSavingDetail(event.savingId);
      result.fold(
        (err) => emit(SavingDetailError(err)),
        (detail) => emit(SavingDetailLoaded(detail)),
      );
    });
  }
}

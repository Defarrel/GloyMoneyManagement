import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'riwayat_saving_event.dart';
import 'riwayat_saving_state.dart';

class RiwayatSavingBloc extends Bloc<RiwayatSavingEvent, RiwayatSavingState> {
  final SavingRepository repository;

  RiwayatSavingBloc(this.repository) : super(RiwayatSavingInitial()) {
    on<LoadRiwayatSaving>((event, emit) async {
      emit(RiwayatSavingLoading());
      final result = await repository.getContributions(event.savingId);
      result.fold(
        (err) => emit(RiwayatSavingFailure(err)),
        (data) => emit(RiwayatSavingLoaded(data)),
      );
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/response/pensiun/pensiun_response_model.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

part 'pensiunscreen_event.dart';
part 'pensiunscreen_state.dart';

class PensiunScreenBloc extends Bloc<PensiunScreenEvent, PensiunScreenState> {
  final PensionRepository _repo = PensionRepository(ServiceHttpClient());

  PensiunScreenBloc() : super(PensiunScreenInitial()) {
    on<FetchPensionData>(_onFetchPensionData);
  }

  Future<void> _onFetchPensionData(
    FetchPensionData event,
    Emitter<PensiunScreenState> emit,
  ) async {
    emit(PensiunScreenLoading());
    final result = await _repo.getPension();
    result.fold(
      (error) => emit(PensiunScreenError(error)),
      (data) => emit(PensiunScreenLoaded(data)),
    );
  }
}

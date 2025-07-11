import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/response/pensiun/pensiun_response_model.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

part 'mainpensiun_event.dart';
part 'mainpensiun_state.dart';

class MainpensiunBloc extends Bloc<MainpensiunEvent, MainpensiunState> {
  final PensionRepository _repo = PensionRepository(ServiceHttpClient());

  MainpensiunBloc() : super(MainpensiunInitial()) {
    on<FetchMainPensiun>(_onFetchMainPensiun);
  }

  Future<void> _onFetchMainPensiun(
    FetchMainPensiun event,
    Emitter<MainpensiunState> emit,
  ) async {
    emit(MainpensiunLoading());
    final result = await _repo.getPension();
    result.fold(
      (error) => emit(MainpensiunError(error)),
      (data) => emit(MainpensiunLoaded(data)), 
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/response/pensiun/pensiun_response_model.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

part 'pensiunscreen_event.dart';
part 'pensiunscreen_state.dart';

class PensiunscreenBloc extends Bloc<PensiunscreenEvent, PensiunscreenState> {
  final PensionRepository _repo = PensionRepository(ServiceHttpClient());

  PensiunscreenBloc() : super(PensiunscreenInitial()) {
    on<LoadPensionData>((event, emit) async {
      emit(PensiunscreenLoading());
      final result = await _repo.getPension();
      result.fold(
        (error) => emit(PensiunscreenError(error)),
        (data) => emit(PensiunscreenLoaded(data)),
      );
    });
  }
}

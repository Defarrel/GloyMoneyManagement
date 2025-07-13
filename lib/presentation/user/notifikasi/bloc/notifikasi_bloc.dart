import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/response/invite/invt_response_model.dart';
import 'package:gloymoneymanagement/data/repository/invitation_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

part 'notifikasi_event.dart';
part 'notifikasi_state.dart';

class NotifikasiBloc extends Bloc<NotifikasiEvent, NotifikasiState> {
  final InvitationRepository repository;

  NotifikasiBloc(this.repository) : super(NotifikasiInitial()) {
    on<LoadNotifikasiEvent>((event, emit) async {
      emit(NotifikasiLoading());
      final result = await repository.getUserInvitations();
      result.fold(
        (err) => emit(NotifikasiError(err)),
        (data) => emit(NotifikasiLoaded(data)),
      );
    });

    on<RespondInvitationEvent>((event, emit) async {
      final result = await repository.respondToInvitation(
        invitationId: event.id,
        status: event.status,
      );

      result.fold(
        (err) => emit(NotifikasiError(err)),
        (msg) => emit(NotifikasiResponded(msg)),
      );

      // Reload notifications after response
      final reload = await repository.getUserInvitations();
      reload.fold(
        (err) => emit(NotifikasiError(err)),
        (data) => emit(NotifikasiLoaded(data)),
      );
    });
  }
}

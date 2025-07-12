import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/models/request/invite/invt_request_model.dart';
import 'package:gloymoneymanagement/data/repository/akun_repository.dart';
import 'package:gloymoneymanagement/data/repository/invitation_repository.dart';
import 'invt_saving_event.dart';
import 'invt_saving_state.dart';

class InvtSavingBloc extends Bloc<InvtSavingEvent, InvtSavingState> {
  final AkunRepository akunRepository;
  final InvitationRepository invitationRepository;

  InvtSavingBloc({
    required this.akunRepository,
    required this.invitationRepository,
  }) : super(InvtSavingInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(InvtSavingLoading());
      final userId = await akunRepository.getUserIdFromStorage();
      final result = await akunRepository.getAllUsers();
      result.fold(
        (err) => emit(InvtSavingError(err)),
        (data) {
          final users = data.where((user) => user.id != userId).toList();
          emit(InvtSavingLoaded(users, userId!));
        },
      );
    });

    on<SendInvitation>((event, emit) async {
      final result = await invitationRepository.sendInvitation(
        InvtRequestModel(
          savingId: event.savingId,
          receiverId: event.receiverId,
          senderId: event.senderId,
        ),
      );

      result.fold(
        (err) => emit(InvtSavingError(err)),
        (msg) => emit(InvtSavingSuccessMessage(msg)),
      );

      add(LoadUsers()); // refresh list setelah invite
    });
  }
}

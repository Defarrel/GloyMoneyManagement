import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'withdrawpensiun_event.dart';
part 'withdrawpensiun_state.dart';

class WithdrawpensiunBloc extends Bloc<WithdrawpensiunEvent, WithdrawpensiunState> {
  WithdrawpensiunBloc() : super(WithdrawpensiunInitial()) {
    on<WithdrawpensiunEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

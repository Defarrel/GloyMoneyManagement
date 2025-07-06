import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'topuppensiun_event.dart';
part 'topuppensiun_state.dart';

class TopuppensiunBloc extends Bloc<TopuppensiunEvent, TopuppensiunState> {
  TopuppensiunBloc() : super(TopuppensiunInitial()) {
    on<TopuppensiunEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

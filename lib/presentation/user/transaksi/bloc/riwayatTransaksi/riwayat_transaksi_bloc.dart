import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'riwayat_transaksi_event.dart';
part 'riwayat_transaksi_state.dart';

class RiwayatTransaksiBloc extends Bloc<RiwayatTransaksiEvent, RiwayatTransaksiState> {
  RiwayatTransaksiBloc() : super(RiwayatTransaksiInitial()) {
    on<RiwayatTransaksiEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

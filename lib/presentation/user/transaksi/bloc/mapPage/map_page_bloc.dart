// map_page_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'map_page_event.dart';
part 'map_page_state.dart';

class MapPageBloc extends Bloc<MapPageEvent, MapPageState> {
  MapPageBloc() : super(MapPageInitial()) {
    on<LoadCurrentLocation>(_onLoadCurrentLocation);
    on<SelectLocation>(_onSelectLocation);
  }

  Future<void> _onLoadCurrentLocation(
      LoadCurrentLocation event, Emitter<MapPageState> emit) async {
    emit(MapPageLoading());
    try {
      final position = await _getCurrentLocation();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final p = placemarks.first;
      final address =
          '${p.name}, ${p.street}, ${p.locality}, ${p.country}, ${p.postalCode}';

      emit(MapPageLoaded(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ));
    } catch (e) {
      emit(MapPageError(e.toString()));
    }
  }

  Future<void> _onSelectLocation(
      SelectLocation event, Emitter<MapPageState> emit) async {
    emit(MapPageLoading());
    try {
      final placemarks = await placemarkFromCoordinates(
        event.latitude,
        event.longitude,
      );
      final p = placemarks.first;
      final address =
          '${p.name}, ${p.street}, ${p.locality}, ${p.country}, ${p.postalCode}';

      emit(MapPageLoaded(
        latitude: event.latitude,
        longitude: event.longitude,
        address: address,
      ));
    } catch (e) {
      emit(MapPageError(e.toString()));
    }
  }

  Future<Position> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Layanan lokasi dinonaktifkan';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Izin lokasi ditolak';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak permanen';
    }

    return await Geolocator.getCurrentPosition();
  }
}

// map_page_event.dart

part of 'map_page_bloc.dart';

sealed class MapPageEvent extends Equatable {
  const MapPageEvent();

  @override
  List<Object> get props => [];
}

class LoadCurrentLocation extends MapPageEvent {}

class SelectLocation extends MapPageEvent {
  final double latitude;
  final double longitude;

  const SelectLocation({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}

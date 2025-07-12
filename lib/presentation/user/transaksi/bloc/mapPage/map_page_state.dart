// map_page_state.dart

part of 'map_page_bloc.dart';

sealed class MapPageState extends Equatable {
  const MapPageState();

  @override
  List<Object> get props => [];
}

class MapPageInitial extends MapPageState {}

class MapPageLoading extends MapPageState {}

class MapPageLoaded extends MapPageState {
  final double latitude;
  final double longitude;
  final String address;

  const MapPageLoaded({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object> get props => [latitude, longitude, address];
}

class MapPageError extends MapPageState {
  final String message;

  const MapPageError(this.message);

  @override
  List<Object> get props => [message];
}

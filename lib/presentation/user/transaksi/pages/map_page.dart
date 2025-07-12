import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/bloc/mapPage/map_page_bloc.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _ctrl = Completer();
  Marker? _pickedMarker;

  @override
  void initState() {
    super.initState();
    context.read<MapPageBloc>().add(LoadCurrentLocation());
  }

  Future<void> _onTap(LatLng LatLng) async {
    context.read<MapPageBloc>().add(
      SelectLocation(latitude: LatLng.latitude, longitude: LatLng.longitude),
    );

    setState(() {
      _pickedMarker = Marker(
        markerId: const MarkerId('picked'),
        position: LatLng,
        infoWindow: const InfoWindow(title: 'Lokasi Dipilih'),
      );
    });

    final ctrl = await _ctrl.future;
    await ctrl.animateCamera(CameraUpdate.newLatLngZoom(LatLng, 16));
  }

  void _confirmSelection(String address) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Alamat'),
        content: Text(address),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, address);
            },
            child: const Text('Pilih'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapPageBloc, MapPageState>(
      listener: (context, state) {
        if (state is MapPageError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is MapPageLoading || state is MapPageInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MapPageLoaded) {
          final initialCamera = CameraPosition(
            target: LatLng(state.latitude, state.longitude),
            zoom: 16,
          );

          return Scaffold(
            appBar: AppBar(title: const Text('Pilih Alamat')),
            body: SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: initialCamera,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    compassEnabled: true,
                    tiltGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    rotateGesturesEnabled: true,
                    trafficEnabled: true,
                    buildingsEnabled: true,
                    onMapCreated: (GoogleMapController ctrl) {
                      _ctrl.complete(ctrl);
                    },
                    markers: _pickedMarker != null
                        ? {_pickedMarker!}
                        : <Marker>{},
                    onTap: _onTap,
                  ),
                  if (state.address.isNotEmpty)
                    Positioned(
                      top: 250,
                      left: 56,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(state.address),
                      ),
                    ),
                ],
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 8),
                if (state.address.isNotEmpty)
                  FloatingActionButton.extended(
                    onPressed: () => _confirmSelection(state.address),
                    heroTag: 'Confirm',
                    label: const Text('Pilih Alamat'),
                  ),
                const SizedBox(height: 8),
                if (_pickedMarker != null)
                  FloatingActionButton.extended(
                    heroTag: 'Clear',
                    label: const Text('Hapus Alamat'),
                    onPressed: () {
                      setState(() {
                        _pickedMarker = null;
                      });
                      context.read<MapPageBloc>().add(LoadCurrentLocation());
                    },
                  ),
              ],
            ),
          );
        }

        return const SizedBox(); // fallback kosong
      },
    );
  }
}

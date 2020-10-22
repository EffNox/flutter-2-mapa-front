import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart' as Geo;

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());

// final _geoLocator = GeoLocator.isLocationServiceEnabled();

  StreamSubscription<Geo.Position> _positionSub;

  void initSeguimiento() {
    _positionSub = Geo.getPositionStream(
      desiredAccuracy: Geo.LocationAccuracy.high,
      distanceFilter: 10,
    ).listen((pst) {
      final newLocation = LatLng(pst.latitude, pst.longitude);
      add(OnChangeUbicacion(newLocation));
    });
  }

  void cancelSiguimiento() {
    _positionSub?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(MiUbicacionEvent ev) async* {
    if (ev is OnChangeUbicacion) {
      yield state.copyWith(existeUbicacion: true, ubicacion: ev.ubicacion);
    }
  }
}

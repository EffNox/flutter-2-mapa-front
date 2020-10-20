import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/themes/uber_map.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

// Controlador del Mapa
  GoogleMapController _clMap;
  // Polylines
  Polyline _miRuta = Polyline(
    polylineId: PolylineId('mi_ruta'),
    color: Colors.transparent,
    width: 4,
  );

  void initMapa(GoogleMapController cl) {
    if (!state.mapaListo) {
      _clMap = cl;
      _clMap.setMapStyle(jsonEncode(uberMapTheme));
      add(OnMapLoaded());
    }
  }

  void moveCamera(LatLng point) {
    final cameraUpdate = CameraUpdate.newLatLng(point);
    _clMap.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent ev) async* {
    if (ev is OnMapLoaded) {
      yield state.copyWith(mapaListo: true);
    } else if (ev is OnLocationUpdate) {
      yield* _onLocationUpdate(ev);
    } else if (ev is OnMarcarRecorrido) {
      yield* _onMarcarRecorrido(ev);
    } else if (ev is OnSeguirUbicacion) {
      yield* _onSeguirUbicacion(ev);
    } else if (ev is OnMoveMap) {
      yield state.copyWith(centralLocation: ev.centralLocation);
    }
  }

  Stream<MapaState> _onLocationUpdate(OnLocationUpdate ev) async* {
    if (state.seguirUbicacion) moveCamera(ev.ubicacion);
    final points = [..._miRuta.points, ev.ubicacion];
    _miRuta = _miRuta.copyWith(pointsParam: points);
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = _miRuta;
    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido ev) async* {
    _miRuta = _miRuta.copyWith(
        colorParam:
            !state.dibujarRecorrido ? Colors.amberAccent : Colors.transparent);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = _miRuta;
    yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido, polylines: currentPolylines);
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion ev) async* {
    if (!state.seguirUbicacion) {
      moveCamera(_miRuta.points[_miRuta.points.length - 1]);
    }
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }
}

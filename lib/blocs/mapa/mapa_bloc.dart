import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/helpers/helpers.dart';
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

  Polyline _miRutaDestino = Polyline(
    polylineId: PolylineId('mi_ruta_destino'),
    color: Colors.black87,
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
    } else if (ev is OnCreateRouteDestiny) {
      yield* _onCreateRouteDestiny(ev);
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

  Stream<MapaState> _onCreateRouteDestiny(OnCreateRouteDestiny ev) async* {
    _miRutaDestino = _miRutaDestino.copyWith(pointsParam: ev.coordenadas);
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = _miRutaDestino;

    // final iconBegin = await getAssetImageMarker();
    // final iconEnd = await getNetworkImageMarker();

    final iconBegin = await getMarkerBeginIcon(ev.duration.toInt());
    final iconEnd = await getMarkerEndIcon(ev.destino,ev.distance);

    final markerBegin = Marker(
      markerId: MarkerId('begin'),
      icon: iconBegin,
      anchor: Offset(0.066, 0.9),
      position: ev.coordenadas[0],
      infoWindow: InfoWindow(
          title: 'Mi Ubicación',
          snippet: 'Duración recorrido ${(ev.duration / 60).floor()} minutos'),
    );

    double km = ev.distance / 1000;
    km = (km * 100).floorToDouble();
    km = km / 100;
    final markerEnd = Marker(
      markerId: MarkerId('end'),
      icon: iconEnd,
      anchor: Offset(0.066, 0.9),
      position: ev.coordenadas[ev.coordenadas.length - 1],
      infoWindow: InfoWindow(
          title: 'Mi Destino: ${ev.destino}',
          snippet: 'Distancia ${km} Kilómetros'),
    );

    final newMarker = {...state.markers}; /* Map.from(state.markers); */

    newMarker['begin'] = markerBegin;
    newMarker['end'] = markerEnd;

    Future.delayed(Duration(milliseconds: 300)).then((value) {
      // _clMap.showMarkerInfoWindow(MarkerId('begin'));
      _clMap.showMarkerInfoWindow(MarkerId('end'));
    });

    yield state.copyWith(polylines: currentPolylines, markers: newMarker);
  }
}

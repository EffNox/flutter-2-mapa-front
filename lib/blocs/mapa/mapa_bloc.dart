import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/themes/uber_map.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

  GoogleMapController _clMap;

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
      print('Mapa Listo');
      yield state.copyWith(mapaListo: true);
    }
  }
}

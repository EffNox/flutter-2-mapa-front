part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;
  final LatLng centralLocation;

  final Map<String, Polyline> polylines;

  MapaState({
    this.mapaListo = false,
    this.dibujarRecorrido = false,
    this.seguirUbicacion = false,
    Map<String, Polyline> polylines,
    this.centralLocation,
  }) : this.polylines = polylines ?? Map();

  MapaState copyWith(
          {bool mapaListo,
          bool dibujarRecorrido,
          bool seguirUbicacion,
          LatLng centralLocation,
          Map<String, Polyline> polylines}) =>
      MapaState(
        polylines: polylines ?? this.polylines,
        mapaListo: mapaListo ?? this.mapaListo,
        centralLocation: centralLocation ?? this.centralLocation,
        seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
        dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
      );
}

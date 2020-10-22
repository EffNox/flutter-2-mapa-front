part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapLoaded extends MapaEvent {}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnCreateRouteDestiny extends MapaEvent {
  final List<LatLng> coordenadas;
  final double distance;
  final double duration;
  final String destino;
  OnCreateRouteDestiny(this.coordenadas, this.distance, this.duration, this.destino);
}

class OnMoveMap extends MapaEvent {
  final LatLng centralLocation;
  OnMoveMap(this.centralLocation);
}

class OnLocationUpdate extends MapaEvent {
  final LatLng ubicacion;
  OnLocationUpdate(this.ubicacion);
}

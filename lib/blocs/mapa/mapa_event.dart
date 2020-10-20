part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapLoaded extends MapaEvent {}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnMoveMap extends MapaEvent {
  final LatLng centralLocation;
  OnMoveMap(this.centralLocation);
}

class OnLocationUpdate extends MapaEvent {
  final LatLng ubicacion;
  OnLocationUpdate(this.ubicacion);
}

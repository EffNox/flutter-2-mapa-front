import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/blocs/mapa/mapa_bloc.dart';
import 'package:mapas/blocs/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapas/widgets/widgets.dart';

class MapaPg extends StatefulWidget {
  @override
  _MapaPgState createState() => _MapaPgState();
}

class _MapaPgState extends State<MapaPg> {
  @override
  void initState() {
    context.bloc<MiUbicacionBloc>().initSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    context.bloc<MiUbicacionBloc>().cancelSiguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: (_, st) => Center(child: crearMapa(st)),
          ),
          Positioned(child: SearchBar(), top: 15),
          MarkerManual(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [BtnUbicacion(), BtnSeguirUbicacion(), BtnMiRuta()],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState st) {
    if (!st.existeUbicacion) return Text('Localizando ubicación');
    final initialLatLng = CameraPosition(target: st.ubicacion, zoom: 15);

    final blMap = context.bloc<MapaBloc>();
    blMap.add(OnLocationUpdate(st.ubicacion));

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (_, __) {
        return GoogleMap(
          initialCameraPosition: initialLatLng,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: blMap.initMapa,
          polylines: blMap.state.polylines.values.toSet(),
          markers: blMap.state.markers.values.toSet(),
          onTap: (v) {
            if (blMap.state.seguirUbicacion) blMap.add(OnSeguirUbicacion());
          },
          onCameraMove: (v) => blMap.add(OnMoveMap(v.target)),
        );
      },
    );
  }
}

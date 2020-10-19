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
      body: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
        builder: (_, st) => Center(child: crearMapa(st)),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [BtnUbicacion()],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState st) {
    if (!st.existeUbicacion) return Text('Localizando ubicación');
    final initialLatLng = CameraPosition(target: st.ubicacion, zoom: 15);
    return GoogleMap(
      initialCameraPosition: initialLatLng,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: context.bloc<MapaBloc>().initMapa,
    );
  }
}

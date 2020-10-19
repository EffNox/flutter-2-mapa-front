import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas/blocs/mapa/mapa_bloc.dart';
import 'package:mapas/blocs/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapas/pages/access_gps.dart';
import 'package:mapas/pages/loading.dart';
import 'package:mapas/pages/mapa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MiUbicacionBloc()),
        BlocProvider(create: (_) => MapaBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading',
        routes: {
          'mapa': (_) => MapaPg(),
          'access_gps': (_) => GpsPg(),
          'loading': (_) => LoadingPg(),
        },
      ),
    );
  }
}

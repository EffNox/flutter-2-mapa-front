import 'package:flutter/material.dart';
import 'package:mapas/pages/access_gps.dart';
import 'package:mapas/pages/loading.dart';
import 'package:mapas/pages/mapa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'loading',
      routes: {
        'mapa': (_) => MapaPg(),
        'access_gps': (_) => GpsPg(),
        'loading': (_) => LoadingPg(),
      },
    );
  }
}

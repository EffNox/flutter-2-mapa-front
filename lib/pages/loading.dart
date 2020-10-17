import 'package:flutter/material.dart';
import 'package:mapas/helpers/helpers.dart';
import 'package:mapas/pages/access_gps.dart';
import 'package:mapas/pages/mapa.dart';
import 'package:geolocator/geolocator.dart' as Geo;
import 'package:permission_handler/permission_handler.dart';

class LoadingPg extends StatefulWidget {
  @override
  _LoadingPgState createState() => _LoadingPgState();
}

class _LoadingPgState extends State<LoadingPg> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) checkGpsYLocation(context);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: checkGpsYLocation(context),
      builder: (_, AsyncSnapshot __) => (__.hasData)
          ? Center(child: Text(__.data))
          : Center(child: CircularProgressIndicator(strokeWidth: 5)),
    ));
  }

  Future checkGpsYLocation(BuildContext context) async {
    final dt = await Future.wait(
        [Permission.location.isGranted, Geo.isLocationServiceEnabled()]);
    if (dt[0] && dt[1]) {
      Navigator.pushReplacement(context, navigateToPgFadeIn(context, MapaPg()));
      return '';
    } else if (!dt[0]) {
      Navigator.pushReplacement(context, navigateToPgFadeIn(context, GpsPg()));
      return 'Es necesario el permiso de GPS';
    } else if (!dt[1]) {
      return 'Es necesario activar el GPS';
    } else {
      return null;
    }
  }
}

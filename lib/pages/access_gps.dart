import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GpsPg extends StatefulWidget {
  @override
  _GpsPgState createState() => _GpsPgState();
}

class _GpsPgState extends State<GpsPg> with WidgetsBindingObserver {
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
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('==========> $state');
    if (state == AppLifecycleState.resumed) {
      if (await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, 'loading');
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Es necesario el GPS para usar esta App'),
            SizedBox(height: 10),
            MaterialButton(
                height: 50,
                minWidth: 150,
                child: Text('Solicitar Acceso',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                color: Colors.black54,
                shape: StadiumBorder(),
                onPressed: () async {
                  final status = await Permission.location.request();
                  accessGps(status);
                })
          ],
        ),
      ),
    );
  }

  void accessGps(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        Navigator.pushReplacementNamed(context, 'mapa');
        break;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
      case PermissionStatus.undetermined:
        openAppSettings();
    }
  }
}

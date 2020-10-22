part of 'helpers.dart';

void calculateAlerta(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cargando ruta más cercana..',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        content: LinearProgressIndicator(),
      ),
    );
  } else {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Cargando ruta más cercana..',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              content: CupertinoActivityIndicator(),
            ));
  }
}

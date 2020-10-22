part of 'helpers.dart';

Future<BitmapDescriptor> getMarkerBeginIcon(int seg) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final sz = Size(350, 150);
  final min = (seg / 60).floor();
  final markerBegin = MarkerBeginPainter(min);
  markerBegin.paint(canvas, sz);
  final picture = recorder.endRecording();
  final image = await picture.toImage(sz.width.toInt(), sz.height.toInt());
  final byteDt = await image.toByteData(format: ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(byteDt.buffer.asUint8List());
}

Future<BitmapDescriptor> getMarkerEndIcon(String des, double metros) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final sz = Size(350, 150);
  final markerBegin = MarkerEndPainter(des, metros);
  markerBegin.paint(canvas, sz);
  final picture = recorder.endRecording();
  final image = await picture.toImage(sz.width.toInt(), sz.height.toInt());
  final byteDt = await image.toByteData(format: ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(byteDt.buffer.asUint8List());
}

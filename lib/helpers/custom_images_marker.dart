part of 'helpers.dart';

Future<BitmapDescriptor> getAssetImageMarker() async {
  return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 'assets/img/pin-map.png');
}

Future<BitmapDescriptor> getNetworkImageMarker() async {
  final rs = await Dio().get(
      'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-512.png',
      options: Options(responseType: ResponseType.bytes));
  final bytes = rs.data;
  final imageCodec =
      await instantiateImageCodec(bytes, targetWidth: 150, targetHeight: 150);
  final frame = await imageCodec.getNextFrame();
  final dt = await frame.image.toByteData(format: ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(dt.buffer.asUint8List());
  // return BitmapDescriptor.fromBytes(rs.data);
}

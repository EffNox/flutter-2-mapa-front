import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapas/helpers/debouncer.dart';
import 'package:mapas/models/RsGeoCoding.dart';
import 'package:mapas/models/RsReverseQuery.dart';
import 'package:mapas/models/RsTraffic.dart';

class STraffic {
  // Singleton

  STraffic._privateContructor();
  static final STraffic _instance = STraffic._privateContructor();
  factory STraffic() => _instance;

  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 500));
  final _suggestionsStream = StreamController<RsGeoCoding>.broadcast();
  Stream<RsGeoCoding> get suggestions => _suggestionsStream.stream;

  final _dio = new Dio();
  final key =
      'pk.eyJ1Ijoibml4cm95YWwiLCJhIjoiY2tnaTVuZ3hnMDAxczJycWV0b2pjN3dlOCJ9.99ztvQBxs37GfxSU1GTqvg';
  final urlDir = 'https://api.mapbox.com/directions/v5';
  final urlGeo = 'https://api.mapbox.com/geocoding/v5';

  Future<RsTraffic> getCoordsBegEnd(LatLng begin, LatLng end) async {
    final coords =
        '${begin.longitude},${begin.latitude};${end.longitude},${end.latitude}';
    final api = '$urlDir/mapbox/driving/$coords';
    final rs = await _dio.get(api, queryParameters: {
      'language': 'es',
      'alternatives': true,
      'geometries': 'polyline6',
      'steps': false,
      'access_token': key
    });
    final dt = RsTraffic.fromJson(rs.data);
    return dt;
  }

  Future<RsGeoCoding> getResultadosXQuery(String q, LatLng proximidad) async {
    final url = '$urlGeo/mapbox.places/$q.json';
    final rs = await _dio.get(url, queryParameters: {
      'language': 'es',
      'access_token': key,
      'autocomplete': true,
      'proximity': "${proximidad.longitude},${proximidad.latitude}",
    });

    final dt = rsGeoCodingFromJson(rs.data);
    return dt;
  }

  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.getResultadosXQuery(value, proximidad);
      this._suggestionsStream.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<RsReversQuery> getCoordsQuery(LatLng end) async {
    final api = '$urlGeo/mapbox.places/${end.longitude},${end.latitude}.json';
    final rs = await _dio
        .get(api, queryParameters: {'language': 'es', 'access_token': key});
    final dt = rsReversQueryFromJson(rs.data);
    return dt;
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/blocs/mapa/mapa_bloc.dart';
import 'package:mapas/blocs/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapas/blocs/search/search_bloc.dart';
import 'package:mapas/helpers/helpers.dart';
import 'package:mapas/models/search_result.dart';
import 'package:mapas/search/search_destination.dart';
import 'package:mapas/services/STraffic.dart';
import 'package:polyline/polyline.dart' as Poly;

part 'btn_ubicacion.dart';
part 'btn_miruta.dart';
part 'btn_seguir_ubicacion.dart';
part 'searchbar.dart';
part 'marker_manual.dart';

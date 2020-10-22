part of 'widgets.dart';

class MarkerManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (_, st) {
        return st.selectManual ? _BuildMarkManual() : Container();
      },
    );
  }
}

class _BuildMarkManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Btn regresar
        Positioned(
          top: 70,
          left: 20,
          child: BounceInRight(
            from: 250,
            delay: Duration(milliseconds: 800),
            duration: Duration(seconds: 2),
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: () =>
                    context.bloc<SearchBloc>().add(OnActiveMarkManual()),
              ),
            ),
          ),
        ),
        Center(
          child: Transform.translate(
            offset: Offset(0, -20),
            child: BounceInDown(
              from: 250,
              delay: Duration(milliseconds: 800),
              duration: Duration(seconds: 2),
              child: Icon(Icons.location_on_outlined,
                  size: 50, color: Colors.redAccent),
            ),
          ),
        ),
        // Btn Confirmar destino
        Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BounceInUp(
                from: 50,
                delay: Duration(milliseconds: 800),
                duration: Duration(seconds: 2),
                child: MaterialButton(
                    minWidth: sz.width - 200,
                    color: Colors.black45,
                    shape: StadiumBorder(),
                    elevation: 50,
                    child: Text('Confirmar destino',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async => await calculateDestino(context)),
              ),
            ))
      ],
    );
  }

  void calculateDestino(BuildContext context) async {
    calculateAlerta(context);
    final STra = new STraffic();
    final blMap = context.bloc<MapaBloc>();

    final begin = context.bloc<MiUbicacionBloc>().state.ubicacion;
    final end = blMap.state.centralLocation;
    // Obtener información del destino
    final rsReverse = await STra.getCoordsQuery(end);

    final rsTra = await STra.getCoordsBegEnd(begin, end);
    final geometry = rsTra.routes[0].geometry;
    final duration = rsTra.routes[0].duration;
    final distance = rsTra.routes[0].distance;
    final destino = rsReverse.features[0].text;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final coords = points.map((p) => LatLng(p[0], p[1])).toList();
    blMap.add(OnCreateRouteDestiny(coords, distance, duration, destino));

    context.bloc<SearchBloc>().add(OnActiveMarkManual());
    Navigator.of(context).pop();
  }
}

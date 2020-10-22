part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (_, st) => st.selectManual
          ? Container()
          : BounceInDown(
              from: 50,
              delay: Duration(milliseconds: 500),
              duration: Duration(seconds: 1),
              child: buildSearchBar(context)),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: sz.width,
        child: GestureDetector(
          onTap: () async => returnSearch(
              context,
              await showSearch(
                  context: context,
                  delegate: Search(
                      proximidad:
                          context.bloc<MiUbicacionBloc>().state.ubicacion,
                      history: context.bloc<SearchBloc>().state.history))),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            width: double.infinity,
            child: Text(
              '¿Dónde quieres ir?',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  returnSearch(BuildContext context, SearchResult rs) async {
    if (rs.cancel) return;
    if (rs.manual) {
      context.bloc<SearchBloc>().add(OnActiveMarkManual());
      return;
    }
    calculateAlerta(context);

    final svTra = STraffic();
    final blMap = context.bloc<MapaBloc>();
    final begin = context.bloc<MiUbicacionBloc>().state.ubicacion;
    final end = rs.position;

    final rsReverse = await svTra.getCoordsQuery(end);
    final rsDrivingTraffic = await svTra.getCoordsBegEnd(begin, end);
    final geometry = rsDrivingTraffic.routes[0].geometry;
    final duration = rsDrivingTraffic.routes[0].duration;
    final distance = rsDrivingTraffic.routes[0].distance;
    final destino = rsReverse.features[0].text;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);

    final List<LatLng> coordenadas =
        points.decodedCoords.map((p) => LatLng(p[0], p[1])).toList();
    blMap.add(OnCreateRouteDestiny(coordenadas, distance, duration, destino));
    Navigator.of(context).pop();

    context.bloc<SearchBloc>().add(OnAddHistory(rs));
  }
}

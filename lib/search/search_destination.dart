import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapas/models/RsGeoCoding.dart';
import 'package:mapas/models/search_result.dart';
import 'package:mapas/services/STraffic.dart';

class Search extends SearchDelegate<SearchResult> {
  final searchFieldLabel = 'Buscar...';
  final keyboardType = TextInputType.text;
  final textInputAction = TextInputAction.search;
  // final searchFieldStyle = TextStyle(fontSize: 25);
  final LatLng proximidad;

  final STraffic _svTra;
  final List<SearchResult> history;
  Search({this.proximidad, this.history}) : this._svTra = STraffic();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.search), onPressed: () => query = ''),
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => close(context, SearchResult(cancel: true)));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length == 0) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('Colocar ubicación manualmente'),
            onTap: () {
              close(context, SearchResult(cancel: false, manual: true));
            },
          ),
          ...history
              .map((lugar) => ListTile(
                    leading: Icon(Icons.history),
                    trailing: Icon(Icons.place_outlined),
                    title: Text(lugar.destino),
                    subtitle: Text(lugar.description),
                    onTap: () => close(context, lugar),
                  ))
              .toList()
        ],
      );
    }

    return _buildResultsSuggestions();
  }

  Widget _buildResultsSuggestions() {
    _svTra.getSugerenciasPorQuery(query.trim(), proximidad);
    return StreamBuilder(
      stream: _svTra.suggestions,
      // initialData: InitialData,
      builder: (BuildContext _, AsyncSnapshot<RsGeoCoding> dt) {
        if (!dt.hasData) return Center(child: CircularProgressIndicator());

        final lugares = dt.data.features;
        if (lugares.length == 0) {
          return ListTile(title: Text('No hay resultados con: $query'));
        }
        return ListView.separated(
          itemCount: lugares.length,
          separatorBuilder: (_, i) => Divider(color: Colors.black, height: 15),
          itemBuilder: (_, i) {
            final lugar = lugares[i];
            return ListTile(
              leading: Icon(Icons.place_outlined),
              title: Text(lugar.textEs),
              subtitle: Text(lugar.placeNameEs),
              onTap: () {
                close(
                    _,
                    SearchResult(
                      cancel: false,
                      manual: false,
                      position: LatLng(lugar.center[1], lugar.center[0]),
                      destino: lugar.textEs,
                      description: lugar.placeNameEs,
                    ));
              },
            );
          },
        );
      },
    );
  }
}

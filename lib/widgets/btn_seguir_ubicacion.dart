part of 'widgets.dart';

class BtnSeguirUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blMap = context.bloc<MapaBloc>();
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: BlocBuilder<MapaBloc, MapaState>(
              builder: (_, st) => Icon(
                  st.seguirUbicacion
                      ? Icons.directions_run
                      : Icons.accessibility_new,
                  color: Colors.black87),
            ),
            onPressed: () => blMap.add(OnSeguirUbicacion())),
      ),
    );
  }
}

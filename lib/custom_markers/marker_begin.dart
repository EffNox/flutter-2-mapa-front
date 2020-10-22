part of 'custom_markers.dart';

class MarkerBeginPainter extends CustomPainter {
  final int minutos;
  MarkerBeginPainter(this.minutos);

  
  final double cicleNigga = 20;
  final double cicleWhite = 7;


  @override
  void paint(Canvas canvas, Size sz) {
    Paint paint = Paint()..color = Colors.black87;
    canvas.drawCircle(Offset(cicleNigga, sz.height - cicleNigga), 20, paint);

    paint.color = Colors.white;
    canvas.drawCircle(
        Offset(cicleNigga, sz.height - cicleNigga), cicleWhite, paint);

    final path = Path();
    path.moveTo(40, 20);
    path.lineTo(sz.width - 10, 20);
    path.lineTo(sz.width - 10, 100);
    path.lineTo(40, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    final cajaBlanca = Rect.fromLTWH(40, 20, sz.width - 55, 80);
    canvas.drawRect(cajaBlanca, paint);

    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    var textSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 32, fontWeight: FontWeight.w400),
        text: '$minutos');
    var textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);
    textPainter.paint(canvas, Offset(40, 35));

    textSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400),
        text: 'Min');
    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);
    textPainter.paint(canvas, Offset(40, 67));

    textSpan = TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 28, fontWeight: FontWeight.w400),
        text: 'Mi Ubicación');
    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: sz.width - 130);
    textPainter.paint(canvas, Offset(150, 50));
  }

  @override
  bool shouldRepaint(MarkerBeginPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MarkerBeginPainter oldDelegate) => false;
}

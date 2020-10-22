part of 'custom_markers.dart';

class MarkerEndPainter extends CustomPainter {
  final String description;
  final double metros;

  MarkerEndPainter(this.description, this.metros);

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
    path.moveTo(0, 20);
    path.lineTo(sz.width - 10, 20);
    path.lineTo(sz.width - 10, 100);
    path.lineTo(0, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    final cajaBlanca = Rect.fromLTWH(0, 20, sz.width - 10, 80);
    canvas.drawRect(cajaBlanca, paint);

    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    double kilometros = metros / 1000;
    kilometros = (kilometros * 100).floorToDouble();
    kilometros = kilometros / 100;
    var textSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
        text: '$kilometros');
    var textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);
    textPainter.paint(canvas, Offset(0, 35));

    textSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'Km');
    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70);
    textPainter.paint(canvas, Offset(20, 67));

    textSpan = TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.w400),
        text: description);
    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        maxLines: 3,
        ellipsis: '...')
      ..layout(maxWidth: sz.width - 100);
    textPainter.paint(canvas, Offset(80, 25));
  }

  @override
  bool shouldRepaint(MarkerEndPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MarkerEndPainter oldDelegate) => false;
}

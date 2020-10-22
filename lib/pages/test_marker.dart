import 'package:flutter/material.dart';
import 'package:mapas/custom_markers/custom_markers.dart';

class TestPg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          color: Colors.red,
          child: CustomPaint(
            painter: MarkerEndPainter(
                'Mi cada por algun lado del mundo, esta aquï en dos mil quinientos metros',
                350904),
            // painter: MarkerBeginPainter(20),
          ),
        ),
      ),
    );
  }
}

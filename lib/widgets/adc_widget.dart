import 'dart:math';
import 'dart:ui';
import 'package:amgraph/adc_data.dart';
import 'package:amgraph/mixins/metadata_mixin.dart';
import 'package:amgraph/widgets/adc_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

const graphWidth = 1000.0;

class AdcWidget extends StatefulWidget with Metadata {
  AdcWidget({super.key}) {
    label = "ADC Widget";
    heading = "Analog to Digital Conversion";
  }

  @override
  State<AdcWidget> createState() => _AdcWidgetState();
}

class _AdcWidgetState extends State<AdcWidget> {
  late AdcData data;

  @override
  void initState() {
    data = AdcData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Text(""),
        AdcInputWidget(
          data: data,
          onChanged: (vMin, vMax, sampleRate, bitsPerSample, view) {
            setState(() {
              data.vMin = vMin;
              data.vMax = vMax;
              data.sampleRate = sampleRate;
              data.bitsPerSample = bitsPerSample;
              data.show = view;
            });
          },
        ),
        Divider(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: CustomPaint(
                    size: Size(graphWidth, 500),
                    painter: _AdcPainter(data),
                  ),
                ),
                Positioned(
                  top: mPos - 10,
                  left: 0,
                  child: SelectableMath.tex('v(t)', textScaleFactor: 1.5),
                ),
                Positioned(
                  top: mPos + 250,
                  left: 60,
                  child: SelectableMath.tex(
                    'Time - (milliseconds)',

                    textScaleFactor: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const double border = 50;
const mPos = 220.0;

class _AdcPainter extends CustomPainter {
  AdcData data;
  _AdcPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    double analogSampleRate = 44100.0;
    double pointCount = size.width - 2 * border;
    double viewWidth = 0.01;
    double stopT = viewWidth * pointCount / (graphWidth - 2 * border);
    double minorTicPoints = (graphWidth - 2 * border);
    final thickLine =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color.fromARGB(70, 155, 155, 155);

    final thinLine =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = .5
          ..color = const Color.fromARGB(90, 155, 155, 155);
    final origLine =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color.fromARGB(100, 0, 0, 255);
    final samplePoints =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..color = const Color.fromARGB(255, 0, 0, 0);

    final sampleLines =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color.fromARGB(255, 255, 0, 0);

    final quantLinesEven =
        Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 1
          ..color = const Color.fromARGB(30, 0, 255, 0);

    final quantLinesOdd =
        Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 1
          ..color = const Color.fromARGB(15, 0, 255, 0);

    final quantLinesEdge =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color.fromARGB(80, 0, 255, 0);

    final axis =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color.fromARGB(200, 0, 0, 0);

    var lastm = Offset(border, mPos);
    // Draw Axis
    double vScale = 20;
    drawTimeAxis(
      canvas,
      axis,
      thickLine,
      thinLine,
      quantLinesEven,
      quantLinesOdd,
      quantLinesEdge,
      size,
      stopT,
      analogSampleRate,
      minorTicPoints,
      vScale,
      mPos,
      maxVoltage: 11.0,
    );
    double v1 = 5;
    double v2 = 5;
    double f1 = 110;
    double f2 = 220;
    // Draw Vam
    for (double t = 0; t <= stopT; t += 1 / analogSampleRate) {
      double i = t * pointCount / stopT + border;
      double v = v1 * sin(2.0 * pi * f1 * t) + v2 * sin(2.0 * pi * f2 * t);

      var currm = Offset(i, -vScale * v + mPos);
      if (i == border) {
        lastm = currm;
      }
      canvas.drawLine(lastm, currm, origLine);
      lastm = currm;
    }
    List<Offset> points = [];
    for (double t = 0; t <= stopT; t += 1 / data.sampleRate) {
      double i = t * pointCount / stopT + border;
      double v = v1 * sin(2.0 * pi * f1 * t) + v2 * sin(2.0 * pi * f2 * t);
      Offset point = Offset(i, -vScale * v + mPos);
      points.add(point);
      String current = (binaryQuantize(
        v,
        data.vMin,
        data.vMax,
        data.bitsPerSample,
      ));
      switch (data.show) {
        case AdcOutputState.encoded:
          TextSpan span = TextSpan(
            style: TextStyle(color: Color.fromARGB(255, 0, 34, 91)),
            text: current,
          );
          TextPainter tp = TextPainter(
            text: span,
            textDirection: TextDirection.ltr,
          );
          tp.layout(minWidth: 30, maxWidth: size.width);
          tp.paint(canvas, point + Offset(10, -10));
          tp.dispose();
          canvas.drawLine(Offset(i, mPos), point, sampleLines);
        case AdcOutputState.quantized:
        case AdcOutputState.sampled:
          canvas.drawLine(Offset(i, mPos), point, sampleLines);
        default:
      }
    }

    switch (data.show) {
      case AdcOutputState.encoded:
      case AdcOutputState.quantized:
      case AdcOutputState.sampled:
        canvas.drawPoints(PointMode.points, points, samplePoints);
      case AdcOutputState.raw:
    }
  }

  String binaryQuantize(
    double value,
    double minValue,
    double maxValue,
    int nBits,
  ) {
    if (nBits <= 0) {
      throw ArgumentError('Number of bits must be greater than zero.');
    }
    if (minValue >= maxValue) {
      throw ArgumentError('minValue must be less than maxValue.');
    }

    double range = maxValue - minValue;
    double step = range / ((1 << nBits)); // 2^nBits - 1 levels
    int quantizedValue = ((value - (minValue + step / 2)) / step).round();

    // Ensure the quantized value is within the range
    if (quantizedValue < 0) {
      quantizedValue = 0;
    } else if (quantizedValue > ((1 << nBits) - 1)) {
      quantizedValue = ((1 << nBits) - 1);
    }

    // Convert the quantized value to binary representation
    String binaryString = quantizedValue.toRadixString(2).padLeft(nBits, '0');

    return binaryString;
  }

  void drawTimeAxis(
    Canvas canvas,
    Paint axis,
    Paint thickLine,
    Paint thinLine,
    Paint quantLinesEven,
    Paint quantLinesOdd,
    Paint quantLinesEdge,
    Size size,
    double stopT,
    double sampleRate,
    double minorTicPoints,
    double vScale,
    double pos, {
    double maxVoltage = 10,
  }) {
    // Draw Axis
    int counter = 0;
    for (double t = 0; t <= stopT; t += 1 / sampleRate) {
      double i = t * sampleRate * minorTicPoints / 100 + border;
      if (i > size.width - border + 1) {
        break;
      }
      Offset p1 = Offset(i, pos - (maxVoltage * vScale));
      Offset p2 = Offset(i, pos + (maxVoltage * vScale));
      if ((counter % 10) == 0) {
        canvas.drawLine(p1, p2, thickLine);
        TextSpan span = TextSpan(
          style: TextStyle(color: Color.fromARGB(255, 0, 34, 91)),
          text: '${counter / 10}',
        );
        TextPainter tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        );
        tp.layout(minWidth: 30, maxWidth: size.width);
        tp.paint(canvas, Offset(i - 4, pos + vScale * 11));
        tp.dispose();
      } else {
        canvas.drawLine(p1, p2, thinLine);
      }
      counter++;
    }
    for (
      double i = -maxVoltage * vScale;
      i <= maxVoltage * vScale;
      i += vScale
    ) {
      Offset p1 = Offset(border, pos + i);
      Offset p2 = Offset(size.width - border, pos + i);
      if ((i % 50) == 0) {
        canvas.drawLine(p1, p2, thickLine);
        TextSpan span = TextSpan(
          style: TextStyle(color: Color.fromARGB(255, 0, 34, 91)),
          text: '${i != 0 ? -i / vScale : 0}',
        );
        TextPainter tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
        );
        tp.layout(minWidth: 30, maxWidth: size.width);
        tp.paint(canvas, Offset(border - 35, pos + i - 9));
      } else {
        canvas.drawLine(p1, p2, thinLine);
      }
    }
    if (data.show == AdcOutputState.encoded ||
        data.show == AdcOutputState.quantized) {
      // draw quantization bins
      num N = pow(2, data.bitsPerSample);
      double delta = (data.vMax - data.vMin) * vScale / N;
      int evenodd = 0;
      for (double i = data.vMin * vScale; i < data.vMax * vScale; i += delta) {
        Offset p1 = Offset(border, pos - i);
        Offset p2 = Offset(size.width - border, pos - i - delta);
        // canvas.drawLine(p1, p2, thickLine);
        TextSpan span = TextSpan(
          style: TextStyle(color: Color.fromARGB(255, 0, 180, 0)),
          text: '${(i + delta / 2) / vScale}',
        );
        TextPainter tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
        );
        tp.layout(minWidth: 30, maxWidth: size.width);
        tp.paint(canvas, Offset(size.width - border, pos - i - delta / 2 - 9));
        // canvas.drawLine(p1, p2, quantLinesEven);
        if (evenodd % 2 == 0) {
          canvas.drawRect(Rect.fromPoints(p1, p2), quantLinesEven);
        } else {
          canvas.drawRect(Rect.fromPoints(p1, p2), quantLinesOdd);
        }
        canvas.drawRect(Rect.fromPoints(p1, p2), quantLinesEdge);
        evenodd++;
      }
    }
    // Draw y axis
    canvas.drawLine(
      Offset(border, pos - maxVoltage * vScale),
      Offset(border, pos + maxVoltage * vScale),
      axis,
    );
    // Draw x axis
    canvas.drawLine(
      Offset(border, pos),
      Offset(size.width - border, pos),
      axis,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

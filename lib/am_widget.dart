import 'dart:math';

import 'package:amgraph/am_data.dart';
import 'package:amgraph/sinusoid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

const graphWidth = 1000.0;

class AmWidget extends StatefulWidget {
  const AmWidget({super.key});

  @override
  State<AmWidget> createState() => _AmWidgetState();
}

double inputFilter(double val, double lowLimit, double highLimit) {
  if (val > highLimit) {
    val = highLimit;
  } else if (val < lowLimit) {
    val = lowLimit;
  }
  return val;
}

class _AmWidgetState extends State<AmWidget> {
  late AmData data;
  static const _scaler = TextScaler.linear(1);

  final _vmcontroller = TextEditingController();
  final _fmcontroller = TextEditingController();
  final _vccontroller = TextEditingController();
  final _fccontroller = TextEditingController();
  final _thetamcontroller = TextEditingController();
  final _thetaccontroller = TextEditingController();

  @override
  void dispose() {
    _vmcontroller.dispose();
    _fmcontroller.dispose();
    _vccontroller.dispose();
    _fccontroller.dispose();
    _thetamcontroller.dispose();
    _thetaccontroller.dispose();
    super.dispose();
  }

  double lowFreq = 0;
  double highFreq = 0;
  void updateFreqs() {
    lowFreq = data.fC - data.fM;
    highFreq = data.fC + data.fM;
  }

  @override
  void initState() {
    data = AmData();
    updateFreqs();
    _vmcontroller.text = '${data.vM}';
    _vmcontroller.addListener(() {
      double val = 0;
      try {
        val = double.parse(_vmcontroller.text);
      } catch (e) {
        return;
      }
      setState(() {
        data.vM = val;
      });
    });
    _fmcontroller.text = '${data.fM}';
    _fmcontroller.addListener(() {
      double val = 0;
      try {
        val = double.parse(_fmcontroller.text);
      } catch (e) {
        return;
      }
      setState(() {
        data.fM = val;
        updateFreqs();
      });
    });
    _vccontroller.text = '${data.vC}';
    _vccontroller.addListener(() {
      double val = 0;
      try {
        val = double.parse(_vccontroller.text);
      } catch (e) {
        return;
      }
      setState(() {
        data.vC = val;
      });
    });
    _fccontroller.text = '${data.fC}';
    _fccontroller.addListener(() {
      double val = 0;
      try {
        val = double.parse(_fccontroller.text);
      } catch (e) {
        return;
      }
      setState(() {
        data.fC = val;
        updateFreqs();
      });
    });
    _thetaccontroller.text = '${data.thetaC}';
    _thetaccontroller.addListener(() {
      double val = 0;
      try {
        val = double.parse(_thetaccontroller.text);
      } catch (e) {
        return;
      }
      setState(() {
        data.thetaC = val;
      });
    });
    _thetamcontroller.text = '${data.thetaM}';
    _thetamcontroller.addListener(() {
      double val = 0;
      try {
        val = double.parse(_thetamcontroller.text);
      } catch (e) {
        return;
      }
      setState(() {
        data.thetaM = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Text(""),
        SinusoidWidget(
          data: data,
          vController: _vmcontroller,
          fController: _fmcontroller,
          thetaController: _thetamcontroller,
          textScaler: _scaler,
          maxF: 2000,
        ),
        SinusoidWidget(
          data: data,
          vController: _vccontroller,
          fController: _fccontroller,
          thetaController: _thetaccontroller,
          signalName: 'carrier',
          subscript: 'c',
          textScaler: _scaler,
        ),
        Math.tex('m = \\frac{${data.vM}}{${data.vC}} = ${data.vM / data.vC}'),
        Divider(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: CustomPaint(
                    size: Size(graphWidth, 1100),
                    painter: _AmPainter(data),
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

const double border = 40;
const mPos = 160.0;
const cPos = 420.0;
const amPos = 700.0;

class _AmPainter extends CustomPainter {
  AmData data;
  _AmPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    double sampleRate = 44100.0;
    double points = size.width - 2 * border;
    double viewWidth = 0.01;
    double stopT = viewWidth * points / (graphWidth - 2 * border);
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
    final mLine =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color.fromARGB(100, 255, 0, 0);
    final cLine =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color.fromARGB(100, 0, 155, 0);

    final amLine =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color.fromARGB(100, 0, 0, 255);

    final axis =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color.fromARGB(200, 0, 0, 0);

    var lastam = Offset(border, amPos);
    var lastm = Offset(border, mPos);
    var lastc = Offset(border, cPos);
    // Draw Axis
    drawTimeAxis(
      canvas,
      axis,
      thickLine,
      thinLine,
      size,
      'v\u2098(t)=${data.vM} sin(2\u03c0${data.fM} + ${data.thetaM})',
      stopT,
      sampleRate,
      minorTicPoints,
      mPos,
      maxVoltage: 11.0,
    );
    drawFreqAxis(
      canvas,
      axis,
      thickLine,
      thinLine,
      size,
      mPos + 910,
      maxVoltage: 21.0,
    );
    drawTimeAxis(
      canvas,
      axis,
      thickLine,
      thinLine,
      size,
      'v\u208d(t)=${data.vC} sin(2\u03c0${data.fC}t + ${data.thetaC})',
      stopT,
      sampleRate,
      minorTicPoints,
      cPos,
      maxVoltage: 11.0,
    );
    drawTimeAxis(
      canvas,
      axis,
      thickLine,
      thinLine,
      size,
      'v\u2090\u2098(t)=${data.vC} sin(2\u03c0 ${data.fC}t) + ${data.vM / 2} sin(2\u03c0 ${data.fC - data.fM}t)  + ${data.vM / 2} sin(2\u03c0 ${data.fC + data.fM}t)',
      stopT,
      sampleRate,
      minorTicPoints,
      amPos,
      maxVoltage: 11.0,
    );
    // Draw Vam
    for (double t = 0; t <= stopT; t += 1 / sampleRate) {
      double i = t * points / stopT + border;
      double vm =
          data.vM * sin(2.0 * pi * data.fM * t + data.thetaM * pi / 180);
      double vc = sin(2.0 * pi * data.fC * t + data.thetaC * pi / 180);
      double v = -10 * (data.vC + vm) * vc;
      var currm = Offset(i, -10 * vm + mPos);
      var currc = Offset(i, -10 * data.vC * vc + cPos);
      var curram = Offset(i, v + amPos);
      if (i == border) {
        lastm = currm;
        lastc = currc;
        lastam = curram;
      }
      if (data.showModulator) {
        canvas.drawLine(lastm, currm, mLine);
        lastm = currm;
      }
      if (data.showCarrier) {
        canvas.drawLine(lastc, currc, cLine);
        lastc = currc;
      }
      if (data.showAm) {
        canvas.drawLine(lastam, curram, amLine);
        lastam = curram;
      }
    }
  }

  void drawTimeAxis(
    Canvas canvas,
    Paint axis,
    Paint thickLine,
    Paint thinLine,
    Size size,
    String xlabel,
    double stopT,
    double sampleRate,
    double minorTicPoints,
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
      Offset p1 = Offset(i, pos - (maxVoltage * 10));
      Offset p2 = Offset(i, pos + (maxVoltage * 10));
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
        tp.paint(canvas, Offset(i - 10, pos + 10 * 11));
        tp.dispose();
      } else {
        canvas.drawLine(p1, p2, thinLine);
      }
      counter++;
    }
    for (double i = -maxVoltage * 10; i <= maxVoltage * 10; i += 10) {
      Offset p1 = Offset(border, pos + i);
      Offset p2 = Offset(size.width - border, pos + i);
      if ((i % 50) == 0) {
        canvas.drawLine(p1, p2, thickLine);
        TextSpan span = TextSpan(
          style: TextStyle(color: Color.fromARGB(255, 0, 34, 91)),
          text: '${i != 0 ? -i / 10 : 0}',
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
    canvas.drawLine(
      Offset(border, pos - maxVoltage * 10),
      Offset(border, pos + maxVoltage * 10),
      axis,
    );
    canvas.drawLine(
      Offset(border, pos),
      Offset(size.width - border, pos),
      axis,
    );
    TextSpan span = TextSpan(
      style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Color.fromARGB(255, 0, 34, 91),
      ),
      text: xlabel,
    );
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 30, maxWidth: size.width);
    tp.paint(canvas, Offset(50, pos - 10 * 13));
  }

  void drawFreqAxis(
    Canvas canvas,
    Paint axis,
    Paint thickLine,
    Paint thinLine,
    Size size,
    double pos, {
    double maxVoltage = 10,
  }) {
    int counter = 0;
    for (double i = border; i <= size.width - border; i += 10) {
      Offset p1 = Offset(i, pos - (maxVoltage * 10));
      Offset p2 = Offset(i, pos);
      if ((counter % 5) == 0) {
        canvas.drawLine(p1, p2, thickLine);
      } else {
        canvas.drawLine(p1, p2, thinLine);
      }
      counter++;
    }
    for (double i = -maxVoltage * 10; i < 0; i += 10) {
      Offset p1 = Offset(border, pos + i);
      Offset p2 = Offset(size.width - border, pos + i);
      if ((i % 50) == 0) {
        canvas.drawLine(p1, p2, thickLine);
      } else {
        canvas.drawLine(p1, p2, thinLine);
      }
    }
    // Draw Axis
    canvas.drawLine(
      Offset(border, pos - maxVoltage * 10),
      Offset(border, pos),
      axis,
    );
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

import 'package:amgraph/am_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class SinusoidWidget extends StatelessWidget {
  static const _scaler = TextScaler.linear(1);
  static const _spacing = 5.0;
  const SinusoidWidget({
    super.key,
    required this.data,
    required this.vController,
    required this.fController,
    required this.thetaController,
    this.textScaler = _scaler,
    this.subscript = '\u2098',
    this.signalName = 'modulating',
  });

  final TextEditingController vController;
  final TextEditingController fController;
  final TextEditingController thetaController;
  final TextScaler textScaler;
  final String subscript;
  final String signalName;

  final AmData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: _spacing * 2,
      children: [
        Row(
          spacing: _spacing,
          children: [
            Flexible(fit: FlexFit.tight, child: Text('')),
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                controller: vController,
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  helperText: 'The $signalName signal amplitude in volts.',
                  suffix: Text('V'),
                  labelText: 'V$subscript ',
                  border: OutlineInputBorder(gapPadding: 0),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                controller: fController,
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  helperText: 'The $signalName signal frequency in Hz.',
                  suffix: Text('Hz'),
                  labelText: 'f$subscript ',
                  border: OutlineInputBorder(gapPadding: 0),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                controller: thetaController,
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  helperText: 'The $signalName phase in degrees.',
                  suffix: Text('\u00b0'),
                  labelText: '\u03b8$subscript ',
                  border: OutlineInputBorder(gapPadding: 0),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Flexible(fit: FlexFit.tight, child: Text('')),
          ],
        ),
        // Row(
        //   spacing: _spacing,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     SelectableMath.tex(
        //       'v_$subscript(t)=${vController.text} sin(2\\pi ${fController.text} t + ${thetaController.text} )',
        //       textScaleFactor: textScaler.scale(1.5),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

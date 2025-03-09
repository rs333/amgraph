import 'package:amgraph/am_data.dart';
import 'package:amgraph/utils/range_text_input_formatter.dart';
import 'package:flutter/material.dart';

typedef SinusoidChangedCallback =
    void Function(double v, double f, double theta);

void defaultChangeCallback(double v, double f, double theta) {}

class SinusoidInputWidget extends StatefulWidget {
  final SinusoidChangedCallback onChanged;
  static const _scaler = TextScaler.linear(1);
  static const _spacing = 5.0;
  const SinusoidInputWidget({
    super.key,
    required this.data,
    required this.initialValue,
    this.onChanged = defaultChangeCallback,
    this.textScaler = _scaler,
    this.subscript = '\u2098',
    this.signalName = 'modulating',
    this.minV = -10,
    this.maxV = 10,
    this.minF = 0,
    this.maxF = 100000,
    this.minTheta = -360,
    this.maxTheta = 360,
  });

  final Sinusoid initialValue;
  final TextScaler textScaler;
  final String subscript;
  final String signalName;
  final AmData data;
  final double minV;
  final double maxV;
  final double minF;
  final double maxF;
  final double minTheta;
  final double maxTheta;

  @override
  State<SinusoidInputWidget> createState() => _SinusoidInputWidgetState();
}

class _SinusoidInputWidgetState extends State<SinusoidInputWidget> {
  final TextEditingController _vController = TextEditingController();
  final TextEditingController _fController = TextEditingController();
  final TextEditingController _thetaController = TextEditingController();
  @override
  void dispose() {
    _vController.dispose();
    _fController.dispose();
    _thetaController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _vController.text = widget.initialValue.amplitude.toString();
    _fController.text = widget.initialValue.frequency.toString();
    _thetaController.text = widget.initialValue.phase.toString();
    _vController.addListener(_onChanged);
    _fController.addListener(_onChanged);
    _thetaController.addListener(_onChanged);
    super.initState();
  }

  void _onChanged() {
    try {
      double v = double.parse(_vController.text);
      double f = double.parse(_fController.text);
      double theta = double.parse(_thetaController.text);
      widget.onChanged(v, f, theta);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: SinusoidInputWidget._spacing * 2,
      children: [
        Row(
          spacing: SinusoidInputWidget._spacing,
          children: [
            Flexible(fit: FlexFit.tight, child: Text('')),
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                controller: _vController,
                inputFormatters: [
                  RangeTextInputFormatter(min: widget.minV, max: widget.maxV),
                ],
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  helperText:
                      'The ${widget.signalName} signal amplitude in volts.',
                  suffix: Text('V'),
                  labelText: 'V${widget.subscript} ',
                  border: OutlineInputBorder(gapPadding: 0),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                controller: _fController,
                inputFormatters: [
                  RangeTextInputFormatter(min: widget.minF, max: widget.maxF),
                ],
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  helperText:
                      'The ${widget.signalName} signal frequency in Hz.',
                  suffix: Text('Hz'),
                  labelText: 'f${widget.subscript} ',
                  border: OutlineInputBorder(gapPadding: 0),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                controller: _thetaController,
                inputFormatters: [
                  RangeTextInputFormatter(
                    min: widget.minTheta,
                    max: widget.maxTheta,
                  ),
                ],
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  helperText: 'The ${widget.signalName} phase in degrees.',
                  suffix: Text('\u00b0'),
                  labelText: '\u03b8${widget.subscript} ',
                  border: OutlineInputBorder(gapPadding: 0),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Flexible(fit: FlexFit.tight, child: Text('')),
          ],
        ),
      ],
    );
  }
}

import 'package:amgraph/adc_data.dart';
import 'package:amgraph/utils/range_text_input_formatter.dart';
import 'package:flutter/material.dart';

typedef AdcChangedCallback =
    void Function(double, double, double, int, AdcOutputState);

void defaultChangeCallback(
  double vmin,
  double vmax,
  double sr,
  int bps,
  AdcOutputState state,
) {}

class AdcInputWidget extends StatefulWidget {
  final AdcChangedCallback onChanged;
  static const _spacing = 5.0;
  const AdcInputWidget({
    super.key,
    required this.data,
    this.onChanged = defaultChangeCallback,
    this.minV = -10,
    this.maxV = 10,
    this.sampleRate = 0,
  });

  final AdcData data;
  final double minV;
  final double maxV;
  final double sampleRate;

  @override
  State<AdcInputWidget> createState() => _AdcInputWidgetState();
}

class _AdcInputWidgetState extends State<AdcInputWidget> {
  final TextEditingController _vMinController = TextEditingController();
  final TextEditingController _vMaxController = TextEditingController();
  final TextEditingController _fController = TextEditingController();
  final TextEditingController _bpsController = TextEditingController();

  AdcOutputState _state = AdcOutputState.raw;
  @override
  void dispose() {
    _vMinController.dispose();
    _vMaxController.dispose();
    _fController.dispose();
    _bpsController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _vMinController.text = widget.data.vMin.toString();
    _vMaxController.text = widget.data.vMax.toString();
    _fController.text = widget.data.sampleRate.toString();
    _bpsController.text = widget.data.bitsPerSample.toString();
    _vMinController.addListener(_onChanged);
    _vMaxController.addListener(_onChanged);
    _fController.addListener(_onChanged);
    _bpsController.addListener(_onChanged);
    super.initState();
  }

  void _onChanged() {
    try {
      double vmin = double.parse(_vMinController.text);
      double vmax = double.parse(_vMaxController.text);
      double sampleRate = double.parse(_fController.text);
      int bitsPerSample = int.parse(_bpsController.text);
      widget.onChanged(vmin, vmax, sampleRate, bitsPerSample, _state);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: AdcInputWidget._spacing * 2,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AdcInputWidget._spacing,
            children: [
              Expanded(child: Text('')),
              Flexible(
                fit: FlexFit.tight,
                child: TextField(
                  controller: _vMinController,
                  inputFormatters: [
                    RangeTextInputFormatter(min: widget.minV, max: widget.maxV),
                  ],
                  decoration: InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    helperText: 'The minimum raw signal input voltage.',
                    suffix: Text('V'),
                    labelText: 'Min Input Voltage',
                    border: OutlineInputBorder(gapPadding: 0),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: TextField(
                  controller: _vMaxController,
                  inputFormatters: [
                    RangeTextInputFormatter(min: widget.minV, max: widget.maxV),
                  ],
                  decoration: InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    helperText: 'The maximum raw signal input voltage.',
                    suffix: Text('V'),
                    labelText: 'Max Input Voltage',
                    border: OutlineInputBorder(gapPadding: 0),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: TextField(
                  controller: _fController,
                  inputFormatters: [
                    RangeTextInputFormatter(min: 1, max: 10000),
                  ],
                  decoration: InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    helperText:
                        'The sample frequency in Hz (samples per second).',
                    suffix: Text(' Hz'),
                    labelText: 'Sample Rate ',
                    border: OutlineInputBorder(gapPadding: 0),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: TextField(
                  controller: _bpsController,
                  inputFormatters: [RangeTextInputFormatter(min: 2, max: 5)],
                  decoration: InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(fontStyle: FontStyle.italic),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    helperText: 'Number of bits per sample',
                    suffix: Text('bits'),
                    labelText: 'Quantization Bits',
                    border: OutlineInputBorder(gapPadding: 0),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(child: Text('')),
            ],
          ),
          Row(
            spacing: 0.1,
            children: [
              Expanded(child: Text('')),
              Flexible(
                fit: FlexFit.loose,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text('Original'),
                  leading: Radio<AdcOutputState>(
                    value: AdcOutputState.raw,
                    groupValue: _state,
                    onChanged: (AdcOutputState? value) {
                      setState(() {
                        _state = value ?? AdcOutputState.raw;
                      });
                      _onChanged();
                    },
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text('Sampled'),
                  leading: Radio<AdcOutputState>(
                    value: AdcOutputState.sampled,
                    groupValue: _state,
                    onChanged: (AdcOutputState? value) {
                      setState(() {
                        _state = value ?? AdcOutputState.raw;
                      });
                      _onChanged();
                    },
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text('Quantized'),
                  leading: Radio<AdcOutputState>(
                    value: AdcOutputState.quantized,
                    groupValue: _state,
                    onChanged: (AdcOutputState? value) {
                      setState(() {
                        _state = value ?? AdcOutputState.raw;
                      });
                      _onChanged();
                    },
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text('Encoded'),
                  leading: Radio<AdcOutputState>(
                    value: AdcOutputState.encoded,
                    groupValue: _state,
                    onChanged: (AdcOutputState? value) {
                      setState(() {
                        _state = value ?? AdcOutputState.raw;
                      });
                      _onChanged();
                    },
                  ),
                ),
              ),
              Expanded(child: Text('')),
            ],
          ),
        ],
      ),
    );
  }
}

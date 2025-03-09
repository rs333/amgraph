import 'package:flutter/services.dart';

class RangeTextInputFormatter extends TextInputFormatter {
  final double min;
  final double max;

  RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return oldValue;
    }

    try {
      final double value = double.parse(newValue.text);
      if (value < min || value > max) {
        return oldValue;
      }
    } catch (e) {
      return oldValue;
    }

    return newValue;
  }
}

import 'package:flutter_test/flutter_test.dart';

import 'package:amgraph/utils/range_text_input_formatter.dart';

void main() {
  var valueThree = TextEditingValue(text: '3');
  var valueFive = TextEditingValue(text: '5');
  var valueSeven = TextEditingValue(text: '7');
  var valueEmpty = TextEditingValue(text: '');
  var valueText = TextEditingValue(text: 'a');

  test('Above Range', () {
    var uut = RangeTextInputFormatter(min: -5, max: 5);
    expect(uut.formatEditUpdate(valueThree, valueSeven), valueThree);
  });
  test('Below Range', () {
    var uut = RangeTextInputFormatter(min: 4, max: 10);
    expect(uut.formatEditUpdate(valueSeven, valueThree), valueSeven);
  });
  test('In Range', () {
    var uut = RangeTextInputFormatter(min: 4, max: 10);
    expect(uut.formatEditUpdate(valueFive, valueSeven), valueSeven);
  });
  test('Empty', () {
    var uut = RangeTextInputFormatter(min: 4, max: 10);
    expect(uut.formatEditUpdate(valueFive, valueEmpty), valueFive);
  });
  test('Text', () {
    var uut = RangeTextInputFormatter(min: 4, max: 10);
    expect(uut.formatEditUpdate(valueFive, valueText), valueFive);
  });
}

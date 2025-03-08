import 'package:amgraph/am_data.dart';
import 'package:amgraph/widgets/sinusoid_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AmData data = AmData();
  testWidgets('Initial Value', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SinusoidInputWidget(
            data: data,
            initialValue: Sinusoid(3, 4000, -45),
          ),
        ),
      ),
    );

    expect(find.widgetWithText(TextField, '4000.0'), findsOneWidget);
    expect(find.widgetWithText(TextField, '3.0'), findsOneWidget);
    expect(find.widgetWithText(TextField, '-45.0'), findsOneWidget);
  });
}

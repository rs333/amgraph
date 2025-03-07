import 'package:amgraph/am_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AmApp());
}

class AmApp extends StatelessWidget {
  const AmApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AM Simulator App',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 0, 34, 91),
          onPrimary: Color.fromARGB(255, 181, 166, 124),
          onSecondary: Color.fromARGB(255, 0, 34, 91),
          secondary: Color.fromARGB(255, 181, 166, 124),
          error: Color.fromARGB(255, 181, 166, 124),
          onError: Color.fromARGB(255, 0, 34, 91),
          surface: Colors.white,
          onSurface: Color.fromARGB(255, 0, 34, 91),
        ),
      ),
      home: const AmAppPage(title: 'AM Simulator App'),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
    );
  }
}

class AmAppPage extends StatefulWidget {
  const AmAppPage({super.key, required this.title});

  final String title;

  @override
  State<AmAppPage> createState() => _AmAppPageState();
}

class _AmAppPageState extends State<AmAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: AmWidget(),
    );
  }
}

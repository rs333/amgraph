import 'package:amgraph/mixins/metadata_mixin.dart';
import 'package:amgraph/widgets/adc_widget.dart';
import 'package:amgraph/widgets/am_widget.dart';
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
      title: 'Training Aids',
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
      home: const AmAppPage(title: 'Training Aids'),
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
  Metadata _panel = AdcWidget();
  late String _title;

  @override
  void initState() {
    _title = _panel.heading;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Metadata> widgetList = [AmWidget(), AdcWidget()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.title} - $_title'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: const Text("Training Aid Options"),
            ),
            for (var i = 0; i < widgetList.length; i++)
              ListTile(
                title: Text(widgetList[i].heading),
                onTap: () {
                  setState(() {
                    _panel = widgetList[i];
                    _title = widgetList[i].heading;
                  });

                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: _panel,
    );
  }
}

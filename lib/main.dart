import 'package:diffusion/difussion.dart';
import 'package:flutter/material.dart';
import 'widgets/plot.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

void main() {
  runApp(MyApp());
  //Declare Variables
  //Function Call and Passing values
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Difusión de calor',
      themeMode: ThemeMode.system,
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      home: MyHomePage(title: 'Difusión de calor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurpleAccent,
      ));

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color.fromARGB(255, 54, 54, 54),
      colorScheme: const ColorScheme.dark(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 22, 22, 22),
      ));
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  BottomDrawerController controller = BottomDrawerController();
  int _selectDrawerItem = 0;
  _getDrawerIitemWidget(int pos) {
    switch (pos) {
      case 0:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  'Explicit method',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              //PlotDifusion(explicit_diffusion(_counter, 48)),
              PlotDifusion(explicit_diffusion(_counter, 48)),
              Text(
                'Temperature evolution after $_counter hours',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton(
                  onPressed: () {
                    _counter = 1;
                    setState(() {
                      //PlotDifusion(explicit_diffusion(_counter, 48));
                      PlotDifusion(explicit_diffusion(_counter, 480));
                    });
                  },
                  child: Text('Reset counter')),
            ],
          ),
        );
      case 1:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  'Implicit method',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              //PlotDifusion(explicit_diffusion(_counter, 48)),
              PlotDifusion(implicit_diffusion(_counter, 48)),
              Text(
                'Temperature evolution after $_counter hours',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton(
                  onPressed: () {
                    _counter = 1;
                    setState(() {
                      //PlotDifusion(explicit_diffusion(_counter, 48));
                      PlotDifusion(implicit_diffusion(_counter, 48));
                    });
                  },
                  child: Text('Reset counter')),
            ],
          ),
        );
    }
  }

  _onSelectItem(int pos) {
    setState(() {
      _selectDrawerItem = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<FlSpot> spots = diffusion();
    // var mapa = diffusion;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 145, 37, 175),
              ),
              child: Center(
                child: Text(
                    '1d Diffusion heat exercise. Default parameters:\n K=1e-6  L = 100 \n W = 5.0 R = 300.0\n D = 1200.0'),
              ),
            ),
            ListTile(
              title: const Text('Explicit Method'),
              leading: const Icon(Icons.insights_outlined),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                _onSelectItem(0);
                Navigator.pop(context);
                return;
              },
            ),
            ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Implicit Method'),
              onTap: () {
                _onSelectItem(1);
                Navigator.pop(context);
                // Update the state of the app
                // ...
                // Then close the drawer
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // title: Center(child: Text(widget.title)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../assets/images/escudo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text('1d Heat Diffusion'))
          ],
        ),
      ),
      body: _getDrawerIitemWidget(_selectDrawerItem),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

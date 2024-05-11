
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//run app
void main() {
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //initial counter value
  int _counter = 0;
  bool _vibrates = false;
  //setup methodChannel
  final channel = MethodChannel('com.rectify.watch');

  //gets called after the button in the ContentView or FlutterView is pressed
  Future<void> _incrementCounter() async {
    setState(() {
      //add 1 to the counter variable
      _counter++;
    });

    // Send data to Native
    await channel.invokeMethod(
        "flutterToWatch", {"method": "sendDataToNative", "data": _counter});
  }
  Future<void> _toggleVibrates() async {
    setState(() {
      //add 1 to the counter variable
      _vibrates = !_vibrates;
    });

    // Send data to Native
    await channel.invokeMethod(
        "flutterToWatch", {"method": "sendDataToNative", "data": _counter});
  }


  // Function for recieving Data from Native
  Future<void> _initFlutterChannel() async {
    /*await*/ channel.setMethodCallHandler((call) async {
      //if the AppDelegate sends data to Flutter
      switch (call.method) {
        case "sendDataToFlutter":
          _counter = call.arguments["data"]["counter"];
          _incrementCounter();
          //exit func
          break;
        case "syncRequest":
          await channel.invokeMethod(
          "flutterToWatch", {"method": "sendDataToNative", "data": _counter});
          break;
        case "vibratesToFlutter":
          _toggleVibrates();
          break;

        //do nothing if it's shouldn't be recieved (declared on the iOS Side)
        default:
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //calls methodChannel for recieving Data from Native
    _initFlutterChannel();
    channel.invokeMethod(
        "flutterToWatch", {"method": "sendDataToNative", "data": _counter});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _vibrates ? "Vibrates ist true" : "Vibrates ist false",
            ),
            //Display Counter
            Text(
              "$_counter",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

      //button that calls "_incrementCounter" on press
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
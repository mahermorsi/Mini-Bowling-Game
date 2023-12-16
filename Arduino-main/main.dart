//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async' show Future;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';

// import 'package:firebase_database/firebase_database.dart';
// import 'data/message.dart';
// import 'data/message_dao.dart';
// import 'package:flutter/services.dart' show rootBundle;
//import 'dart:io';

List<bool>  press_at = [true,true,true,true,true,true,true,true,true,true,true,true,true,true];

int _counter  = 10;

bool _offlimits = false;

bool _validusername1  = false;
bool _validusername2  = false;

String _latestUsername1 = "";
String _latestUsername2 = "";

String _users = "";

List<String> classic_layout_list = ["13","10","9","7","6","5","4","3","2","1"];
List<String> star_layout_list = ["14","12","11","10","9","8","7","5","4","1"];
List<String> hard_layout_list = ["14","12","11","8","7","5","4","3","2","1"];
List<String> semi_classic_layout_list = ["6","4","3","2","1"];
List<int> costume_layout_list = [];
List<String> current_layout = [];

///WiFi setup
var client = new http.Client();
Timer? _timer;
Timer? _score_timer;
int x = 100 ;

///Score Setup
int turn = 0;
int round = 0;
int shoot = 0;
const int MAX_ROUNDS = 4;
const int SCORE_AVA = 100;
const int SCORE_NOT_AVA = 199;
List<String> scores1 = ["","","","",""];
List<String> scores2 = ["","","","",""];
List<int> total_score1 = [0,0,0,0,0];
List<int> total_score2 = [0,0,0,0,0];
int last_current_score = 0;
bool win = false;
String _winner = "";
bool tie = false;
///

void sendLayoutToArduino() async{

  for(int i = 0 ;i <10;i++){
    print(current_layout[i]);
    http.Response response = await client.get(Uri.parse('http://192.168.4.1/' + current_layout[i]));
    Timer(Duration(seconds: 2),() => {});
    print(response.statusCode);
  }

  //client.close();
}

/// file system for the application
// class UserNameStorage {
//
//   //file path
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//
//     return directory.path;
//   }
//
// //file name
//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/tmp.txt');
//   }
//
//   Future<String> readUsers() async {
//     try {
//       final file = await _localFile;
//
//       // Read the file
//       final contents = await file.readAsString();
//
//       return contents.toString();
//     } catch (e) {
//       // If encountering an error, return 0
//       return "";
//     }
//   }
//
//   Future<File> writeUser(String name) async {
//     final file = await _localFile;
//
//     // Write the file
//     return file.writeAsString(name,);
//     /// for cleaning the file system
//     //return file.writeAsString( name);
//   }
// }
///
///

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final FirebaseApp app = await Firebase.initializeApp();
  runApp( MaterialApp(
    title: 'Flutter Demo',
    home: MyHomePage(title: 'Flutter Demo Home Page'),
    theme: ThemeData(primaryColor: Colors.blue),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home:  MyHomePage(title: 'Flutter Demo Home Page',storge: UserNameStorage(),),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key,required this.title}) : super(key: key);

  final String title;

  @override
  _UserLogin createState() =>_UserLogin();
}

/// page 1
//user login page

/// change war made here in NAVIGATOR.
class _UserLogin extends State<MyHomePage>{
  final controllerUsername1 = TextEditingController();
  final controllerUsername2 = TextEditingController();
  bool isLoggedIn = false;
  @override
  void initState()  {
    super.initState() ;
    controllerUsername1.addListener(_updateLatestValue1);
    controllerUsername2.addListener(_updateLatestValue2);
  }

  Future<void> _doUserLogin() async{
    isLoggedIn = true;
    //MyHomePageV1
    Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePageV1() ) );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    controllerUsername1.dispose();
    controllerUsername2.dispose();
    super.dispose();
  }

  void _updateLatestValue1() {
    _latestUsername1 = controllerUsername1.text;
    bool _used  = false;

    if(_latestUsername1.isEmpty){
      setState(() {
        _validusername1 = false;
      });
    }

    if(_used){
      setState(() {
        _validusername1 = false;
      });
    }

    else {
      setState(() {
        _validusername1 = true;
      });
    }
  }

  void _updateLatestValue2() {
    _latestUsername2 = controllerUsername2.text;
    bool _used  = false;

    if(_latestUsername2.isEmpty ){
      setState(() {
        _validusername2 = false;
      });
    }

    if(_used){
      setState(() {
        _validusername2 = false;
      });
    }

    else {
      setState(() {
        _validusername2 = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text("User Login/Logout"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(children: <Widget>[
            ElevatedButton(
              //your name is all ready used or too short, please try again !
              child: new Text("one of the names is all ready used or it's too short",style : TextStyle(color: ((!_validusername1) || (!_validusername2)|| (_latestUsername1 == _latestUsername2) ) ? Colors.redAccent: Colors.blueAccent,fontSize: 20.0)),
              onPressed: (){},
              style: ElevatedButton.styleFrom(primary: Colors.blueAccent,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                  minimumSize: Size(400,100)
              )),
            TextField(
              controller: controllerUsername1,
              enabled: !isLoggedIn,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)), labelText: 'First Username'),
                ),
            TextField(
            controller: controllerUsername2,
            enabled: !isLoggedIn,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
            decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)), labelText: 'Second Username'),
          ),
            Container(
              height: 50,
              child: TextButton(
                child: const Text('Login',style: TextStyle(color: Colors.black,fontSize: 25.0)),
                onPressed:(_validusername1 && _validusername2 && (_latestUsername1 != _latestUsername2)) ?   _doUserLogin : null,
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(250 ,200)
                  )
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,),
      ),
    );
  }
}

//layout page
/// page 2
class MyHomePageV1 extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

/// add the second player
class _MyHomePageState extends State<MyHomePageV1> {
  @override
  Widget build(BuildContext context) {return Scaffold(
    backgroundColor: Colors.blueAccent,
    appBar: AppBar(
      title: Text('wellcome $_latestUsername1 and $_latestUsername2 \nplease choose the game layout !',style: TextStyle(color: Colors.white,fontSize: 15.0,decorationThickness: 20.0)),
      centerTitle: true,
      backgroundColor: Colors.blue,
    ),
    body: Center(child: Column(children: [
      ElevatedButton(
        onPressed: () {  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MyHomeSemiClassic()),
        );},
        child: Text('Semi Classic layout'),
        style: ElevatedButton.styleFrom(primary: Colors.red,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(300,70)
        ),
      ),
      ElevatedButton(
        onPressed: () {  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MyHomeClassic()),
        );},
        child: Text('Classic layout'),
        style: ElevatedButton.styleFrom(primary: Colors.blueGrey,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(300,70)
        ),
      ),
      ElevatedButton(
        onPressed: () {  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MyHomeStar()),
        );},
        child: Text('Star layout'),
        style: ElevatedButton.styleFrom(primary: Colors.blueGrey,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(300,70)
        ),
      ),
      ElevatedButton(
        onPressed: () {  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MyHomeHard()),
        );},
        child: Text('Hard layout'),
        style: ElevatedButton.styleFrom(primary: Colors.blueGrey,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(300,70)
        ),
      ),
      ElevatedButton(
        onPressed: () {  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MyHome()),
        );},
        child: Text('Costume layout'),

        style: ElevatedButton.styleFrom(primary: Colors.blueGrey,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(12),
          ),
            minimumSize: Size(300,70)
        ),
      )
    ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),),
  );
  }
}

/// page 3 (Classic)
class MyHomeClassic extends StatelessWidget{
  const MyHomeClassic({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          title:Text("Classic layout"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(child: Column(children: <Widget>[
          //ROW0.1
          Row(children: [
            IconButton(
                alignment: Alignment.topCenter,
                onPressed: () {current_layout = classic_layout_list;
                sendLayoutToArduino();
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyHomeWaiting()),);},
                icon: const Icon(Icons.check_circle,color: Colors.green,size: 60.0,),
                tooltip: "press to start",
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,),
          //ROW1
          Row(children: [
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          //ROW2
          Row(children: [
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,),
          //ROW3
          Row(children: [

            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),

          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,),
          //ROW4
          Row(children: [
            //13
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),

          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,)
        ],

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
          ,));

    //   appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     // Center is a layout widget. It takes a single child and positions it
    //     // in the middle of the parent.
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Invoke "debug painting" (press "p" in the console, choose the
    //       // "Toggle Debug Paint" action from the Flutter Inspector in Android
    //       // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
    //       // to see the wireframe for each widget.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}

/// page 3 (Semi Classic)
class MyHomeSemiClassic extends StatelessWidget{
  const MyHomeSemiClassic({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          title:Text("Semi Classic layout"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(child: Column(children: <Widget>[
          //ROW0.1
          Row(children: [
            IconButton(
              alignment: Alignment.topCenter,
              onPressed: () {current_layout = semi_classic_layout_list;
              sendLayoutToArduino();
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyHomeWaiting()),);},
              icon: const Icon(Icons.check_circle,color: Colors.green,size: 60.0,),
              tooltip: "press to start",
            ),
          ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,),
          //ROW1
          Row(children: [
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          //ROW2
          Row(children: [
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,),

        ],

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
          ,));

    //   appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     // Center is a layout widget. It takes a single child and positions it
    //     // in the middle of the parent.
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Invoke "debug painting" (press "p" in the console, choose the
    //       // "Toggle Debug Paint" action from the Flutter Inspector in Android
    //       // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
    //       // to see the wireframe for each widget.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}

/// page 3 (star)
class MyHomeStar extends StatelessWidget{
  const MyHomeStar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          title:Text('Star Layout'),
          centerTitle: true,
          backgroundColor: Colors.blue,

        ),
        body: Center(child: Column(children: <Widget>[
          //ROW0.1
          Row(children: [
            IconButton(
              alignment: Alignment.topCenter,
              onPressed: () {  current_layout = star_layout_list;
                sendLayoutToArduino();
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyHomeWaiting()),
              );},
              icon: const Icon(Icons.check_circle,color: Colors.green,size: 60.0,),
              tooltip: "press to start",
            ),
          ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,),
          //ROW1
          Row(children: [
            //1
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            //4
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          //ROW2
          Row(children: [
            //5
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            //7
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,),
          //ROW3
          Row(children: [

            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),

          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,),
          //ROW4
          Row(children: [
            //12
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            //14
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
        ],

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
          ,));

    //   appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     // Center is a layout widget. It takes a single child and positions it
    //     // in the middle of the parent.
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Invoke "debug painting" (press "p" in the console, choose the
    //       // "Toggle Debug Paint" action from the Flutter Inspector in Android
    //       // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
    //       // to see the wireframe for each widget.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}

/// page 3 (hard)
class MyHomeHard extends StatelessWidget{
  const MyHomeHard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          title:Text('Hard Layout'),
          centerTitle: true,
          backgroundColor: Colors.blue,

        ),
        body: Center(child: Column(children: <Widget>[
          //ROW0.1
          Row(children: [
            IconButton(
              alignment: Alignment.topCenter,
              onPressed: () {  current_layout = hard_layout_list;
                sendLayoutToArduino();
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyHomeWaiting()),
              );},
              icon: const Icon(Icons.check_circle,color: Colors.green,size: 60.0,),
              tooltip: "press to start",
            ),
          ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,),
          //ROW1
          Row(children: [
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          //ROW2
          Row(children: [
            //5
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            //7
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,),
          //ROW3
          Row(children: [
            //8
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            //11
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),

          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          //ROW4
          Row(children: [
            //12
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
            //14
            ElevatedButton(
              child: Text("",style : TextStyle(color: Colors.black)),
              onPressed: (){},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.blueGrey; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(30))
              ),
            ),
          ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
        ],

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
          ,));

    //   appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     // Center is a layout widget. It takes a single child and positions it
    //     // in the middle of the parent.
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Invoke "debug painting" (press "p" in the console, choose the
    //       // "Toggle Debug Paint" action from the Flutter Inspector in Android
    //       // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
    //       // to see the wireframe for each widget.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}

/// page 3 (Costume)
class MyHome extends StatefulWidget {
  @override
  MyHomePageStateLayout createState() => new MyHomePageStateLayout();
}
//costume layout page
class MyHomePageStateLayout extends State<MyHome> {

  void _UpdateCounter(bool pressed,int cell_number){
    if(_counter > 10){
      setState(() {_counter = 10;});
      return;
    }
    if(_counter == 0){
      setState(() {_offlimits =! _offlimits;});
      return;
    }
    if(pressed){
      setState(() {_counter --;costume_layout_list.add(cell_number);});
      return;
    }
    else{
      setState(() {_counter ++;costume_layout_list.remove(cell_number);});
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title:Text('Choose 10 cells to insert the pins'),
        centerTitle: true,
        backgroundColor: Colors.blue,

      ),
      body: Center(child: Column(children: <Widget>[
        //ROW 0.1
        Row(children: [
          Text("You need to choose "),
          new Text('$_counter',style: Theme.of(context).textTheme.bodyText1),
          Text(" more locations"),
          IconButton(
            alignment: Alignment.topCenter,
            onPressed: (! _offlimits) && _counter == 0 ?() {
              costume_layout_list.sort();
              var x  =  costume_layout_list.reversed.map((e) => e.toString());
              current_layout = x.toList(growable: false);
              sendLayoutToArduino();
              Navigator.push(context, MaterialPageRoute(builder: (context) =>   scorePage()),
            );}:null,
            icon: Icon(Icons.check_circle,color: (! _offlimits) && _counter == 0 ? Colors.green:Colors.red,size: 60.0,),
            tooltip: "press to start",
          ),
        ]
          ,mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.center,),
        //ROW 0.2
        Row(children: [
          ElevatedButton(
            child: Text("YOU INSERTED TOO MANY LOCATIONS !",style : TextStyle(color: _offlimits ? Colors.red: Colors.blueAccent)),
            onPressed: (){},
            style: ElevatedButton.styleFrom(primary: Colors.blueAccent,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(150,70)
            )),
        ],mainAxisAlignment: MainAxisAlignment.center,),
        //ROW1
        Row(children: [
          ElevatedButton(
            child: Text("1",style : TextStyle(color: Colors.black)),
            onPressed: (){print("1");_UpdateCounter(press_at[0],1);press_at[0] =! press_at[0];},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (press_at[0])
                    return Colors.white;
                  return Colors.blueGrey; // Use the component's default.
                },
              ),
              shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
              padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("2",style : TextStyle(color: Colors.black)),
            onPressed: (){print("2");_UpdateCounter(press_at[1],2);press_at[1] =! press_at[1];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[1])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("3",style : TextStyle(color: Colors.black)),
            onPressed: (){print("3");_UpdateCounter(press_at[2],3);press_at[2] =! press_at[2];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[2])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("4",style : TextStyle(color: Colors.black)),
            onPressed: (){print("4");_UpdateCounter(press_at[3],4);press_at[3] =! press_at[3];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[3])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,),
        //ROW2
        Row(children: [
          ElevatedButton(
            child: Text("5",style : TextStyle(color: Colors.black)),
            onPressed: (){print("5");_UpdateCounter(press_at[4],5);press_at[4] =! press_at[4];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[4])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("6",style : TextStyle(color: Colors.black)),
            onPressed: (){print("6");_UpdateCounter(press_at[5],6);press_at[5] =! press_at[5];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[5])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("7",style : TextStyle(color: Colors.black)),
            onPressed: (){print("7");_UpdateCounter(press_at[6],7);press_at[6] =! press_at[6];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[6])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
        ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,),
        //ROW3
        Row(children: [
          ElevatedButton(
            child: Text("8",style : TextStyle(color: Colors.black)),
            onPressed: (){print("8");_UpdateCounter(press_at[7],8);press_at[7] =! press_at[7];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[7])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("9",style : TextStyle(color: Colors.black)),
            onPressed: (){print("9");_UpdateCounter(press_at[8],9);press_at[8] =! press_at[8];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[8])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("10",style : TextStyle(color: Colors.black)),
            onPressed: (){print("10");_UpdateCounter(press_at[9],10);press_at[9] =! press_at[9];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[9])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("11",style : TextStyle(color: Colors.black)),
            onPressed: (){print("11");_UpdateCounter(press_at[10],11);press_at[10] =! press_at[10];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[10])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
        ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,),
        //ROW4
        Row(children: [
          ElevatedButton(
            child: Text("12",style : TextStyle(color: Colors.black)),
            onPressed: (){print("12");_UpdateCounter(press_at[11],12);press_at[11] =! press_at[11];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[11])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("13",style : TextStyle(color: Colors.black)),
            onPressed: (){print("13");_UpdateCounter(press_at[12],13);press_at[12] =! press_at[12];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[12])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
          ElevatedButton(
            child: Text("14",style : TextStyle(color: Colors.black)),
            onPressed: (){print("14");_UpdateCounter(press_at[13],14);press_at[13] =! press_at[13];},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (press_at[13])
                      return Colors.white;
                    return Colors.blueGrey; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(side:BorderSide(color: Colors.blueGrey,width: 10))),
                padding: MaterialStateProperty.all(EdgeInsets.all(30))
            ),
          ),
        ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
      ],

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
        ,));

    //   appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     // Center is a layout widget. It takes a single child and positions it
    //     // in the middle of the parent.
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Invoke "debug painting" (press "p" in the console, choose the
    //       // "Toggle Debug Paint" action from the Flutter Inspector in Android
    //       // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
    //       // to see the wireframe for each widget.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}

///page 4 (Waiting)
class MyHomeWaiting extends StatefulWidget{
  const MyHomeWaiting({Key? key}) : super(key: key);
  @override
  MyHomeWaitingState createState() => new MyHomeWaitingState();
}
class MyHomeWaitingState extends State<MyHomeWaiting>{

  @override
  void initState() {
    _timer =  Timer(Duration(seconds: 30
    ),() => wait4Layout());
  }

  void wait4Layout()  {
      _timer?.cancel();
      Navigator.push(context, MaterialPageRoute(builder: (context) => scorePage()),);
  }

  @override
  void dispose() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,

      body: Center(child: Column(children: [
        Text("Please wait until the pins are \nin the correct locations !",style: TextStyle(color: Colors.white,fontSize: 40.0),),
        SpinKitThreeBounce(color: Colors.white,size: 60,)
      ],mainAxisAlignment: MainAxisAlignment.center,),),
    );
  }
}

///page 5 (score)
class scorePage extends StatefulWidget{
  @override
  scorePageState createState() => new scorePageState();
}

class scorePageState extends State<scorePage>{
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _score_timer =  Timer.periodic(Duration(seconds: 5),(Timer t) => getScore());
  }

  /// CHECK WINNER!
  Future<void> getScore() async {

    if(win || tie || (round == MAX_ROUNDS && turn == 0 && shoot == 0)){
      _score_timer?.cancel();
      return;
    }

    int s = shoot%2;
    print('http://192.168.4.1/x'+ s.toString());
    http.Response response = await client.get(Uri.parse('http://192.168.4.1/x'+ s.toString()));
    print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \n");
    print(response.statusCode);
    if(response.statusCode > SCORE_NOT_AVA && response.statusCode < 211) {
        int sc = response.statusCode - 200;
        UpdateScores(sc);
    }
  }

  void UpdateScores(int curr_score){
    setState((){
      if(shoot%2 == 1 ){
        int new_score = last_current_score + curr_score;
        UpdateScoreDisplay(new_score,curr_score);

        turn = 1 - turn;
        shoot = shoot + 1;
      }else{
        last_current_score = curr_score;
        UpdateScoreDisplay(curr_score,-1);
        shoot = shoot + 1;
      }
    });
  }

  void UpdateScoreDisplay(int new_score,int last_one){
    print("XXXXXXXXXXXXXX \n");
    print(new_score);
    String s = "";
    if(last_one != -1){
      s = last_one.toString();
    }
    setState((){
      if(shoot%2 == 1){
        if(turn == 0){
          scores1[round] += ", ";
          scores1[round] += s;
          scores1[round] += " :=>";
          scores1[round] += new_score.toString();
          total_score1[round] = new_score;
        }else{
          scores2[round] += ", ";
          scores2[round] += s;
          scores2[round] += " :=> ";
          scores2[round] += new_score.toString();
          total_score2[round] = new_score;
          round = round +1;
          if(round == MAX_ROUNDS){
            UpdateTotalScoreDisplay();
            //checkWinner();
          }
        }
      }else{
        //shoot%2 == 0
        if(turn == 0){
            scores1[round] += new_score.toString();
        }else{
            scores2[round] += new_score.toString();
        }
      }
    });
  }

  void checkWinner(){
    int t_score1 = total_score1[MAX_ROUNDS];
    int t_score2 = total_score1[MAX_ROUNDS];
    if(round > 3 && shoot%2 == 1 && turn == 1){
      setState(() {
        if(t_score1 == t_score1){
          tie = true;
        }
        else{
          win = true;
          if(t_score1 > t_score2){
            _winner = _latestUsername1;
          }else{
            _winner = _latestUsername2;
          }
        }
      });
    }
  }

  void UpdateTotalScoreDisplay(){
    int t_score1 = 0;
    int t_score2 = 0;
    for(int i  = 0; i < MAX_ROUNDS; i++){
      t_score1 += total_score1[i];
      t_score2 += total_score2[i];
    }
    setState((){
      total_score1[MAX_ROUNDS] = t_score1;
      total_score2[MAX_ROUNDS] = t_score2;
      scores1[MAX_ROUNDS] += t_score1.toString();
      scores2[MAX_ROUNDS] += t_score2.toString();
      if(t_score1 == t_score1){
        tie = true;
      }
      else{
        win = true;
        if(t_score1 > t_score2){
          _winner = _latestUsername1;
        }else{
          _winner = _latestUsername2;
        }
      }
    });
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _score_timer?.cancel();
    //super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,

      body: Center(child: Column(children: [

        Text("SCORE TABLE",style: TextStyle(color: Colors.white,fontSize: 20.0),),
        Table(border: TableBorder.all(),columnWidths: const <int,TableColumnWidth>{
          0:IntrinsicColumnWidth(),
        },
            children: [
            // COL NAMES
            TableRow(children: <Widget> [
              //Text('$_latestUsername ',style: TextStyle(color: Colors.white,fontSize: 15.0,decorationThickness: 20.0))
              Center(child:TableCell(child:SizedBox(height: 35,child: Text("Player",style: TextStyle(color: Colors.black,fontSize: 20)))  )),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text("Round 1",style: TextStyle(color: Colors.black,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text("Round 2",style: TextStyle(color: Colors.black,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text("Round 3",style: TextStyle(color: Colors.black,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text("Round 4",style: TextStyle(color: Colors.black,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text("Total Score",style: TextStyle(color: Colors.black,fontSize: 20)),),)),),
            ]),

            // scores for the first player
            TableRow(children: <Widget> [
              //Text('$_latestUsername ',style: TextStyle(color: Colors.white,fontSize: 15.0,decorationThickness: 20.0))
              Center(child:TableCell(child:SizedBox(height: 35,child: Text("$_latestUsername1",style: TextStyle(color: Colors.cyan,fontSize: 20)))  )),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores1[0],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores1[1],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores1[2],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores1[3],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores1[4],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
              ]),

            //score for the second player
            TableRow(children: <Widget> [
              //Text('$_latestUsername ',style: TextStyle(color: Colors.white,fontSize: 15.0,decorationThickness: 20.0))
              Center(child:TableCell(child:SizedBox(height: 35,child: Text("$_latestUsername2",style: TextStyle(color: Colors.cyan,fontSize: 20)))  )),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores2[0],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores2[1],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores2[2],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores2[3],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
              Expanded(flex:2,child:Center(child:TableCell(child: SizedBox(height: 35,child: Text(scores2[4],style: TextStyle(color: Colors.red,fontSize: 20)),),)),),
            ])

            ]),
        //Winer
        Text("IT'S A TIE!",style:TextStyle(color: tie?Colors.red :Colors.blueAccent,fontSize: 50)),
        Text("$_winner WINS!",style: TextStyle(color: win?Colors.red:Colors.blueAccent,fontSize: 50),)
        ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
      ,)
    );
  }
}
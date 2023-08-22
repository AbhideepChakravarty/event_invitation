import 'dart:math';

import 'package:event_invitation/navigation/router_deligate.dart';
import 'package:event_invitation/services/invitation/invitation_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'navigation/nav_data.dart';
import 'navigation/path_parser.dart';
import 'ui/helpers/theme/mytheme.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventAppRouterDelegate>(create: (context) {
          return EventAppRouterDelegate(
            navData: EventAppNavigatorData.login({}),
          );
        }),
        ChangeNotifierProvider<ThemeChanger>(create: (_) {
          ThemeChanger themeChanger = ThemeChanger();
          themeChanger.themeData = DefaultTheme().buildTheme();
          return themeChanger;
        }),
        ChangeNotifierProvider<InvitationProvider>(create: (_) {
          InvitationProvider invitationProvider = InvitationProvider();
          return invitationProvider;
        }),
        /*ChangeNotifierProvider<FoodItemTilePreviewData>(
            create: (_) => FoodItemTilePreviewData()),
        StreamProvider<RemoteMessage?>(
          create: (context) => FirebaseMessaging.onMessage,
          initialData: null,
        )*/
      ],
      child: FutureBuilder<User?>(
          future: FirebaseAuthHelper().auth.userChanges().first,
          builder: (context, crd) {
            if (crd.connectionState == ConnectionState.done) {
              if (crd.hasData && !crd.data!.isAnonymous) {
                print("Non anon user found." + crd.data!.email.toString());
                //_loadUserData(crd);

                return _getBody(context);
              } else {
                print("No user found.");
                return FutureBuilder<User?>(
                    future: FirebaseAuthHelper().signInAnonymously,
                    builder: (context, crd) {
                      Widget widget;
                      if (crd.hasData) {
                        print("Anon logged in..");
                        widget = _getBody(context);
                      } else {
                        print("Logging in......");
                        widget = const Center(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return widget;
                    });
              }
            } else {
              print("Finding user ......");
              return const Center(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            //return widget;
          }),
    );
  }

  MaterialApp _getBody(BuildContext context) {
    print("App body started now.");
    final themeChanger = Provider.of<ThemeChanger>(context);
    final delegator = Provider.of<EventAppRouterDelegate>(context);
    print("App loading = " + delegator.navData.toString());
    return MaterialApp.router(
      title: 'Occurr',
      theme: themeChanger.getTheme,
      debugShowCheckedModeBanner: false,
      routerDelegate: delegator,
      routeInformationParser: EventAppRouteParser(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

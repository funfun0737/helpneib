import 'package:flutter/material.dart';
//import 'package:map_view/map_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'helpNeighborPage.dart';

import 'helpMePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Help Neib',
        home: new HelpMePageLayout(),
        theme: new ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.blueGrey,
        ),
        onGenerateRoute: (RouteSettings settings) {
          // ignore: missing_return
          switch (settings.name) {
            case '/m':
              return new MyCustomRoute(
                builder: (_) => new HelpMePageLayout(),
                settings: settings,
              );

            case '/n':
              return new MyCustomRoute(
                builder: (_) => new HelpNeighborPageLayout(),
                settings: settings,
              );
            default:
              return null;
          }
        });
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}

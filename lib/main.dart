//import 'dart:js';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

//main() function. In its current form, 
//it only tells Flutter to run the app defined in MyApp.
void main() {
  runApp(const MyApp());
}

//Widgets are the elements from which you build every Flutter app. 
//As you can see, even the app itself is a widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), //this affect to the whole app 
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//The "MyAppState" class defines the app's...well...state.
//There are many powerful ways to manage app state in Flutter. 
//One of the easiest to explain is "ChangeNotifier", the approach taken by this app.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  //Add "getNext" method
  void getNext() {
    current = WordPair.random();
    notifyListeners(); //a method of ChangeNotifier and it's ensures that anyone watching MyAppState is notified.
  }

  //Adding a functionality -> Add the business logic
  var favorites = <WordPair>[]; //added a new property to "MyAppState" called favorites and it initialzed with an empty list[].


  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

//Add Navigation rail
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//The underscore(_) at the start of _MyHomePageState makes that class private and is enforced by the compiler.
class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: const Text('Like'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


//automatically created the new "BigCard" class
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    //Theme and Style
    final theme = Theme.of(context); //this code request the app's current theme with Theme.of(context)

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0), //Wrap with Padding - return "Text(pair.asLowerCase);" code
        
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", //Improve Accessibility
          ),
      ),
    );
  }
}
/*
1. Every widget defines a build() method that's automatically called every time 
the widget's circumstances change so that the widget is always up to date.
2. MyHomePage tracks changes to the app's current state using the watch method.
3. Every build method must return a widget or (more typically) a nested tree of widgets. 
In this case, the top-level widget is Scaffold. 
You aren't going to work with Scaffold in this codelab, but it's a helpful widget 
and is found in the vast majority of real-world Flutter apps.
4. Column is one of the most basic layout widgets in Flutter. It takes any number of children 
and puts them in a column from top to bottom. By default, the column visually places 
its children at the top. You'll soon change this so that the column is centered.
5. You changed this Text widget in the first step.
6. This second Text widget takes appState, and accesses the only member of that class, 
current (which is a WordPair). WordPair provides several helpful getters, 
such as asPascalCase or asSnakeCase. Here, we use asLowerCase but you can change this now 
if you prefer one of the alternatives.
7. Notice how Flutter code makes heavy use of trailing commas. 
This particular comma doesn't need to be here, because children is the last (and also only) 
member of this particular Column parameter list. Yet it is generally a good idea to use trailing 
commas: they make adding more members trivial, and they also serve as a hint for 
Dart's auto-formatter to put a newline there. For more information, see Code formatting.
*/
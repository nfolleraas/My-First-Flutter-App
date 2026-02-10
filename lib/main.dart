import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// First thing that runs. Just like Main() in C#
void main() {
  runApp(MyApp()); // simply runs the app specified in runApp()
}

// Sets up the whole app. Like title, theme and color scheme.
class MyApp extends StatelessWidget { // The entire app is a stateless widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My First Flutter App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// Defines the app's state. In this case a simple variable.
class MyAppState extends ChangeNotifier { // ChangeNotifier is kinda like OnPropertyChanged() from C#. It notifies widgets when the state changes.
  var current = WordPair.random(); // Generates a random wordpair

  // Reassigns current to a new random wordpair and notfies listeners of the changes
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { // Gets called everytime the widget's circumstances change
    var appState = context.watch<MyAppState>(); // uses watch<T>() to track the current app state
    var pair = appState.current; // Separates the appstate to a new variable in order to scope only what it needs

    // build() must return a widget (or a nested tree of widgets - Scaffold)
    return Scaffold(
      body: Column( // A column... duhh ¯\_(ツ)_/¯. By default children are placed at the top of the window.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ // list of children
          Text('A randomly generated idea:'), 
          BigCard(pair: pair), // takes the current random wordpair and displays it as a Text widget. Text no longer refers to the entire appState, and only what it needs

          ElevatedButton(
            onPressed: () { // no argument anonymous method??
              appState.getNext();
            },
            child: Text('Next'), // single child
          ),
        ], // Flutter heavily uses trailing commas. It makes it easier to implement new widgets and hints the auto formatter to make a new line (https://docs.flutter.dev/tools/formatting) 
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}
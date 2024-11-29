import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Practica #2 EQ14',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Roboto',
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  late WordPair current;
  List<WordPair> favorites = [];

  MyAppState() {
    current = WordPair.random();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void removeFromFavorites(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  void clearFavorites() {
    favorites.clear();
    notifyListeners();
  }

  void addFavorite(WordPair pair) {
    favorites.add(pair);
    notifyListeners();
  }

  List<WordPair> searchFavorites(String query) {
    return favorites.where((pair) => pair.asLowerCase.contains(query.toLowerCase())).toList();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Practica #2 EQ14'),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home_filled),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite),
                selectedIcon: Icon(Icons.favorite),
                label: Text('Favorites'),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: page,
            ),
          ),
        ],
      ),
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

    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: pair.asPascalCase));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Word copied to clipboard')),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            pair.asPascalCase,
            style: TextStyle(fontSize: 36),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                iconSize: 36,
              ),
              SizedBox(width: 20),
              IconButton(
                onPressed: () {
                  appState.getNext();
                },
                icon: Icon(Icons.refresh),
                iconSize: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    List<WordPair> displayedFavorites;
    if (searchQuery.isNotEmpty) {
      displayedFavorites = appState.searchFavorites(searchQuery);
    } else {
      displayedFavorites = appState.favorites;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Search Favorites',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    searchQuery = '';
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: displayedFavorites.length,
            itemBuilder: (context, index) {
              var pair = displayedFavorites[index];
              return ListTile(
                leading: Icon(Icons.favorite),
                title: Text(pair.asPascalCase),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        appState.removeFromFavorites(pair);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        _copyToClipboard(pair.asPascalCase);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            WordPair newPair = WordPair.random();
            appState.addFavorite(newPair);
          },
          child: Text('Add Random Word to Favorites'),
        ),
      ],
    );
  }

  void _copyToClipboard(String word) {
    Clipboard.setData(ClipboardData(text: word));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Word copied to clipboard')),
    );
  }
}

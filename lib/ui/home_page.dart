import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotesapp/ui/favorite_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quotesapp/widgets/quote_widget.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var apiURL = "https://type.fit/api/quotes";
  PageController controller = PageController();
  List<dynamic> favoriteQuotes = [];
  final RandomColor _randomColor = RandomColor();

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites');
    if (favorites != null) {
      setState(() {
        favoriteQuotes = favorites.map((quote) => {'text': quote}).toList();
      });
    }
  }

  Future<void> toggleFavorite(String quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites');
    favorites ??= [];

    if (favorites.contains(quote)) {
      favorites.remove(quote);
    } else {
      favorites.add(quote);
    }

    await prefs.setStringList('favorites', favorites);
    await loadFavorites();
  }

  Future<List<dynamic>> getPost() async {
    final response = await http.get(Uri.parse(apiURL));
    return postFromJson(response.body);
  }

  List<dynamic> postFromJson(String str) {
    List<dynamic> jsonData = json.decode(str);
    jsonData.shuffle();
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: getPost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ErrorWidget("error no connect");
            }
            return Stack(
              children: [
                PageView.builder(
                  controller: controller,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var model = snapshot.data![index];
                    bool isFavorite = favoriteQuotes
                        .any((quote) => quote['text'] == model['text']);
                    return QuoteWidget(
                      quote: model["text"].toString(),
                      author: model["author"].toString(),
                      onPrClick: () {},
                      onNextClick: () {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                        );
                      },
                      bgColor: _randomColor.randomColor(
                        colorHue: ColorHue.multiple(
                          colorHues: [ColorHue.red, ColorHue.blue],
                        ),
                      ),
                      isFavorite: isFavorite,
                      onFavoriteToggle: () {
                        toggleFavorite(model['text']);
                      },
                    );
                  },
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (kIsWeb)
                        InkWell(
                          onTap: () {
                            controller.previousPage(
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeOut);
                          },
                        ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 1, color: Colors.white)),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const FavoritePage()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 1, color: Colors.white)),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

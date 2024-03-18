import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//onde tiver build NUNCA retorne null, se não quiser retornar nada coloque apenas um Container();

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
   Future.delayed(Duration.zero).then((_) => close(context, query)); // aqui eu estou 'adiando' meu close enquanto ele desenha nosso widget de resultados
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder<List?>(
          future: suggestions(query),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index],),
                      leading: Icon(Icons.search_rounded),
                      onTap: () {
                        close(context, snapshot.data![index]);
                      },
                    );
                  }
                  );
          });
    }
  }

  Future<List?> suggestions(String search) async {
    final url = Uri.parse(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
     return json.decode(response.body)[1].map((v) {
        return v[0];
      }).toList();
    } else {
      throw Exception('error');
    }
  }
}

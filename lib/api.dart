import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/video_model.dart'; //significa que estamos importando como http, é uma boa prática.
const API_KEY = "AIzaSyB6MdrAAY1elfvli7pfIT7APkMMal7xs5E";

class Api{

  late String _search;
  late String? _nextToken ;

  Future<List<Video>?> search(String search) async{
    _search = search;

    var url = Uri.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10");
    http.Response response = await http.get(
       url,
    );

    return decode(response);
  }
  Future<List<Video>?> nextPage() async{ // carregará novas páginas com + videos
    if (_nextToken == null) {
      return null; // Se não houver próxima página, retorna null
    }
    var url = Uri.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=2&pageToken=$_nextToken");
    http.Response response = await http.get(
      url,
    );
    return decode(response);
  }

  List<Video>?decode(http.Response response){
    if (response.statusCode == 200){
      var decoded = json.decode(response.body);

      _nextToken = decoded["nextPageToken"];

      List<Video> videos = decoded['items'].map<Video>(
          (map){
            return Video.fromJson(map);
          }
      ).toList();
      return videos;

    } else {
      throw Exception('fail to load videos');
    }

  }
}
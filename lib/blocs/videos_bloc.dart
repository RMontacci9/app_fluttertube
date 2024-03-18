import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:app_fluttertube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../models/video_model.dart';

class VideosBloc implements BlocBase {
  //ao utilizar o bloc, implementamos o BlocBase pois utilizaremos basicamente apenas streams para 'observar' nossos eventos. Logo, o BlocBase garante
  //para nós que vamos fechar a stream depois de usarmos. SEMPRE que usamos streams precisamos fecha-las depois.

  //stream = saida dos dados, sink = entrada dos dados

   Api? api;

  //aqui tiramos os dados da nossa stream
 late List<Video> videos;
  final StreamController<List<Video>?> _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController
      .stream; // aqui podemos usar fora da classe, criamos um getter que retorna os valores do videosController para nossa stream na view.
  //os videos serão passados para o _videosController.stream que serão passados para nosso getter outVideos e assim vistos na nossa view.

  //aqui pegamos os dados para nossa stream (usamos o sink para isso)
  final StreamController<String>? _searchController = StreamController<String>();

  Sink get inSearch => _searchController
      !.sink; // para adicionar algo, basta chamar inSearch.add e adicionar o dado aqui.

  VideosBloc() {
    api = Api();
    _searchController!.stream.listen(_searchEvent);
  }

   _searchEvent(String search) async {
     if (search != null) {
       _videosController.sink.add([]);
       videos = (await api!.search(search))!;
     } else {
       var newVideos = await api!.nextPage();
       videos += newVideos!.toList();
     }
     _videosController.sink.add(videos);
   }


  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController!.close();
  }


  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();
}

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }


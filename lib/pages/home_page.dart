import 'package:app_fluttertube/blocs/favorite_bloc.dart';
import 'package:app_fluttertube/blocs/videos_bloc.dart';
import 'package:app_fluttertube/delegates/data_search.dart';
import 'package:app_fluttertube/pages/favorites_page.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import '../models/video_model.dart';
import '../widgets/video_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<VideosBloc>();

    final blocFav = BlocProvider.getBloc<FavoriteBloc>();

    Map<String, Video> map = {};

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Container(
          height: 45,
          child: Image.asset('assets/images/youtube.png'),
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: blocFav.OutFav,
              initialData: map,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("${snapshot.data!.length}");
                } else {
                  return Text('0');
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
            icon: Icon(Icons.star),
          ),
          IconButton(
            onPressed: () async {
              String? result = await showSearch(
                context: context,
                delegate: DataSearch(),
              );
              if (result != null) {
                bloc.inSearch.add(
                    result); // se o result da minha pesquisa for diferente de null, ele chama meu bloc de pesquisa/evento de pesquisa
              }
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: bloc.outVideos,
          initialData: [], // ao iniciar o app ele não vai carregar nada.
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length) {
                    return VideoTile(snapshot.data[index]);
                  } else if (index > 1) {
                    bloc.inSearch.add('');
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: snapshot.data.length + 1,
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

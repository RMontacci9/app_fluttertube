import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../blocs/favorite_bloc.dart';
import '../models/video_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.OutFav,
        initialData: {},
        builder: (context, snapshot) {
          return ListView(
              children: snapshot.data!.values.map((v) {
            return InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  _watchVideo(v.id, v.title)),
                );

              },
              onLongPress: (){
                bloc.toggleFavorite(v);
              },
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 100,
                    child: Image.network(v.thumb),
                  ),
                  Expanded(
                    child: Text(
                      v.title,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            );
          }).toList());
        },
      ),
    );
  }

  _watchVideo(String idVideo, String titleVideo){
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: idVideo,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false
      ),
    );
   return YoutubePlayerBuilder(
     player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
        ),
        onReady: () {
        },
      ),
     builder: (context, player){
       return Scaffold(
         backgroundColor: Colors.black87,
         appBar: AppBar(title: Text(titleVideo, style: TextStyle(fontSize: 10),), centerTitle: true, backgroundColor: Colors.black87,),
         body: player,
       );
     },
   );
  }
}

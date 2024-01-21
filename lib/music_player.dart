import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


void music_app() {
  runApp(music_player());
}

enum player_state { stopped, playing, paused }

class music_player extends StatefulWidget {
  //const MyApp({super.key, required this.title});
  //final String title;
  @override
  MusicPlayerState createState() => MusicPlayerState();

}

class MusicPlayerState extends State<music_player> {
/*
  void create_players() async{
    final battle_player = AudioPlayer(); await battle_player.setUrl("https://drive.google.com/uc?export=view&id=17W9-MV7B45hJyCOUg4sQZ6IXUUmCeBkN");
    final tavern_player = AudioPlayer(); await tavern_player.setUrl("https://drive.google.com/uc?export=view&id=1sdsGxFXMpL4GWetGOs-73mPD_y832hQ3");
    final mystery_player = AudioPlayer(); await mystery_player.setUrl("https://drive.google.com/uc?export=view&id=1sZWTHoFsCXrh5h-PXjQNWKYWtuBtpjvR");
  }
*/
  var player = AudioPlayer();
  String current = "";
  player_state playerstate = player_state.stopped;

  void pause_music() async{
  setState(() {
    playerstate = player_state.paused;
    });
    await player.pause();
  }

  void stop_music() async{
    setState(() {
      playerstate = player_state.stopped;
    });
    await player.stop();
  }

  void resume_music() async{
    setState(() {
      playerstate = player_state.playing;
    });
    player.seek(player.position);
    player.play();
  }

  void play_music(type) async{

    if(type == current){
      player.play();
    }

    if (playerstate == player_state.playing){
      return ;
    }


    switch(type){
      case "battle":
      await player.setUrl("https://drive.google.com/uc?export=view&id=17W9-MV7B45hJyCOUg4sQZ6IXUUmCeBkN");

      break;
      case "tavern":
        await player.setUrl("https://drive.google.com/uc?export=view&id=1sdsGxFXMpL4GWetGOs-73mPD_y832hQ3");
      break;
      case "mystery":
        await player.setUrl("https://drive.google.com/uc?export=view&id=1sZWTHoFsCXrh5h-PXjQNWKYWtuBtpjvR");
      break;
      default:
        await player.setUrl("https://drive.google.com/uc?export=view&id=17W9-MV7B45hJyCOUg4sQZ6IXUUmCeBkN");
      break;
    }
    current = type;
    player.play();
    setState(() {
      playerstate = player_state.playing;
    });
    }


  Widget build(BuildContext context) {
    //create_players();
    return MaterialApp(title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
       // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: ModalRoute.of(context)!.canPop
              ? IconButton(
              onPressed: () => [stop_music(), Navigator.pop(context)],
              icon: const Icon(Icons.arrow_back)
          )
              : null,
          //title: Text("Test"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Music Player"),
          centerTitle: true,
        ),
       // backgroundColor: Colors.green[900], // background color
        body: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              ElevatedButton(
                onPressed: () => [pause_music(), play_music("battle")],
                child: Text(
                  'Battle Music',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.width * 0.2),
                  backgroundColor: Colors.red[900]
                ),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () => {pause_music(), play_music("tavern")},
                child: Text(
                  'Tavern Music',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.width * 0.2),
                  backgroundColor: Colors.yellow[500]
                ),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () => {pause_music(), play_music("mystery")},
                child: Text(
                  'Mystery Music',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.width * 0.2),
                  backgroundColor: Colors.blue[900]
                ),
              ),
              ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {if(playerstate == player_state.playing){pause_music();} else resume_music();},
          tooltip: 'play',
          child: Icon(playerstate == player_state.playing ? Icons.stop_circle : Icons.play_circle,
            color: Colors.black,
            size: 40,
          ),
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
      );
  }
}
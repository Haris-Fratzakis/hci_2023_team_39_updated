import 'package:flutter/material.dart';
import 'character_creation.dart';
import 'dice_roller.dart';
import 'music_player.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DnD Companion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo',
    theme: ThemeData(
    brightness: Brightness.dark,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //useMaterial3: true,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text('DnD Companion'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CharacterCreationPage()),
                );
              },
              child: Text('Character Creation',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.width * 0.2),
                  backgroundColor: Colors.purple[900]
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiceRollerPage()),
                );
              },
              child: Text('Dice Roller',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.width * 0.2),
                  backgroundColor: Colors.purple[900]
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => music_player()),
                );
              },
              child: Text('Music Player',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.width * 0.2),
                  backgroundColor: Colors.purple[900]
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ARMapPage()),
                );
              },
              child: Text('AR Map',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.width * 0.2),
                  backgroundColor: Colors.purple[900]
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}




class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Text('Music Player Page'),
      ),
    );
  }
}

class ARMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Map'),
      ),
      body: Center(
        child: Text('AR currently not implemented'),
      ),
    );
  }
}



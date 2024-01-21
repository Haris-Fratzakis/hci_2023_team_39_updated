import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'dart:math' as math;

// DiceWidget Code
class DiceWidget extends StatelessWidget {
  final int diceNumber;

  DiceWidget({Key? key, required this.diceNumber}) : super(key: key); // Marked as required



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/dice.png'), // Your dice image
          Text(
            '$diceNumber',
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// DiceRollerPage Code
class DiceRollerPage extends StatefulWidget {
  @override
  DiceRollerPageState createState() => DiceRollerPageState();
}

class DiceRollerPageState extends State<DiceRollerPage> {
  int diceNumber = 1;
  bool isRolling = false;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!isRolling && event.x.abs() + event.y.abs() + event.z.abs() > 30  ) {
        // Start rolling the dice
        isRolling = true;
        _rollDice();
      }
    });
  }

  void _rollDice() {
    const rollDuration = Duration(milliseconds: 100);
    Timer.periodic(rollDuration, (timer) {
      if (isRolling) {
        setState(() {
          diceNumber = math.Random().nextInt(20) + 1;
        });
      } else {
        timer.cancel();
      }
    });

    // Stop rolling after a random duration between 1 and 2 seconds
    Future.delayed(Duration(milliseconds: 1000 + math.Random().nextInt(1000)), () {
      isRolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice Roller'),
      ),
      body: DiceWidget(diceNumber: diceNumber),
    );
  }
}

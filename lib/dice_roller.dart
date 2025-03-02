import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'dart:math' as math;

// DiceWidget Code
class DiceWidget extends StatelessWidget {
  final int diceNumber;
  final Function() onRollButtonPressed;

  DiceWidget({super.key, required this.diceNumber, required this.onRollButtonPressed});



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('Shake your phone to roll the die', style: TextStyle(fontSize: 20.0),),
          ),
          Center(
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
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('Alternatively, you can also press this button', style: TextStyle(fontSize: 16.0),),
          ),
          ElevatedButton(
            onPressed: onRollButtonPressed,
            child: Text('Roll'),
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
  Timer? _timer; // Store the timer

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!isRolling && event.x.abs() + event.y.abs() + event.z.abs() > 30) {
        // Start rolling the dice
        isRolling = true;
        _rollDice();
      }
    });
  }

  void _rollDice() {
    const rollDuration = Duration(milliseconds: 100);
    _timer = Timer.periodic(rollDuration, (timer) {
      if (isRolling) {
        if (mounted) {
          setState(() {
            diceNumber = math.Random().nextInt(20) + 1;
          });
        }
      } else {
        timer.cancel();
      }
    });

    // Stop rolling after a random duration between 1 and 2 seconds
    Future.delayed(Duration(milliseconds: 1000 + math.Random().nextInt(1000)), () {
      isRolling = false;
    });
  }

  void _handleRollButtonPressed() {
    if (!isRolling) {
      // Roll the dice manually when the button is pressed
      isRolling = true;
      _rollDice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice Roller'),
      ),
      body: DiceWidget(
        diceNumber: diceNumber,
        onRollButtonPressed: _handleRollButtonPressed,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }
}

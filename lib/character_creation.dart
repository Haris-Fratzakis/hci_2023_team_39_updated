import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class CharacterCreationPage extends StatefulWidget {
  @override
  CharacterCreationPageState createState() => CharacterCreationPageState();
}

class CharacterCreationPageState extends State<CharacterCreationPage> {
  int currentQuestionIndex = 0;
  Map<String, dynamic> answers = {};

  final textController = TextEditingController(); // Controller for open-ended questions

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>>  questions = [
    {
      'title': 'Choose Your Path',
      'prompt': 'If you found a lost wallet on the street, would you:',
      'options': [
        'Hand it in to the authorities, no question asked. (Lawful)',
        'Check if there\'s any reward for returning it. (Neutral)',
        'Keep it; finders, keepers! (Chaotic)'
      ],
    },
    {
      'title': 'Mystical Encounter',
      'prompt': 'One night, under a full moon, you encounter a mystical creature in distress. Do you:',
      'options': [
        'Approach carefully and offer help.',
        'Observe from a distance before deciding what to do.',
        'Steer clear; it\'s none of your business.'
      ],
    },
    {
      'title': 'Weapon of Choice',
      'prompt': 'In a battle, what would be your weapon of choice?',
      'options': [
        'A mighty sword, to smite my foes up close.',
        'A bow and arrow, to strike from a safe distance.',
        'Words and wit, because the pen (or spell) is mightier than the sword.'
      ],
    },
    {
      'title': 'A Night at the Tavern',
      'prompt': 'After a long journey, you finally arrive at a bustling tavern. What\'s your first move?',
      'options': [
        'Find the loudest table and join the revelry.',
        'A quiet corner and a warm meal, please.',
        'Con the innkeeper into giving you a free stay.'
      ],
    },
    {
      'title': 'Your Greatest Strength',
      'prompt': 'What do you consider your greatest strength? (Be creative!)',
      'options': null,
    },
    {
      'title': 'Your Deepest Fear',
      'prompt': 'What is your character\'s deepest, darkest fear?',
      'options': null,
    },
    {
      'title': 'Magic in Your Veins',
      'prompt': 'If you could wield magic, what kind would it be?',
      'options': [
        'Healing and protection spells.',
        'Illusions and mind tricks.',
        'Elemental destruction – fireball, anyone?'
      ],
    },
    {
      'title': 'The Treasure Chest',
      'prompt': 'You stumble upon a treasure chest. What\'s inside it that would make your heart leap with joy?',
      'options': null,
    },
    {
      'title': 'Ancestry and Roots',
      'prompt': 'What mysterious or unique ancestry does your character possess?',
      'options': null,
    },
    {
      'title': 'Epic Finale',
      'prompt': 'If your character had a theme song for their grand entrance or epic battle, what would it be?',
      'options': null,
    },
  ];


  void _nextQuestion() {
    if (questions[currentQuestionIndex]['options'] == null) {
      // It's an open-ended question, save the text input
      answers[questions[currentQuestionIndex]['prompt']] = textController.text;
      textController.clear();
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _submitAnswers();
    }
  }

  void _prevQuestion() {
    if (currentQuestionIndex > 0) {
      if (questions[currentQuestionIndex]['options'] == null) {
        // Load the previous answer if it's an open-ended question
        textController.text = answers[questions[currentQuestionIndex]['prompt']] ?? '';
      }

      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _submitAnswers() async {
    var url = Uri.parse('http://10.0.2.2:8000/character_creator/');
    print(jsonEncode(answers));
    var response = await http.post(url, body: jsonEncode(answers));
    if (!mounted) return; // Add this line to check if the widget is still in the tree

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CharacterDisplayPage(result: result)),
      );
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var question = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Character Creation'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question['title'], style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 8.0), // Add space between title and prompt
            Text(question['prompt']),
            SizedBox(height: 20.0), // Add space before the options or textbox
            if (question['options'] != null)
              ...question['options'].map<Widget>((option) {
                return RadioListTile(
                  title: Text(option),
                  value: option,
                  groupValue: answers[question['title']],
                  onChanged: (value) {
                    setState(() {
                      answers[question['title']] = value;
                    });
                  },
                );
              }).toList()
            else
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Your Answer',
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 5, // Allow multiple lines for open-ended answers
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: _prevQuestion,
                    child: Text('Previous'),
                  ),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(currentQuestionIndex == questions.length - 1 ? 'Submit' : 'Next'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class CharacterDisplayPage extends StatefulWidget {
  final Map<String, dynamic> result;

  CharacterDisplayPage({required this.result});

  @override
  CharacterDisplayPageState createState() => CharacterDisplayPageState();
}

class CharacterDisplayPageState extends State<CharacterDisplayPage> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the stat names in the order you mentioned
    final statNames = [
      'Strength',
      'Dexterity',
      'Constitution',
      'Intelligence',
      'Wisdom',
      'Charisma'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Character'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clickable area for character image or placeholder
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200, // Adjust the height as needed
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: _image != null
                        ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _image == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 50, // Adjust the icon size as needed
                        color: Colors.grey[600],
                      ),
                      Text(
                        'Tap to upload photo',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                      : SizedBox(), // Empty container if image is selected
                ),
              ),
              SizedBox(height: 24),
              // Display character name
              Text(
                'Name: ${widget.result['name']}',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 8),
              // Display character race
              Text(
                'Race: ${widget.result['race']}',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              // Display character class
              Text(
                'Class: ${widget.result['class']}',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 16),
              // Display character stats
              Text(
                'Stats:',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.result['stats'].length,
                itemBuilder: (context, index) {
                  // Ensure that index is within the range of available stat names
                  final statName = statNames.length > index ? statNames[index] : 'Unknown Stat';
                  return ListTile(
                    title: Text(statName),
                    trailing: Text(widget.result['stats'][index].toString()),
                  );
                },
              ),
              SizedBox(height: 16),
              // Display character description
              Text(
                'Description:',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                widget.result['description'] ?? 'No description provided.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 16),
              // Display character personality
              Text(
                'Backstory:',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                widget.result['backstory'] ?? 'No personality details provided.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
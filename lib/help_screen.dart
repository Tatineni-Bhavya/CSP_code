import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  Help({super.key});

  final List<Map<String, String>> faqs = [
    {
      'question': 'What should we do if buttons don\'t work?',
      'answer': 'Kindly refresh the application.',
    },
    {
      'question': 'How to set timezone?',
      'answer': 'Application updates itself and takes time from your phone settings.',
    },
    {
      'question': 'My steps are not updating?',
      'answer': 'Kindly wait for some time or else refresh.',
    },
    {
      'question': 'What to do if pedestrian status doesn\'t work?',
      'answer': 'It may be facing issues in collecting data from your sensors. Or maybe your mobile sensors are not working properly. Some mobile phones don\'t contain sensors, so if your mobile phone does not have sensors then "My Steps" tab doesn\'t work for you.',
    },
    {
      'question': 'Where should we place our mobile for accurate results?',
      'answer': 'Place at your bottom pockets, so that your sensors will detect the steps easily when you\'re walking. Generally, the steps will be detected wherever the phone might be, but for accurate results, you can place it in your bottom pockets.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("WellnessBreak"),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return help(
            question: faqs[index]['question']!,
            answer: faqs[index]['answer']!,
          );
        },
      ),
    );
  }
}

class help extends StatefulWidget {
  final String question;
  final String answer;

 help({required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<help> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (_isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.answer,
                    style: TextStyle(
                      fontSize: 15.0,
                      
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

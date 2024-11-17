import 'dart:async'; // Import Timer for periodic events
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './study_book.dart';
import './study_device.dart';
import './theme_set.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<String> topImageUrls = [
    'assets/img/up_icon1.png',
    'assets/img/up_ion3.png',
    'assets/img/up_icon2.png',
  ];

  final List<String> bottomImageUrls = [
    'assets/img/down_icon1.png', 
    'assets/img/down_icon2.png',
    'assets/img/down_icon3.png',
  ];

  final PageController _topPageController = PageController();
  final PageController _bottomPageController = PageController();
  
  int _currentTopPage = 0;
  int _currentBottomPage = 0;

  // Data for study break tips
  final List<Map<String, String>> tips = [
    {"title": "Move Your Body", "description": "Taking a short walk, doing stretches, or even just standing up and walking around for a few minutes helps increase blood flow and energizes your brain."},
    {"title": "Practice Deep Breathing or Meditation", "description": "Deep breathing or a quick meditation session (even 5 minutes) can lower stress levels and clear your mind."},
    {"title": "Hydrate and Eat a Healthy Snack", "description": "Drinking water and having a healthy snack (like fruit, nuts, or yogurt) will help you stay focused."},
    {"title": "Disconnect from Study Materials", "description": "Take your mind off studying completely for a short while. Avoid checking your phone for social media or emails."},
    {"title": "Listen to Music", "description": "Listening to music, especially instrumental or classical music, can help you relax and refresh your mind."},
    {"title": "Stretch and Relax Your Muscles", "description": "A few gentle stretches can release tension and improve your circulation."},
    {"title": "Get Some Fresh Air", "description": "Stepping outside for a bit, even if it's just for a few minutes, can make a big difference."},
    {"title": "Change Your Environment", "description": "Switching up your environment for a short time can help break the monotony and refresh your mind."},
    {"title": "Practice Mindfulness", "description": "Focus on your breath or observe your surroundings for a minute or two."},
    {"title": "Do Something Creative", "description": "Take a break by doing something fun and creative, like doodling, journaling, or doing a simple craft."},
    {"title": "Use a Timer for Breaks", "description": "Set a timer for your break. A good rule of thumb is the Pomodoro technique: 25 minutes of focused study followed by a 5-minute break."},
    {"title": "Get a Change of Pace", "description": "Doing something non-study-related but mentally engaging (like reading a book or watching a short video) can help reset your focus."},
    {"title": "Drink Herbal Tea or Coffee", "description": "A warm drink like herbal tea or a small cup of coffee can give you the mental alertness to continue your session."},
    {"title": "Journal or Reflect", "description": "Quickly jot down how you’re feeling or what you’ve learned so far. Reflecting on your progress can help you regain motivation."},
    {"title": "Laugh or Watch Something Light", "description": "Watch a funny short video, meme, or something that makes you laugh."},
    {"title": "Take a Power Nap", "description": "A quick 10–20 minute nap can do wonders. Be careful not to sleep for too long, as it can leave you feeling groggy."},
    {"title": "Organize Your Study Space", "description": "A quick tidy-up of your study area can help clear your mind."},
    {"title": "Visualize Your Goals", "description": "Take a few minutes to visualize your study goals or review your to-do list."},
    {"title": "Chat with a Friend", "description": "Talk to a friend for a brief mental break. A short conversation can recharge you and refresh your energy."},
    {"title": "Engage in a Quick Hobby", "description": "If you enjoy something creative like drawing, knitting, or photography, take a few minutes to engage in your hobby."},
    {"title": "The 20-Minute Rule", "description": "If you’ve been studying intensely for a long time, a 20-minute break is ideal. Avoid longer breaks, as they can make it harder to refocus."},
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 9), (timer) {
      if (_currentTopPage < topImageUrls.length - 1) {
        _currentTopPage++;
      } else {
        _currentTopPage = 0; 
      }

      _topPageController.animateToPage(
        _currentTopPage,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
      );
    });

    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentBottomPage < bottomImageUrls.length - 1) {
        _currentBottomPage++;
      } else {
        _currentBottomPage = 0; 
      }

      _bottomPageController.animateToPage(
        _currentBottomPage,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _topPageController.dispose();
    _bottomPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home())),
        tooltip: 'settings',
        child: const Icon(Icons.settings),
      ),
      body: SingleChildScrollView( 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: <Widget>[
              // Top Image Slider
              Container(
                height: 200,
                child: PageView.builder(
                  controller: _topPageController,
                  itemCount: topImageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: Image.asset(topImageUrls[index], key: ValueKey<int>(index)),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
                    Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.inversePrimary, 
                padding: const EdgeInsets.all(8.0), 
                child: const Text(
                  'Click on the buttons below based on your study mode',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  foregroundColor: Colors.black, 
                ),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Study())),
                child: const Text('I am studying on books'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary, 
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Study1())),
                child: const Text('I am studying on mobile'),
              ),

              const SizedBox(height: 20),
Container(
                height: 200,
                child: PageView.builder(
                  controller: _bottomPageController,
                  itemCount: bottomImageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: Image.asset(bottomImageUrls[index], key: ValueKey<int>(index)),
                      ),
                    );
                  },
                ),
              ),

              // Tips Section - Scrollable Cards
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.inversePrimary, 
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Study Break Tips',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Scrollable Cards
              Container(
                height: 350, 
                child: ListView.builder(
                  itemCount: tips.length,
                  itemBuilder: (context, index) {
                    final tip = tips[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade100, Colors.blue.shade50],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tip['title']!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  tip['description']!,
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Bottom Image Slider
              
            ],
          ),
        ),
      ),
    );
  }
}

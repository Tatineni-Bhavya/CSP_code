import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';


class PedometerPage extends StatefulWidget {
  @override
  _PedometerPageState createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '0';
  int _goalSteps = 0;
  String _goalStatus = '';
  double percentage=0;
  int _dailyStepReference = 0;
  int _dailySteps = 0;
  DateTime _lastRecordedDate=DateTime.now();



  final String _dateKey = 'goal_date_key';

  @override
  void initState() {
    super.initState();
    _loadGoal();
    initPlatformState();
  }

  Future<void> _loadGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();
    String? storedDate = prefs.getString(_dateKey);

    if (storedDate != null) {
      DateTime goalDate = DateTime.parse(storedDate);
      if (goalDate.day == today.day && goalDate.month == today.month && goalDate.year == today.year) {
        _goalSteps = prefs.getInt('goal_steps') ?? 0;
      } else {
        _showGoalDialog();
      }
    } else {
      _showGoalDialog();
    }
  }

  void _showGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController goalController = TextEditingController();
        return AlertDialog(
          title: Text('Set Your Step Goal'),
          content: TextField(
            controller: goalController,
            decoration: InputDecoration(
              labelText: 'Enter Here',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                int goal = int.tryParse(goalController.text) ?? 0;
                if (goal > 0) {
                 Navigator.of(context).pop();
                  _setGoal(goal);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid goal.')),
                  );
                }
              },
              child: Text('Set Goal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }


  void _setGoal(int goal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _goalSteps = goal;
      _goalStatus = 'Goal set for today: $_goalSteps steps';
    });
    await prefs.setInt('goal_steps', _goalSteps);
    await prefs.setString(_dateKey, DateTime.now().toIso8601String());
  }

  void onStepCount(StepCount event) {

    setState(() {
      _steps = event.steps.toString();
      int totalSteps = event.steps;
      
    DateTime currentDate = DateTime.now();
  if (_lastRecordedDate == null || currentDate.day != _lastRecordedDate.day) {
    // New day: reset the reference point
    _dailyStepReference = totalSteps;
    _lastRecordedDate = currentDate;
  }
    _dailySteps = totalSteps - _dailyStepReference;

      _checkGoal(int.parse(_steps));
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() == PermissionStatus.granted;
    }

    return granted;
  }

  Future<void> initPlatformState() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      print("Permission not granted");
      return;
    }

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    (await _pedestrianStatusStream.listen(onPedestrianStatusChanged)).onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  void _checkGoal(int currentSteps) {
    if (_goalSteps > 0) {
      percentage=(currentSteps/_goalSteps)*100;
    
      setState(() {
        _goalStatus = currentSteps >= _goalSteps 
    ? 'Goal Reached! 👏\nCongratulations on reaching your  goal!'
    : '🚶‍♂️ Keep Going!\n ${(_goalSteps - currentSteps)} more steps to reach your goal.';

      });
    }
  }

  Future<void> _checkEndOfDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();
    String? storedDate = prefs.getString(_dateKey);

    if (storedDate != null) {
      DateTime goalDate = DateTime.parse(storedDate);
      if (goalDate.day != today.day) {
        int currentSteps = int.parse(_steps);
        _steps='0';
        String message = currentSteps >= _goalSteps
            ? '🥳Congratulations! You reached your goal!'
            : '😔Better luck tomorrow! You needed ${(_goalSteps - currentSteps)} more steps.';
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('End of Day'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  prefs.remove('goal_steps');
                  prefs.remove(_dateKey);
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _checkEndOfDay(); // Check end of day logic
    
    return
       Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('WellnessBreak'),
        ),
        body: Center(
          child: Column(
             mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Text("👣", style: TextStyle(fontSize: 40,)),
              
               SizedBox(height: 10),
              // Circular Progress Indicator
             
             new CircularPercentIndicator(
                radius: 110.0,
                lineWidth: 10.0,
                percent: (_goalSteps > 0) ? min(int.parse(_steps) / _goalSteps, 1.0): 0.0,
                animation: true,
                center: new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
      _dailySteps.toString(),
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), 
      ),
      Text(
        "YOUR STEPS",
        style: TextStyle(fontSize: 10), 
      ),
      Text(
        '$_goalSteps',
        style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold), 
      ),
      Text(
        '🎯GOAL',
        style: TextStyle(fontSize: 10), 
      ),
      Text(
        '${(_goalSteps > 0) ? min((int.parse(_steps) / _goalSteps)*100, 100).toStringAsFixed(1): 0.0}%',
        style: TextStyle(fontSize: 15,), 
      ),
      
    ],
  ),

                circularStrokeCap: CircularStrokeCap.round,
                progressColor:Colors.lightBlue,
              ),


             SizedBox(height: 20),

             Container(
          padding: EdgeInsets.all(16.0), // Padding around the text
           decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlue, width: 2.0), // Light blue border
         borderRadius: BorderRadius.circular(12.0), // Rounded corners
          boxShadow: [
         BoxShadow(
        color: Colors.lightBlue.withOpacity(0.4), // Shadow color
        spreadRadius: -2, // Spread the shadow
        blurRadius: 10, // Blur effect for the shadow
         // Offset of the shadow
      ),
    ],
    
  ),
  child: Text(
    textAlign: TextAlign.center,
    _goalStatus.isNotEmpty ? _goalStatus : 'Set your goal!',
    style: TextStyle(
      fontSize: 20, // Font size for visibility
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0, // Spacing between letters
      shadows: [
        Shadow(
          offset: Offset(1.0, 1.0),
          blurRadius: 2.0, // Subtle shadow for depth
          color: Colors.black.withOpacity(0.2),
        ),
      ],
    ),
  ),
),
             
              SizedBox(height: 20),

              Text(
                'Status',
                style: TextStyle(fontSize: 15,color: Colors.lightBlue,fontStyle: FontStyle.italic,shadows: [
                  Shadow(
                  offset: Offset(1.0,1.0),
                  blurRadius: 2.0,
                  color: Colors.lightBlue.withOpacity(0.8),
                  ),
                  ],),
),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 100,
                color: Colors.lightBlue,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 15,color: Colors.lightBlue,fontStyle: FontStyle.italic,shadows: [
                  Shadow(
                  offset: Offset(1.0,1.0),
                  blurRadius: 2.0,
                  color: Colors.lightBlue.withOpacity(0.8),
                  ),
                  ],)
                      : TextStyle(fontSize: 15, color: Colors.lightBlue,fontStyle: FontStyle.italic,shadows: [
                  Shadow(
                  offset: Offset(1.0,1.0),
                  blurRadius: 2.0,
                  color: Colors.lightBlue.withOpacity(0.8),
                  ),
                  ],),
                ),
              )
            ],
          ),
        ),
      );
    
  }
}

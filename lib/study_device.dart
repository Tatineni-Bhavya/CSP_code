import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:typed_data';
import 'dart:async'; 
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Study1 extends StatefulWidget {
  @override
  _StudyState createState() => _StudyState();
}

class _StudyState extends State<Study1> with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isStudying = false;
  int notificationCount = 0;
  Timer? _screenTimeTimer; // Timer for tracking screen time
  int _screenTimeInSeconds = 0; // Variable to store screen time
  double imageHeight = 100;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize timezone data
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    var androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon'); // Ensure you have this icon
    var initializationSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotifications() async {
    if (!isStudying) return;

    // Schedule each notification
    _scheduleNotification(
      title: "Consume water, stay hydrated",
      duration: Duration(hours: 1),
      imagePath: 'assets/img/drinking.png',
      repeat: true,
    );

    _scheduleNotification(
      title: "Continue with studying",
      duration: Duration(hours: 1,minutes: 10),
      imagePath: 'assets/img/study_book2.png',
      repeat: true,
    );

    _scheduleNotification(
      title: "Stretch your arms",
      duration: Duration(minutes: 45),
      imagePath: 'assets/img/study_mobile.png',
      repeat: true,
    );

    _scheduleNotification(
      title: "Take a break and relax",
      imagePath: 'assets/img/break.png',
      duration: Duration(hours: 3),
      repeat: true,
    );

    // Start tracking screen time
    _startScreenTimeTracker();
  }

  Future<void> _scheduleNotification({required String title, required Duration duration,required String imagePath, bool repeat = false}) async {
    final ByteData bytes = await rootBundle.load(imagePath);
    final Uint8List imageBytes = bytes.buffer.asUint8List();

    // Resize the image using flutter_image_compress
    final List<int> resizedImageBytes = await _resizeImage(imageBytes);
    
    var androidDetails = AndroidNotificationDetails(
     'study_channel',
      'Study Notifications',
      channelDescription: 'Notifications for study reminders',
      importance: Importance.high,
      priority: Priority.high,
      vibrationPattern: Int64List.fromList([0, 500, 1000]),
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
      styleInformation: BigPictureStyleInformation(
        ByteArrayAndroidBitmap(Uint8List.fromList(resizedImageBytes)), // Use resized image
      ),
    );

    var notificationDetails = NotificationDetails(android: androidDetails);
    notificationCount++; // Increment notification count

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      notificationCount,
      "wellnessBreak",
      title,
      tz.TZDateTime.now(tz.local).add(duration),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeat ? DateTimeComponents.time : null, // Repeat if specified
    );

    // Schedule the next notification if repeat is true
    if (isStudying) {
      if (repeat) {
        Future.delayed(duration, () {
          if (isStudying) {
            _scheduleNotification(title: title, duration: duration, imagePath: imagePath,repeat: true);
          }
        });
      }
    }
  }
 // Helper function to resize the image
  Future<List<int>> _resizeImage(Uint8List imageBytes) async {
    // Compress the image to a smaller size (e.g., 50% of original size)
    var result = await FlutterImageCompress.compressWithList(
      imageBytes,
      minWidth: 800,  // Resize width to 800px
      minHeight: 600, // Resize height to 600px
      quality: 80,    // Compress quality (lower is smaller)
    );
    return result;
  }

  void _startScreenTimeTracker() {
    _screenTimeInSeconds = 0; // Reset screen time
    _screenTimeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _screenTimeInSeconds++;

      // Check if 2 hours (7200 seconds) have passed
      if (_screenTimeInSeconds >= 7200) {
        _sendExcessiveScreenTimeNotification();
        _screenTimeInSeconds = 0; 
      }
    });
  }

  void _sendExcessiveScreenTimeNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'study_channel1',
      'Screen Time Alert',
      channelDescription: 'Notification for excessive screen time',
      importance: Importance.high,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      999, // Unique ID for this notification
      "Excessive Screen Time",
      "Please take a break!",
      notificationDetails,
    );
  }

  Future<void> _stopNotifications() async {
    await _notificationsPlugin.cancelAll();
    _screenTimeTimer?.cancel(); // Stop the timer
    notificationCount = 0; // Reset count
    setState(() {
      isStudying = false;
    });
  }

  @override
  void dispose() {
    _screenTimeTimer?.cancel(); // Cancel the timer on dispose
    super.dispose();
  }

   void _showStudyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Happy Studying!"),
          content: Text("You may continue with your studies undisturbed. We will notify you when it is time for a break. Wishing you a productive session!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Method to show dialog when study stops
  void _showStoppedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Study Session Ended"),
          content: Text("You have had a productive and successful study session."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    imageHeight = screenHeight * 0.3;
    
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Wellness Break'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
              "assets/img/study_device.png",
              height: imageHeight,
              fit: BoxFit.cover,
            ),
       SizedBox(height: 20),
                    Card(
              elevation: 0, // No internal elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: const Color.fromARGB(255, 238, 190, 247),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'When you start studying, click the "Started Studying" button',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
              Tooltip(
                message: 'when you started studying click on it',
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(overlayColor: const Color.fromARGB(255, 20, 3, 78)),
                  onPressed: () {
                    if (!isStudying) {
                      setState(() {
                        isStudying = true;
                        notificationCount = 0; // Reset count on start
                      });
                      _scheduleNotifications(); 
                      _showStudyDialog();// Start scheduling notifications
                    }
                  },
                  child: Text('Started Studying'),
                ),
              ),
              SizedBox(height: 20),
              Tooltip(
              message: 'When you stopped studying, click on it',
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  overlayColor: const Color.fromARGB(255, 145, 118, 232),
                ),
                onPressed: () {
                  _stopNotifications();
                  _showStoppedDialog(); // Stop all notifications
                },
                child: Text('Stopped Studying'),
              ),
            ),
            SizedBox(height: 20),

            // Instruction Card: 'When you stopped studying...'
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: const Color.fromARGB(255, 238, 190, 247),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'When you stop studying, click the "Stopped Studying" button',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),


            ],
          ),
        ),
      );
  
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:typed_data';
import 'package:flutter/services.dart'; 
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Study extends StatefulWidget {
  @override
  _StudyState createState() => _StudyState();
}

class _StudyState extends State<Study> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isStudying = false;
  int notificationCount = 0;

  double imageHeight = 100;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); 
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    var androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon'); // Ensure you have this icon
    var initializationSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotifications() async {
    if (!isStudying) return;

    // Start scheduling the repeating notifications with images
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
      duration: Duration(minutes: 1),
      imagePath: 'assets/img/strech.png',
      repeat: true,
    );

    _scheduleNotification(
      title: "Take a break and relax",
      duration: Duration(hours: 3),
      imagePath: 'assets/img/break.png',
      repeat: true,
    );
  }

  // Updated _scheduleNotification to use automatic image resizing
  Future<void> _scheduleNotification({required String title,required Duration duration,required String imagePath,bool repeat = false,
  }) async {
    // Load the image from assets
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
        ByteArrayAndroidBitmap(Uint8List.fromList(resizedImageBytes)), 
      ),
    );

    var notificationDetails = NotificationDetails(android: androidDetails);
    notificationCount++; // Increment notification count

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      notificationCount,
      "WellnessBreak",
      title,
      tz.TZDateTime.now(tz.local).add(duration),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeat ? DateTimeComponents.time : null, 
    );

   
    if (isStudying && repeat) {
      Future.delayed(duration, () {
        if (isStudying) {
          // Ensure to pass the correct parameters in the callback
          _scheduleNotification(title: title, duration: duration, imagePath: imagePath, repeat: true);
        }
      });
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

  Future<void> _stopNotifications() async {
    await _notificationsPlugin.cancelAll();
    notificationCount = 0; // Reset count
    setState(() {
      isStudying = false;
    });
  }

  // Method to show dialog when study starts
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
    // Calculate the screen height for image scaling dynamically
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
            // Display the study image with dynamic height
            Image.asset(
              "assets/img/study_book.png",
              height: imageHeight,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // Instruction Card: 'When you started studying...'
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

            // "Started Studying" Button with Tooltip
            Tooltip(
              message: 'When you started studying, click on it',
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  overlayColor: const Color.fromARGB(255, 145, 118, 232),
                ),
                onPressed: () {
                  if (!isStudying) {
                    setState(() {
                      isStudying = true;
                      notificationCount = 0; // Reset count on start
                    });
                    _scheduleNotifications(); // Start scheduling notifications
                    _showStudyDialog(); // Show dialog when started studying
                  }
                },
                child: Text('Started Studying'),
              ),
            ),
            SizedBox(height: 20),

            // "Stopped Studying" Button with Tooltip
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

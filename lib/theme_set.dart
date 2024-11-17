import 'package:flutter/material.dart';
import './main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _value1 = false;
  bool _value2 = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
           mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[ 
          Card(
    elevation: 0, // No internal elevation since shadow is applied to the container
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners for the card
    ),
    color: const Color.fromARGB(255, 238, 190, 247), // Background color of the card
    child: Padding(
            padding: const EdgeInsets.all(10.0), // Padding inside the card
               child: Text(
               'set your Theme',
                style: TextStyle(
                     fontSize: 18, // Adjusted font size for better visibility
                   color: Colors.purple,
                     fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center, // Center align the text
      ),
    ),
  ),
          Text("Black Theme"),
          
          Switch(
          value: _value1,
          onChanged: (value) {
            setState(() {
              _value1 = value;
              if (_value1)
                MyApp.of(context)!.changeTheme(ThemeMode.dark);
              else
                MyApp.of(context)!.changeTheme(ThemeMode.light);
            });
          },
        ),
        
        Text("light Theme"),
        Switch(
          value: _value2,
          onChanged: (value) {
            setState(() {
              _value2 = value;
              if (_value2)
                MyApp.of(context)!.changeTheme(ThemeMode.light);
              else
                MyApp.of(context)!.changeTheme(ThemeMode.dark);
            });
          },
        ),
        ]),
      ),
    );
  }
}
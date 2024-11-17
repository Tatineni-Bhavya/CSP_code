import 'package:flutter/material.dart';

class know_water extends StatefulWidget {
  @override
  _WaterIntakeCalculatorState createState() => _WaterIntakeCalculatorState();
}

class _WaterIntakeCalculatorState extends State<know_water> {
  final TextEditingController _weightController = TextEditingController();
  String _activityLevel = 'Sedentary';
  String _climate = 'Winter';
  double _dailyWaterIntake = 0;
  double _dailyWaterIntake1 = 0;

  void _calculateWaterIntake() {
    final double weight = double.tryParse(_weightController.text) ?? 0;

    // Base water intake calculation
    double baseWaterIntake = weight * 30; // 30 mL per kg

    // Activity bonus
    double activityBonus = 0;
    switch (_activityLevel) {
      case 'Light Activity':
        activityBonus = 500;
        break;
      case 'Moderate Activity':
        activityBonus = 1000;
        break;
      case 'Extreme Activity':
        activityBonus = 1500;
        break;
      default: // Sedentary
        activityBonus = 0;
        break;
    }

    // Climate bonus
    double climateBonus = 0;
    if (_climate == 'Summer') {
      climateBonus = 500;
    }

    // Total daily water intake
    _dailyWaterIntake = baseWaterIntake + activityBonus + climateBonus;
    _dailyWaterIntake1 = _dailyWaterIntake / 1000;

    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("WellnessBreak"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Know how much water to drink based on the following constraints',
                style: TextStyle(color: Colors.black, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 78, 187, 237),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(
                'ENTER YOUR WEIGHT',
                style: TextStyle(color: Colors.black, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 78, 187, 237),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(
                'SELECT YOUR ACTIVITY',
                style: TextStyle(color: Colors.black, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 5),
            DropdownButton<String>(
              value: _activityLevel,
              onChanged: (String? newValue) {
                setState(() {
                  _activityLevel = newValue!;
                });
              },
              items: <String>[
                'Sedentary',
                'Light Activity',
                'Moderate Activity',
                'Extreme Activity'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Activity Level'),
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 78, 187, 237),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(
                'SELECT CLIMATE IN YOUR AREA',
                style: TextStyle(color: Colors.black, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _climate,
              onChanged: (String? newValue) {
                setState(() {
                  _climate = newValue!;
                });
              },
              items: <String>['Winter', 'Rainy', 'Summer']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Climate'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculateWaterIntake,
              style: ElevatedButton.styleFrom(
             backgroundColor:Colors.lightBlue,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: Text(
                'Calculate',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 10),

           Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.lightBlue, width: 2), // Light blue border
    borderRadius: BorderRadius.circular(12), // Rounded corners for the border
    boxShadow: [
      BoxShadow(
        color: Colors.lightBlue.withOpacity(0.3), // Shadow color
        blurRadius: 6, // Blur effect for the shadow
        spreadRadius: -2,
        // Shadow offset
      ),
    ],
  ),
  child: Card(
    elevation: 0, // No internal elevation since shadow is applied to the container
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners for the card
    ),
    color: Colors.white, // Background color of the card
    child: Padding(
      padding: const EdgeInsets.all(10.0), // Padding inside the card
      child: Text(
        'Daily Water Intake: ${_dailyWaterIntake1.toStringAsFixed(2)} L',
        style: TextStyle(
          fontSize: 18, // Adjusted font size for better visibility
          color: Colors.lightBlue,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center, // Center align the text
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}

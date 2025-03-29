import 'package:flutter/material.dart';
import 'package:fluttter_fourthousand_weeks/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  DateTime? selectedDate;

  Future<void> _saveBirthDay() async {
    if (selectedDate != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("birthday", selectedDate!.toIso8601String());
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Birthday Setting"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedDate == null
              ? "เลือกวันเกิดของคุณ"
              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(onPressed: () async { 
              DateTime? picked = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now(), initialDate: DateTime.now());
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            }, child: Text("เลือกวันเกิด"),),
            SizedBox(height: 20.0),
            ElevatedButton(onPressed: _saveBirthDay, child: Text("บันทึก"))
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime? birthday;
  DateTime? lastDay;
  int totalWeeks = 4000;
  int livedWeeks = 0;

  @override
  void initState() {
    super.initState();
    _loadBirthday();
  }

  Future<void> _loadBirthday() async {
    final prefs = await SharedPreferences.getInstance();
    String? birthDayString = prefs.getString("birthday");
    if (birthDayString != null) {
      DateTime birthDate = DateTime.parse(birthDayString);
      DateTime now = DateTime.now();
      int weeksLived = now.difference(birthDate).inDays ~/ 7;

      setState(() {
        birthday = birthDate;
        livedWeeks = weeksLived;
        lastDay = birthDate.add(Duration(days: 4000 * 7));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Life in 4000 Weeks"),
        actions: birthday != null
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    "${birthday!.day}/${birthday!.month}/${birthday!.year} - ${lastDay!.day}/${lastDay!.month}/${lastDay!.year}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 16,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: totalWeeks,
          itemBuilder: (context, index) {
            Color color;
            if (index < livedWeeks) {
              color = Colors.green.shade400; 
            } else if (index == livedWeeks) {
              color = Colors.redAccent.shade200; 
            } else {
              color = Colors.grey.shade300; 
            }

            return Tooltip(
              message: "สัปดาห์ที่ ${index + 1}",
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  // border: Border.all(color: Colors.black26, width: 0.3),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

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
      _updateBirthday(birthDate);
    }
  }

  Future<void> _pickNewBirthday() async {
    DateTime initialDate = birthday ?? DateTime.now().subtract(const Duration(days: 365 * 20));
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (newDate != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("birthday", newDate.toIso8601String());
      _updateBirthday(newDate);
    }
  }

  void _updateBirthday(DateTime birthDate) {
    DateTime now = DateTime.now();
    int weeksLived = now.difference(birthDate).inDays ~/ 7;

    setState(() {
      birthday = birthDate;
      livedWeeks = weeksLived;
      lastDay = birthDate.add(Duration(days: 4000 * 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("4000 Weeks"),
        actions: [
          if (birthday != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                "${birthday!.day}/${birthday!.month}/${birthday!.year} - ${lastDay!.day}/${lastDay!.month}/${lastDay!.year}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: "เปลี่ยนวันเกิด",
            onPressed: _pickNewBirthday,
          ),
        ],
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

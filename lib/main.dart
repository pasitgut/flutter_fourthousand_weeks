import 'package:flutter/material.dart';
import 'package:fluttter_fourthousand_weeks/main_page.dart';
import 'package:fluttter_fourthousand_weeks/start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasBirthday = prefs.containsKey("birthday");
 
  runApp(MyApp(startPage: hasBirthday ? MainPage() : StartPage(),));
}

class MyApp extends StatelessWidget {
  final Widget startPage;
  const MyApp({super.key, required this.startPage});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter 4000 weeks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: startPage,
    );
  }
}
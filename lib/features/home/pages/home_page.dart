import 'package:flutter/material.dart';
import '../../../common/widgets/main_appbar.dart';
import '../widgets/attendance_section.dart';
import '../widgets/today_date_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(
        navIndex: 0, 
        titleText: 'BodyBuddy',
      ),
      body: SingleChildScrollView(
      child: Column(
        children: [
          AttendanceSection(),
          SizedBox(height: 16),
          Transform.translate(
            offset: const Offset(0, -40),
            child: const TodayDateHeader(),
          ),
        ],
      ),
    ),
    );
  }
}

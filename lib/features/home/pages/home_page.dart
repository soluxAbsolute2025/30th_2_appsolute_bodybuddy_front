import 'package:flutter/material.dart';
import '../../../common/widgets/main_appbar.dart';
import '../widgets/attendance_section.dart';
import '../widgets/today_date_header.dart';
import '../../notification/pages/notification_page.dart';

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
        imageUrl: 'assets/images/common/bell.svg',
        // 👇 [수정] 버튼 누르면 알림 페이지로 이동!
        onButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationPage()),
          );
        },
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
import 'package:flutter/material.dart';
import 'water_tab.dart';
import 'diet_tab.dart';
import 'sleep_tab.dart';
import 'medicine_tab.dart';
import 'alarm_setting_screen.dart'; // 알람 설정 화면 import

class BodyLogPage extends StatefulWidget {
  const BodyLogPage({super.key});

  @override
  State<BodyLogPage> createState() => _BodyLogPageState();
}

class _BodyLogPageState extends State<BodyLogPage> {
  @override
  Widget build(BuildContext context) {
    // 1. 화면 전체 너비를 가져옵니다.
    double screenWidth = MediaQuery.of(context).size.width;

    // 2. 탭 하나당 너비를 '화면의 3분의 1'로 설정합니다.
    // 이렇게 하면 화면에 3개가 꽉 차고, 나머지는 오른쪽으로 스크롤(슬라이딩)해야 보입니다.
    double tabWidth = screenWidth / 3;

    return DefaultTabController(
      length: 4, // 탭 개수 (수분, 식단, 수면, 약)
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
              '바디로그',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,

          // 우측 상단 알람 아이콘
          actions: [
            IconButton(
              icon: const Icon(Icons.access_time, color: Colors.black, size: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlarmSettingScreen()),
                );
              },
            ),
            const SizedBox(width: 8),
          ],

          bottom: TabBar(
            isScrollable: true, // ⭐️ 스크롤 가능하게 설정
            tabAlignment: TabAlignment.start, // ⭐️ 왼쪽부터 정렬
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.teal,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            labelPadding: EdgeInsets.zero, // 패딩을 없애야 계산된 너비가 정확히 맞음

            tabs: [
              // 각 탭의 너비를 화면의 1/3로 강제 지정
              SizedBox(width: tabWidth, child: const Tab(text: '수분')),
              SizedBox(width: tabWidth, child: const Tab(text: '식단')),
              SizedBox(width: tabWidth, child: const Tab(text: '수면')),
              SizedBox(width: tabWidth, child: const Tab(text: '약')),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WaterTab(),
            DietTab(),
            SleepTab(),
            MedicineTab(),
          ],
        ),
      ),
    );
  }
}
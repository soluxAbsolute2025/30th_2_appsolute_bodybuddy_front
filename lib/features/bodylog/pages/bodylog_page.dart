import 'package:flutter/material.dart';
import 'water_tab.dart';
import 'diet_tab.dart';
import 'sleep_tab.dart';
import 'medicine_tab.dart';

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
    double tabWidth = screenWidth / 3;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('바디로그', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          bottom: TabBar(
            isScrollable: true, // ⭐️ 중요: 탭이 많으면 스크롤 되게 설정
            tabAlignment: TabAlignment.start, // ⭐️ 중요: 왼쪽부터 채우기
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.teal,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            // 탭들의 패딩을 없애서 너비 계산을 정확하게 만듭니다.
            labelPadding: EdgeInsets.zero,

            tabs: [
              // ⭐️ 각 탭의 너비를 강제로 지정 (SizedBox 사용)
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
import 'package:flutter/material.dart';
import '../../../common/common.dart';

import 'water_tab.dart';
import 'diet_tab.dart';
import 'sleep_tab.dart';
import 'medicine_tab.dart';
import 'alarm_setting_screen.dart';

class BodyLogPage extends StatefulWidget {
  const BodyLogPage({super.key});

  @override
  State<BodyLogPage> createState() => _BodyLogPageState();
}

class _BodyLogPageState extends State<BodyLogPage> {

  @override
  void initState() {
    super.initState();
    print("📋 [BodyLogPage] 현재 사용자 토큰: ${Common.token}");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabWidth = screenWidth / 3;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
              '바디로그',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          actions: [
            // [수정] IconButton -> GestureDetector + Image.asset으로 변경
            GestureDetector(
              onTap: () {
                print("알람 설정하러 감 (토큰 보유중: ${Common.token != null})");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlarmSettingScreen()),
                );
              },
              child: Container(
                // 터치 영역 확보를 위해 투명 배경 및 패딩 설정
                color: Colors.transparent,
                padding: const EdgeInsets.all(8.0), // 터치 영역 넓히기
                child: Image.asset(
                  'assets/bodylog/alarm_icon.png', // ★ 여기에 실제 이미지 경로를 넣으세요
                  width: 80, // 이미지 너비
                  height: 60, // 이미지 높이
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width:10), // 우측 여백 살짝 조정
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF00E6BD),
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            labelPadding: EdgeInsets.zero,
            tabs: [
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
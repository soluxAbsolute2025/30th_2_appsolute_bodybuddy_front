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

  // (선택사항) 페이지 들어올 때 토큰 잘 있나 확인해보기
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
            IconButton(
              icon: const Icon(Icons.access_time, color: Colors.black, size: 24),
              onPressed: () {
                // ★ 2. 만약 알람 설정할 때 토큰이 필요하다면?
                // 여기서 토큰을 확인하거나 다음 페이지에서 Common.token을 쓰면 됩니다.
                print("알람 설정하러 감 (토큰 보유중: ${Common.token != null})");

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlarmSettingScreen()),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.teal,
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

        // ★ 3. 자식 탭들 (WaterTab 등)에게 토큰을 넘겨줄 필요가 있나요?
        // 아니요! WaterTab 파일 안에서도 'import common.dart' 하고
        // Common.token 쓰면 됩니다. 굳이 여기서 (token: Common.token) 이렇게 안 넘겨도 됩니다.
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
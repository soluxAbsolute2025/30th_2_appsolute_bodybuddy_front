import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // ... (데이터는 아까와 동일) ...
  final List<Map<String, dynamic>> _todayNotifications = [
    {
      "type": "water",
      "title": "물 마실 시간이에요!",
      "message": "수분 충전하고 활기찬 오후 보내세요 💧 (+200ml)",
      "time": "방금 전",
      "isRead": false,
    },
    {
      "type": "medicine",
      "title": "점심 약 복용 알림",
      "message": "종합 비타민, 오메가3 챙겨 드셨나요?",
      "time": "1시간 전",
      "isRead": true,
    },
    // ... 더미 데이터 추가 가능
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 👈 Scaffold로 감싸서 독립된 화면으로 만듭니다.
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '알림',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton( // 👈 뒤로가기 버튼 명시
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 오늘 알림
            _buildSectionTitle('오늘'),
            const SizedBox(height: 15),
            ..._todayNotifications.map((noti) => _buildNotificationCard(noti)),

            const SizedBox(height: 25),

            // (예시) 어제 알림 데이터가 있다면 여기에 추가
            // _buildSectionTitle('어제'),
            // ...
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[500]),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> noti) {
    IconData iconData;
    Color iconColor;
    Color iconBgColor;

    // 아이콘 로직 (아까와 동일)
    switch (noti['type']) {
      case 'water':
        iconData = Icons.water_drop;
        iconColor = const Color(0xFF4BECBE);
        iconBgColor = const Color(0xFFE0FCF6);
        break;
      case 'medicine':
        iconData = Icons.medication;
        iconColor = const Color(0xFFFFAB91);
        iconBgColor = const Color(0xFFFBE9E7);
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
        iconBgColor = Colors.grey[200]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: noti['isRead'] ? Colors.white : const Color(0xFFF0FDF9), // 안 읽음: 연한 민트 배경
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(noti['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(noti['time'], style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(noti['message'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
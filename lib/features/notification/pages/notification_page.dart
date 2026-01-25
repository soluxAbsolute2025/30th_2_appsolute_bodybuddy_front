import 'package:flutter/material.dart';
import '../data/notification_api.dart'; // 위에서 만든 API 파일 import

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = true;
  List<dynamic> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final data = await NotificationApi.getNotificationHistory();
    if (mounted) {
      setState(() {
        _notifications = data;
        _isLoading = false;
      });
    }
  }

  // "방금 전", "1시간 전" 계산 함수
  String _timeAgo(String? dateStr) {
    if (dateStr == null) return "";
    DateTime date = DateTime.parse(dateStr);
    Duration diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return "방금 전";
    if (diff.inMinutes < 60) return "${diff.inMinutes}분 전";
    if (diff.inHours < 24) return "${diff.inHours}시간 전";
    return "${date.month}월 ${date.day}일";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '알림',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4BECBE)))
          : _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 30, color: Color(0xFFF5F5F5)),
        itemBuilder: (context, index) {
          return _buildNotificationItem(_notifications[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("새로운 알림이 없습니다.", style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> noti) {
    final String type = noti['type'] ?? 'ETC';

    // 타입별 아이콘 및 색상 설정
    IconData iconData;
    Color iconColor = const Color(0xFF4BECBE); // 기본 민트색

    switch (type) {
      case 'MEAL':
        iconData = Icons.rice_bowl; // 식단
        break;
      case 'MEDICINE':
        iconData = Icons.medication; // 약
        break;
      case 'EXERCISE':
        iconData = Icons.fitness_center; // 운동
        break;
      case 'WATER':
        iconData = Icons.water_drop; // 물
        break;
      case 'POKE':
        iconData = Icons.touch_app; // 콕 찌르기 (손가락 아이콘)
        break;
      default:
        iconData = Icons.notifications;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 원형 아이콘 영역
        Container(
          width: 24, // 스크린샷처럼 작고 깔끔하게
          height: 24,
          margin: const EdgeInsets.only(top: 2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            // 배경색 없이 아이콘만 있는 스타일 (스크린샷 반영)
            // 만약 배경이 필요하면 color: Color(0xFFE0FCF6) 추가
          ),
          child: Icon(iconData, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),

        // 2. 텍스트 내용 영역
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 + 시간 (Row)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    noti['title'] ?? '알림',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[400], // 제목은 약간 연하게 (스크린샷 "바디버디 식단 알람")
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _timeAgo(noti['createdAt']),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400], // 시간도 연한 회색
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // 본문 메시지
              Text(
                noti['message'] ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87, // 본문은 진하게
                  height: 1.4, // 줄간격 살짝 줌
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
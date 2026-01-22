import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'today_body_components.dart';

import '../api/body_api.dart';
import '../models/body_today_model.dart';

class TodayBodyCard extends StatefulWidget {
  const TodayBodyCard({super.key});

  @override
  State<TodayBodyCard> createState() => _TodayBodyCardState();
}

class _TodayBodyCardState extends State<TodayBodyCard> {
  late Future<BodyToday?> _future; // ✅ null 허용

  @override
  void initState() {
    super.initState();
    _future = BodyApi().fetchTodayBody(); // fetchTodayBody()가 null을 던지거나 null 반환하는 케이스 대응
  }

  double _progress(int current, int goal) {
    if (goal <= 0) return 0.0;
    return (current / goal).clamp(0.0, 1.0);
  }
  

  void _retry() {
    setState(() {
      _future = BodyApi().fetchTodayBody();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BodyToday?>(
      future: _future,
      builder: (context, snapshot) {
        // 로딩
        if (snapshot.connectionState != ConnectionState.done) {
          return _loadingCard();
        }

        // 에러
        if (snapshot.hasError) {
          return _errorCard(snapshot.error);
        }

        final body = snapshot.data;
        if (body == null) {
          return _emptyCard();
        }

        final waterP = _progress(body.water.current, body.water.goal);
        final mealP = _progress(body.meal.current, body.meal.goal);
        final sleepP = _progress(body.sleep.current, body.sleep.goal);

        final completedCount = [waterP, mealP, sleepP].where((p) => p >= 1.0).length;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD8D8D8), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 타이틀
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '오늘의 바디',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  StatusDots(completedCount: completedCount),
                ],
              ),
              const SizedBox(height: 20),

              MetricRow(
                iconPath: 'assets/home/water.svg',
                label: '수분',
                unitText: '${body.water.current} / ${body.water.goal} ml',
                progress: waterP,
              ),
              const SizedBox(height: 10),

              MetricRow(
                iconPath: 'assets/home/meal.svg',
                label: '식단',
                unitText: '${body.meal.current} / ${body.meal.goal} 회',
                progress: mealP,
              ),
              const SizedBox(height: 10),

              MetricRow(
                iconPath: 'assets/home/sleep.svg',
                label: '수면',
                unitText: '${body.sleep.current} / ${body.sleep.goal} 시간',
                progress: sleepP,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _loadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD8D8D8), width: 1),
      ),
      child: const SizedBox(
        height: 110,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _emptyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD8D8D8)),
      ),
      child: const Text(
        '오늘의 바디 정보가 없어요.',
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14,
          color: Color(0xFF7D7C7C),
         ),
        ),
    );
  }

  Widget _errorCard(Object? error) {
    String msg = '오늘의 바디 정보를 불러오지 못했어요';

    if (error is DioException) {
      final status = error.response?.statusCode;

      if (status == 404 || status == 204) {
        msg = '오늘의 바디 정보가 없어요';
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD8D8D8), width: 1),
      ),
      child: Row(
        children: [
          Expanded(child: Text(msg)),
          TextButton(
            onPressed: _retry,
            child: const Text('재시도'),
          ),
        ],
      ),
    );
  }
}

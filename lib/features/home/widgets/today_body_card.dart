import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/dummy_body_status.dart';
import 'today_body_components.dart';

class TodayBodyCard extends StatelessWidget {
  const TodayBodyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final body = dummyBodyStatus;

    final completedCount = [
      body.water.progress,
      body.meal.progress,
      body.sleep.progress,
    ].where((p) => p >= 1.0).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD8D8D8),
          width: 1,
        ),
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
              StatusDots(
                completedCount: completedCount, 
              ),
            ],
          ),

          const SizedBox(height: 20),

          MetricRow(
            iconPath: 'assets/home/water.svg',
            label: '수분',
            unitText: '${body.water.current} / ${body.water.goal} ml',
            progress: body.water.progress,
          ),

          const SizedBox(height: 16),

          MetricRow(
            iconPath: 'assets/home/meal.svg',
            label: '식단',
            unitText: '${body.meal.current} / ${body.meal.goal} kcal',
            progress: body.meal.progress,
          ),

          const SizedBox(height: 16),

          MetricRow(
            iconPath: 'assets/home/sleep.svg',
            label: '수면',
            unitText: '${body.sleep.current} / ${body.sleep.goal}',
            progress: body.sleep.progress,
          ),
        ],
      ),
    );
  }
}

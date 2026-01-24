import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupChallengeCreatedPage extends StatelessWidget {
  final String groupCode;

  const GroupChallengeCreatedPage({super.key, required this.groupCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/challenge/close.png', // ✅ 닫기 아이콘
            width: 12,
            height: 12,
          ),
          onPressed: () {
            // 그룹 생성 플로우 종료 → 루트로
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                '그룹 챌린지를 만들었어요!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '함께 챌린지를 진행하고 싶은 친구들에게\n챌린지를 공유해 보세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF7D7C7C),
                ),
              ),

              const SizedBox(height: 40),

              /// 중앙 캐릭터 이미지
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    'assets/challenge/success.png',
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 그룹 코드 복사 버튼
              GestureDetector(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: groupCode));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('그룹 코드가 복사됐어요!')),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/challenge/group_copy.png',
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '그룹 코드 복사하기',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF747474),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

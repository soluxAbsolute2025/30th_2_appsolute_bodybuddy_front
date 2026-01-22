import 'package:flutter/material.dart';

import '../create/group/pages/group_challenge_type_page.dart';
import '../create/group/models/group_challenge_create_model.dart';

class CreateGroupChallengeBanner extends StatelessWidget {
  const CreateGroupChallengeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => GroupChallengeTypePage(model: GroupChallengeCreateModel()),
            ),
          );
        },
        child: Container(
          height: 140,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment(-0.0, -3.3),
              end: Alignment(1.0, 1.0), 
              colors: [
                Color(0xFFFDFAD4),
                Color(0xFF1EFAC0),
              ],
              stops: [
                0.2,
                0.8,
              ],
            ),
          ),
          child: Stack(
            children: [
              /// 왼쪽 텍스트 영역
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '찾으시는 챌린지가 없나요?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF707070),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '새로운 그룹 챌린지 만들기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '친구들과 함께\n목표를 달성해보세요!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFFFEF1),
                    ),
                  ),
                ],
              ),

              /// 오른쪽 화살표
              const Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Icon(
                    Icons.chevron_right,
                    size: 32,
                    color: Colors.white,
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

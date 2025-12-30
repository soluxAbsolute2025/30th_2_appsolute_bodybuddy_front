import 'package:flutter/material.dart';

class GroupCodeJoinButton extends StatelessWidget {
  final VoidCallback onTap;

  const GroupCodeJoinButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.17),
              blurRadius: 8.9,
              spreadRadius: -1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/challenge/group_join.png',
                  width: 18,
                  height: 18,
                ),
                SizedBox(width: 8),
                Text(
                  '그룹 코드로 참여',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            Image.asset(
              'assets/challenge/vector.png',
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

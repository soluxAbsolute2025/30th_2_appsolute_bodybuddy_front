import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupChallengeCreatedModal extends StatelessWidget {
  final String groupCode;
  const GroupChallengeCreatedModal({super.key, required this.groupCode});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '그룹 챌린지를 만들었어요!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              '함께 챌린지를 진행하고 싶은 친구들에게\n챌린지를 공유해 보세요',
              style: TextStyle(fontSize: 12, color: Color(0xFF7D7C7C)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF5F5F5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(groupCode,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: groupCode));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('그룹 코드가 복사됐어요')));
                    },
                    child: const Text('복사'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: groupCode));
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.ios_share_outlined),
                label: const Text('그룹 코드 복사하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

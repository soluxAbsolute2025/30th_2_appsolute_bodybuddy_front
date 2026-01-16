import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/group_challenge_create_model.dart';
import '../widgets/group_challenge_create_controller.dart';
import '../widgets/group_challenge_api.dart';
import '../widgets/group_challenge_created_modal.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/bottom_primary_button.dart';

class GroupChallengeInfoPage extends StatefulWidget {
  final GroupChallengeCreateModel model;
  const GroupChallengeInfoPage({super.key, required this.model});

  @override
  State<GroupChallengeInfoPage> createState() => _GroupChallengeInfoPageState();
}

class _GroupChallengeInfoPageState extends State<GroupChallengeInfoPage> {
  late final controller = GroupChallengeCreateController(widget.model);

  late final titleC = TextEditingController(text: widget.model.title);
  late final descC = TextEditingController(text: widget.model.description);
  late final imageC = TextEditingController(text: widget.model.imageUrl);

  bool isLoading = false;

  @override
  void dispose() {
    titleC.dispose();
    descC.dispose();
    imageC.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      widget.model.title = titleC.text;
      widget.model.description = descC.text;
      widget.model.imageUrl = imageC.text;

      final dio = Dio(BaseOptions(baseUrl: 'https://your-base-url.com'));
      final api = GroupChallengeApi(dio);

      final res = await api.create(widget.model);

      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => GroupChallengeCreatedModal(groupCode: res.groupCode),
      );

      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
    } on DioException catch (e) {
      if (!mounted) return;

      final status = e.response?.statusCode;
      final message = e.response?.data is Map
          ? (e.response?.data['message']?.toString() ?? e.message)
          : e.message;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('생성 실패${status != null ? ' ($status)' : ''}: $message')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('생성 실패: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.model.title = titleC.text;
    widget.model.description = descC.text;
    widget.model.imageUrl = imageC.text;

    final isValid = controller.isCreateValid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            'assets/challenge/back_vector.png',
            width: 24,
            height: 24,
          ),
        ),
        title: const Text(
          '그룹 챌린지 만들기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: 0,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '챌린지를 소개해 주세요',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 40),

            LabeledTextField(
              label: '챌린지 명',
              hint: '예) 함께 만보 걷기',
              controller: titleC,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),

            LabeledTextField(
              label: '챌린지 설명',
              hint: '예) 30일간 매일 10,000보 걷기',
              controller: descC,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),

            LabeledTextField(
              label: '이미지 업로드(선택)',
              hint: '이미지',
              controller: imageC,
              onChanged: (_) => setState(() {}),
            ),

            const Spacer(),
            BottomPrimaryButton(
              text: isLoading ? '생성 중...' : '챌린지 생성하기',
              isEnabled: isValid && !isLoading,
              onPressed: _create,
            ),
          ],
        ),
      ),
    );
  }
}

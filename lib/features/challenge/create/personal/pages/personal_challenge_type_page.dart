import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/personal_challenge_create_model.dart';
import '../widgets/personal_challenge_create_controller.dart';
import '../widgets/personal_challenge_options.dart';
import '../widgets/goal_type_tabs.dart';
import '../widgets/labeled_dropdown.dart';
import '../widgets/labeled_text_field.dart';
import 'personal_challenge_info_page.dart';
import '../widgets/number_formatter.dart';
import '../widgets/reward_action_bar.dart';
import 'personal_challenge_privacy_page.dart';

class PersonalChallengeTypePage extends StatefulWidget {
  const PersonalChallengeTypePage({super.key});

  @override
  State<PersonalChallengeTypePage> createState() =>
      _PersonalChallengeTypePageState();
}

class _PersonalChallengeTypePageState extends State<PersonalChallengeTypePage> {
  final model = PersonalChallengeCreateModel();
  late final controller = PersonalChallengeCreateController(model);

  final targetDaysController = TextEditingController();
  final dailyGoalController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _unitDropdownKey = GlobalKey();

  @override
  void dispose() {
    dailyGoalController.dispose();
    targetDaysController.dispose();
    super.dispose();
  }

  String _dailyGoalSuffix(String unit) {
    switch (unit) {
      case '걸음':
        return '보';
      case '분':
        return '분';
      case '회':
        return '회';
      case 'km':
        return 'km';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCountType = model.goalType == 'COUNT';
    final isValid = controller.isTypePageValid;
    final dailySuffix = _dailyGoalSuffix(model.unit);

    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light, 
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            'assets/challenge/back_vector.png',
            width: 24,
            height: 24,
          ),
        ),
        title: const Text(
          '개인 챌린지 만들기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(16),
          child: SizedBox(height: 16),
        ),
      ),

      bottomNavigationBar: RewardActionBar(
        xp: controller.rewardXp,
        enabled: isValid,
        onPressed: () {
          model.estimatedReward = controller.rewardXp;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PersonalChallengePrivacyPage(model: model),
            ),
          );
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: const _NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '목표 타입을 알려주세요',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 18),

                    GoalTypeTabs(
                      value: model.goalType,
                      onChanged: (v) => setState(() {
                        final value = v as String;
                        model.goalType = value;
                        if (v == 'COUNT') {
                          model.targetDays = null;
                          targetDaysController.clear();
                        }
                      }),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      isCountType
                          ? '매일 일정 횟수를 달성하는 방식이에요'
                          : '특정 기간 동안 목표를 달성하는 방식이에요',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7D7C7C),
                      ),
                    ),
                    const SizedBox(height: 40),

                    if (!isCountType) ...[
                      LabeledTextField(
                        label: '목표 일수',
                        hint: '최소 7일 이상으로 설정해 주세요',
                        controller: targetDaysController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        suffixText: '일',
                        onChanged: (value) {
                          final parsed = int.tryParse(value.trim());
                          model.targetDays = parsed;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 25),
                    ],

                    LabeledTextField(
                      label: isCountType ? '일일 횟수' : '일일 목표',
                      hint: isCountType ? '예) 10' : '10,000',
                      controller: dailyGoalController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        if (isCountType)
                          FilteringTextInputFormatter.digitsOnly
                        else
                          ThousandsSeparatorInputFormatter(),
                      ],
                      suffixText: dailySuffix,
                      onChanged: (value) {
                        final raw = isCountType
                            ? value.trim()
                            : value.replaceAll(',', '').trim();
                        final parsed = int.tryParse(raw);
                        model.dailyGoal = parsed;
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 25),

                    LabeledDropdown<String>(
                      key: _unitDropdownKey, 
                      label: '단위',
                      hint: '단위를 선택해주세요',
                      value: model.unit.isEmpty ? null : model.unit,
                      items: PersonalChallengeOptions.units
                          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (v) => setState(() => model.unit = v ?? ''),
                      onOpen: () async {
                        await Future.delayed(const Duration(milliseconds: 50));
                        final ctx = _unitDropdownKey.currentContext;
                        if (ctx != null) {
                          Scrollable.ensureVisible(
                            ctx,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            alignment: 0.0,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

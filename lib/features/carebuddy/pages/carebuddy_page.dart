import 'dart:async';

import 'package:bodybuddy_frontend/common/widgets/realtime_text_widget.dart';
import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/carebuddy/models/carebuddy_tag_suggest.dart';
import 'package:bodybuddy_frontend/features/carebuddy/widgets/carebuddy_bottom_buttons.dart';
import 'package:bodybuddy_frontend/features/carebuddy/widgets/carebuddy_top_content.dart';
import 'package:bodybuddy_frontend/features/carebuddy/widgets/chat_bubble_my.dart';
import 'package:bodybuddy_frontend/features/carebuddy/widgets/chat_bubble_ai.dart';
import 'package:bodybuddy_frontend/features/carebuddy/models/carebuddy_chat_model.dart';
import 'package:bodybuddy_frontend/features/carebuddy/providers/carebuddy_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:bodybuddy_frontend/features/carebuddy/providers/custom_ko_messages.dart';
import 'package:url_launcher/url_launcher.dart';

class CareBuddyPage extends StatefulWidget {
  final bool showFloating;
  const CareBuddyPage({super.key, this.showFloating = false});

  @override
  State<CareBuddyPage> createState() => _CareBuddyPageState();
}

class _CareBuddyPageState extends State<CareBuddyPage> {
  final textController = TextEditingController();
  final scrollController = ScrollController();
  // final String accessToken =
  //     "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJoYWhhaGEiLCJ1c2VySWQiOjM0MiwiaWF0IjoxNzY4OTY1OTYyLCJleHAiOjE3Njg5Njk1NjJ9.gV9nHhbTwARQSEJX2mCe7nfzb1cLsLVm99vIwLuKuQM";
  bool isButtonEnabled = false;
  int selectedIndex = -1;
  List<String> tags = ['다이어트', '운동', '수면', '스트레스'];
  final List<String> defaultAiMessages = [
    "다이어트 식단은 무리하지 않는 지속성이 가장 중요해요.\n\n단백질·채소를 중심으로 탄수화물은 줄이되 완전히 끊지 말고, 규칙적인 식사 시간을 지켜보세요.\n\n물 섭취와 충분한 수면이 체중 관리에 큰 도움을 줘요.",
    "스트레스 관리는 매일 조금씩 풀어내는 습관이 핵심이에요.\n\n하루 10분 가벼운 스트레칭이나 산책, 깊은 호흡만으로도 긴장이 완화돼요.\n\n잠들기 전 스마트폰 사용을 줄이면 회복력이 더 좋아져요.",
    "매일 반복되는 두통은 생활 리듬 점검이 먼저예요.\n\n수면 시간 고정, 물 자주 마시기, 장시간 같은 자세 피하기가 중요해요.\n\n통증이 지속되거나 심해진다면 꼭 전문의 상담을 받아보세요.",
  ];
  TagSuggest tagSuggest = TagSuggest(success: false, data: []);
  bool isLoading = false;

  final List<ChatMessage> _messages = [];
  int _defaultAiIndex = 0;

  @override
  void initState() {
    super.initState();

    // 한국어 메시지 설정
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    // 추천 질문 가지고 오기
    _getSuggest();

    textController.addListener(() {
      setState(() {
        isButtonEnabled = textController.text.isNotEmpty;
      });
    });
  }

  void _addDefaultAiMessages() {
    for (int i = 0; i < defaultAiMessages.length; i++) {
      _messages.add(
        ChatMessage(
          text: defaultAiMessages[i],
          sender: ChatSender.ai,
          createdAt: DateTime.now().add(Duration(seconds: i)),
        ),
      );
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _getSuggest() async {
    final result = await CarebuddyApi().getSuggest();

    if (!mounted) return;

    setState(() {
      tagSuggest = result;
      tags = result.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '케어버디 AI'),
      floatingActionButton: null,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarebuddyTopContent(),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 11.0,
                      // children: tags.map((tag) => _tagButton(tag)).toList(),
                      children: List.generate(
                        tags.length,
                        (index) => _tagButton(
                          index,
                          tags[index],
                          isSelected: index == selectedIndex,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.0),
                    RealTimeText(dateTime: DateTime.now()),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        if (message.sender == ChatSender.my) {
                          return MyChatBubble(message: message);
                        } else {
                          return AiChatBubble(message: message);
                        }
                      },
                    ),
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AI 프로필 원
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF5F5F5),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '답변을 준비 중이에요…',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        // 배경색과 둥근 모서리 설정
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5), // 연한 회색 배경
                          borderRadius: BorderRadius.circular(30.0), // 둥근 타원형
                        ),
                        child: TextField(
                          controller: textController,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            _sendMessage();
                          },
                          maxLines: 1,
                          style: const TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: '건강에 관해 궁금한 점을 물어보세요',
                            hintStyle: const TextStyle(
                              color: Color(0xFFA7A7A7),
                              fontSize: 14.0,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 12.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            // 2. TextField 내부에 전송 아이콘(SuffixIcon) 배치
                            suffixIcon: _textFieldButton(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                CarebuddyBottomButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage({String? tagText}) async {
    final text = tagText ?? textController.text.trim();

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          sender: ChatSender.my,
          createdAt: DateTime.now(),
        ),
      );
      isLoading = true;
    });

    textController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (_defaultAiIndex < defaultAiMessages.length) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: defaultAiMessages[_defaultAiIndex],
            sender: ChatSender.ai,
            createdAt: DateTime.now(),
          ),
        );
        _defaultAiIndex++;
        isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
      return;
    }

    final String answer = await CarebuddyApi().postMessage(text);
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: answer,
          sender: ChatSender.ai,
          createdAt: DateTime.now(),
        ),
      );
    });

    // 렌더링 끝난 다음 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Widget _tagButton(int index, String text, {bool isSelected = false}) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
        _sendMessage(tagText: text);
      },
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF1AEDB0),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: ShapeDecoration(
          color: isSelected ? Color(0xFF1AEDB0) : Color(0xFFE8FFF9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF4C4C4C),
            fontSize: 14,
            fontFamily: 'Pretendard Variable',
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _textFieldButton() {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFF669688),
          backgroundColor: isButtonEnabled
              ? Color(0xFF1AEDB1)
              : Color(0xFFF8F8F8),
          padding: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: CircleBorder(),
        ),
        onPressed: isButtonEnabled ? _sendMessage : null,
        child: SvgPicture.asset(
          isButtonEnabled
              ? 'assets/carebuddy/send_active.svg'
              : 'assets/carebuddy/send.svg',
          key: ValueKey(isButtonEnabled),
        ),
      ),
    );
  }
}

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
  final String accessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJoaWhpaGkiLCJ1c2VySWQiOjM0MSwiaWF0IjoxNzY4ODk4OTA2LCJleHAiOjE3Njg5MDI1MDZ9.un0Dkd-_81-PwTS6PmLoNfzNhmrbTNoUOre5mVvxdAI';

  bool isButtonEnabled = false;
  int selectedIndex = -1;
  List<String> tags = ['다이어트', '운동', '수면', '스트레스'];
  TagSuggest tagSuggest = TagSuggest(success: false, data: []);

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    _getSuggest();

    textController.addListener(() {
      setState(() {
        isButtonEnabled = textController.text.isNotEmpty;
      });
    });
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
    final result = await CarebuddyApi().getSuggest(accessToken);

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
                    Text(
                      '방금전',
                      style: TextStyle(
                        color: const Color(0xFFA6A6A6),
                        fontSize: 12,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                    // 1. Expanded를 사용해 TextField가 남은 너비를 꽉 채우게 합니다.
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
    });

    textController.clear();

    // 렌더링 끝난 다음 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    final String answer = await CarebuddyApi().postMessage(accessToken, text);
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

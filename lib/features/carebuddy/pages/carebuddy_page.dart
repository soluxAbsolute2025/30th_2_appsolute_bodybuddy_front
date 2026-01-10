import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CareBuddyPage extends StatefulWidget {
  final bool showFloating;
  const CareBuddyPage({super.key, this.showFloating = false});

  @override
  State<CareBuddyPage> createState() => _CareBuddyPageState();
}

class _CareBuddyPageState extends State<CareBuddyPage> {
  int selectedIndex = 0;
  List<String> tags = ['다이어트 식단 추천', '운동 후 근육통 완화', '수면 개선 방법', '스트레스 관리법'];
  List<String> subtags = ['운동', '영양', '질병', '정신건강'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '케어버디 AI'),
      floatingActionButton: null,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 41.0,
                      height: 41.0,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF5F5F5),
                        shape: CircleBorder(),
                      ),
                      child: Center(
                        child: Container(
                          width: 21,
                          height: 28,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/common/main_logo.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.0),
                    Text(
                      '안녕하세요, 케어버디입니다!\n무엇을 도와드릴까요?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 14.0),
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
                    Column(
                      spacing: 9.0,
                      children: [
                        _myChat('다이어트 식단 추천'),
                        _aiChat(
                          '좋은 질문이에요! 제가 도움을 드리겠습니다. 건강 관련 정보를 제공하기 위해 최선을 다하고 있어요.',
                        ),
                      ],
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
                            border: InputBorder.none, // 기본 밑줄 제거
                            // 2. TextField 내부에 전송 아이콘(SuffixIcon) 배치
                            suffixIcon: IconButton(
                              icon: SvgPicture.asset(
                                'assets/carebuddy/send.svg', // 전송 아이콘 경로
                                width: 20,
                                height: 20,
                              ),
                              onPressed: () {
                                print("전송 클릭!");
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    _subtag(
                      '운동',
                      'assets/carebuddy/tag1.svg',
                      0xFFDFFEFF,
                      0xFF00AEFF,
                    ),
                    _subtag(
                      '영양',
                      'assets/carebuddy/tag2.svg',
                      0xFFDDFFE3,
                      0xFF00D346,
                    ),
                    _subtag(
                      '질병',
                      'assets/carebuddy/tag3.svg',
                      0xFFFFDFDB,
                      0xFFEA441A,
                    ),
                    _subtag(
                      '정신 건강',
                      'assets/carebuddy/tag4.svg',
                      0xFFF8DFFF,
                      0xFF9000FF,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagButton(int index, String text, {bool isSelected = false}) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: Color(0x1188D3BD),
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

  Widget _myChat(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 19.0, vertical: 15.0),
            constraints: BoxConstraints(maxWidth: 300.0),
            decoration: BoxDecoration(
              color: Color(0xFF1AEDB0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '방금전',
            style: TextStyle(
              color: const Color(0xFFA6A6A6),
              fontSize: 12,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 9.0),
        ],
      ),
    );
  }

  Widget _aiChat(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: ShapeDecoration(
              color: const Color(0xFFF5F5F5),
              shape: CircleBorder(),
            ),
            child: Center(
              child: Container(
                width: 18.62,
                height: 24.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/common/main_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            constraints: BoxConstraints(maxWidth: 300.0),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '방금전',
            style: TextStyle(
              color: const Color(0xFFA6A6A6),
              fontSize: 12,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 25.0),
        ],
      ),
    );
  }

  Widget _subtag(
    String text,
    String imageUrl,
    int backgroundcolor,
    int textColor, {
    bool isSelected = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: ShapeDecoration(
            color: Color(backgroundcolor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(imageUrl),
              SizedBox(width: 10.0),
              Text(
                text,
                style: TextStyle(
                  color: Color(textColor),
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.0),
      ],
    );
  }
}

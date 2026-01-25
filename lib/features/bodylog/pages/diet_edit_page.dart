import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// 👇 불필요한 http, json, secure_storage import 모두 제거!
import '../data/diet_api_service.dart';
import '../data/diet_model.dart';

class DietEditPage extends StatefulWidget {
  final bool isEditMode; // 수정 모드 여부
  final DietRecord? record; // 수정 시 넘어오는 기존 데이터
  final DateTime? selectedDate; // 날짜 (생성 시 사용)
  final String? initialMealType; // "BREAKFAST", "LUNCH", "DINNER" (생성 시 기본값)

  const DietEditPage({
    super.key,
    this.isEditMode = false,
    this.record,
    this.selectedDate,
    this.initialMealType,
  });

  @override
  State<DietEditPage> createState() => _DietEditPageState();
}

class _DietEditPageState extends State<DietEditPage> {
  // 컨트롤러
  late TextEditingController _timeController;
  late TextEditingController _memoController;
  late TextEditingController _foodController;

  // 서비스 클래스 (이제 얘가 모든 통신을 담당)
  final DietApiService _apiService = DietApiService();
  final ImagePicker _picker = ImagePicker();

  String _selectedMealType = 'LUNCH'; // 기본값
  File? _imageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  // 데이터 초기화 로직 분리 (깔끔하게)
  void _initData() {
    // 1. 식사 종류(MealType) 설정
    if (widget.isEditMode && widget.record != null) {
      _selectedMealType = widget.record!.mealType;
    } else if (widget.initialMealType != null) {
      _selectedMealType = widget.initialMealType!;
    }

    // 2. 시간 설정 (기존 데이터 없으면 현재 시간)
    String timeValue = widget.record?.time ?? DateFormat('HH:mm').format(DateTime.now());
    _timeController = TextEditingController(text: timeValue);

    // 3. 메모 설정
    _memoController = TextEditingController(text: widget.record?.memo ?? '');

    // 4. 음식 목록 설정 (List -> String 변환)
    String foodsStr = widget.record?.foods.join(', ') ?? '';
    _foodController = TextEditingController(text: foodsStr);
  }

  @override
  void dispose() {
    _timeController.dispose();
    _memoController.dispose();
    _foodController.dispose();
    super.dispose();
  }

  // 이미지 선택
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = File(image.path));
    }
  }

  // 저장 (생성 또는 수정)
  Future<void> _save() async {
    if (_foodController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('메뉴를 입력해주세요.')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      List<String> foods = _foodController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // 날짜 포맷 (API Body 명세: "2025-12-23")
      String dateStr = DateFormat('yyyy-MM-dd').format(widget.selectedDate ?? DateTime.now());

      if (widget.isEditMode && widget.record != null) {
        // [수정 모드] API 명세서 Body 구조 반영
        final Map<String, dynamic> updateData = {
          "dietRecordId": widget.record!.id, // 수정할 기록 인덱스
          "mealType": _selectedMealType,
          "intakeDate": dateStr,
          "intakeTime": _timeController.text, // "12:20" 형태
          "foods": foods,
          "memo": _memoController.text,
          // 이미지는 서비스 클래스 내부에서 파일 유무에 따라 Multipart 등으로 처리됨
        };

        await _apiService.updateMeal(widget.record!.id, updateData);
      } else {
        // [생성 모드]
        await _apiService.createMeal(
          mealType: _selectedMealType,
          intakeDate: dateStr,
          intakeTime: _timeController.text,
          foods: foods,
          memo: _memoController.text,
          imageFile: _imageFile,
        );
      }

      if (mounted) Navigator.pop(context, true);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // 삭제
  Future<void> _delete() async {
    if (widget.record == null) return;

    // 삭제 확인 팝업
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("삭제 확인"),
        content: const Text("정말 삭제하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("취소")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("삭제", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isSaving = true);
      try {
        await _apiService.deleteMeal(widget.record!.id);
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('삭제 실패')));
        }
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? '식단 수정' : '식단 기록'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 식사 종류 선택 (라디오 버튼)
                const Text('식사 종류', style: TextStyle(fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildRadio('아침', 'BREAKFAST'),
                      _buildRadio('점심', 'LUNCH'),
                      _buildRadio('저녁', 'DINNER'),
                      _buildRadio('간식', 'SNACK'), // 간식도 필요하면 추가
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. 시간 입력
                const Text('시간', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "HH:mm",
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  readOnly: true, // 직접 입력 방지하고 시간 피커 띄우기 권장 (지금은 텍스트로 유지)
                  onTap: () async {
                    // 시간 선택 피커 (선택 사항)
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      final now = DateTime.now();
                      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                      _timeController.text = DateFormat('HH:mm').format(dt);
                    }
                  },
                ),

                const SizedBox(height: 20),

                // 3. 메뉴 입력
                const Text('메뉴 (쉼표로 구분)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _foodController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "예: 닭가슴살, 현미밥, 샐러드"
                  ),
                ),

                const SizedBox(height: 20),

                // 4. 메모 입력
                const Text('메모', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _memoController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "오늘 식단의 특이사항을 기록하세요."
                  ),
                ),

                const SizedBox(height: 20),

                // 5. 사진 업로드
                const Text('사진', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _buildImagePreview(),
                  ),
                ),

                const SizedBox(height: 30),

                // 6. 저장 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4BECBE)),
                    child: const Text('저장하기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                // 7. 삭제 버튼 (수정 모드일 때만)
                if (widget.isEditMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: _delete,
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(child: Text("삭제하기", style: TextStyle(color: Colors.red))),
                      ),
                    ),
                  )
              ],
            ),
          ),

          // 로딩 인디케이터
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // 라디오 버튼 위젯 빌더
  Widget _buildRadio(String label, String value) {
    return Row(children: [
      Radio<String>(
        value: value,
        groupValue: _selectedMealType,
        onChanged: (v) => setState(() => _selectedMealType = v!),
        activeColor: const Color(0xFF4BECBE),
      ),
      Text(label),
      const SizedBox(width: 10),
    ]);
  }

  // 이미지 미리보기 위젯 빌더
  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(_imageFile!, fit: BoxFit.cover),
      );
    } else if (widget.record?.imageUrl != null && widget.record!.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          widget.record!.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (ctx, _, __) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        ),
      );
    } else {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, color: Colors.grey, size: 40),
          SizedBox(height: 8),
          Text("사진을 등록하려면 터치하세요", style: TextStyle(color: Colors.grey)),
        ],
      );
    }
  }
}
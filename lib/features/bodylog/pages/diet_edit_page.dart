import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../data/diet_api_service.dart';
import '../data/diet_model.dart';
import 'dart:convert'; // jsonEncode 사용
import 'package:http/http.dart' as http; // http 패키지
import 'package:http_parser/http_parser.dart'; // MediaType 사용 (핵심)
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DietEditPage extends StatefulWidget {
  final bool isEditMode;
  final DietRecord? record;
  final DateTime? selectedDate;
  final String? initialMealType; // "LUNCH" 등 초기값

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
  final DietApiService _apiService = DietApiService();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _timeController;
  late TextEditingController _memoController;
  late TextEditingController _foodController;

  String _selectedMealType = 'LUNCH';
  File? _imageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();


    // 시간 초기값
    String initialTime = widget.isEditMode
        ? widget.record!.intakeTime
        : DateFormat('HH:mm').format(DateTime.now());

    _timeController = TextEditingController(text: initialTime);
    _memoController = TextEditingController(text: widget.record?.memo ?? '');

    String foodsStr = widget.record?.foods.join(', ') ?? '';
    _foodController = TextEditingController(text: foodsStr);

    // 식사 종류 초기값 (넘겨받은 값이 있으면 그걸로 설정)
    if (widget.isEditMode && widget.record != null) {
      _selectedMealType = widget.record!.mealType;
    } else if (widget.initialMealType != null) {
      _selectedMealType = widget.initialMealType!;
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    _memoController.dispose();
    _foodController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = File(image.path));
    }
  }

  Future<void> _save() async {
    // 1. 유효성 검사
    if (_foodController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('메뉴를 입력해주세요.')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      List<String> foods = _foodController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      if (widget.isEditMode) {
        // 수정 모드
        await _apiService.updateMeal(widget.record!.dietRecordId, {
          "mealType": _selectedMealType,
          "intakeTime": _timeController.text,
          "memo": _memoController.text,
          "foods": foods,
        });
      } else {
        // 생성 모드 (이제 여기서 _apiService만 부르면 끝!)
        String dateStr = DateFormat('yyyy-MM-dd').format(widget.selectedDate ?? DateTime.now());

        await _apiService.createMeal(
          mealType: _selectedMealType,
          intakeDate: dateStr,
          intakeTime: _timeController.text,
          foods: foods,
          memo: _memoController.text,
          imageFile: _imageFile,
        );
      }

      // 성공 시
      if (mounted) Navigator.pop(context, true);

    } catch (e) {
      // 실패 시
      print("에러 발생: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('저장 실패: 로그인을 다시 해주세요.')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    if (widget.record != null) {
      await _apiService.deleteMeal(widget.record!.dietRecordId);
      if (mounted) Navigator.pop(context, true);
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
                const Text('식사 종류', style: TextStyle(fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildRadio('아침', 'BREAKFAST'),
                      _buildRadio('점심', 'LUNCH'),
                      _buildRadio('저녁', 'DINNER')
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text('시간', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(controller: _timeController, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "HH:mm")),

                const SizedBox(height: 20),
                const Text('메뉴 (쉼표 구분)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(controller: _foodController, decoration: const InputDecoration(border: OutlineInputBorder())),

                const SizedBox(height: 20),
                const Text('사진', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      image: _imageFile != null
                          ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                          : (widget.record?.imageUrl != null)
                          ? DecorationImage(image: NetworkImage(widget.record!.imageUrl!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: (_imageFile == null && widget.record?.imageUrl == null)
                        ? const Center(child: Icon(Icons.camera_alt, color: Colors.grey))
                        : null,
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4BECBE)),
                    child: const Text('저장하기', style: TextStyle(color: Colors.white)),
                  ),
                ),
                if (widget.isEditMode)
                  TextButton(
                    onPressed: _delete,
                    child: const Center(child: Text("삭제하기", style: TextStyle(color: Colors.red))),
                  )
              ],
            ),
          ),
          if (_isSaving) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

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
}
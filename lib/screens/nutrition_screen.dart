import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/section_title.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  // --- MOCK DATA ---
  String selectedDay = 'THỨ SÁU';
  final List<String> days = ['THỨ HAI', 'THỨ BA', 'THỨ TƯ', 'THỨ NĂM', 'THỨ SÁU', 'THỨ BẢY', 'CHỦ NHẬT'];

  // Tổng quan calo
  final int targetCalories = 2000;
  final int consumedCalories = 1250;

  // Macro hiện tại
  final int consumedProtein = 45;
  final int targetProtein = 75;
  final int consumedCarb = 120;
  final int targetCarb = 240;
  final int consumedFat = 35;
  final int targetFat = 50;

  // Danh sách các cữ ăn (Sử dụng màu từ AppTheme)
  late final List<Map<String, dynamic>> meals;

  @override
  void initState() {
    super.initState();
    // Khởi tạo data trong initState để có thể truy cập AppTheme an toàn
    meals = [
      {
        'title': 'Bữa sáng',
        'subtitle': 'Bánh mì trứng',
        'time': '08:00',
        'calories': '350 kcal',
        'items': ['Bánh mì (1 ổ)', 'Trứng ốp la (2 quả)'],
        'icon': Icons.free_breakfast_rounded,
        'color': AppTheme.orange,
        'background': const Color(0xFFFFF5E8)
      },
      {
        'title': 'Bữa trưa',
        'subtitle': 'Cơm gà',
        'time': '12:30',
        'calories': '650 kcal',
        'items': ['Cơm trắng (1 chén)', 'Đùi gà luộc (1 cái)'],
        'icon': Icons.lunch_dining_rounded,
        'color': AppTheme.primary,
        'background': AppTheme.lightGreen,
      },
      {
        'title': 'Bữa tối',
        'subtitle': 'Chưa thêm món ăn',
        'time': '19:00',
        'calories': '0 kcal',
        'items': [],
        'icon': Icons.dinner_dining_rounded,
        'color': AppTheme.blue,
        'background': const Color(0xFFEAF5FD),
      },
      {
        'title': 'Bữa phụ',
        'subtitle': 'Sữa chua',
        'time': '21:30',
        'calories': '250 kcal',
        'items': ['Sữa chua không đường (1 hộp)'],
        'icon': Icons.icecream_rounded,
        'color': AppTheme.pink,
        'background': const Color(0xFFFFF0F3),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Nền sáng nhẹ
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dinh dưỡng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_rounded, color: Colors.black54),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theo dõi bữa ăn và dinh dưỡng mỗi ngày.',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            _buildDaySelector(),
            const SizedBox(height: 20),
            _buildNutritionSummary(),
            const SizedBox(height: 26),
            const SectionTitle(title: 'Các bữa ăn'),
            const SizedBox(height: 12),
            _buildMealList(),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Dinh dưỡng hôm nay'),
            const SizedBox(height: 12),
            _buildMacroCard(
              title: 'Protein',
              current: consumedProtein,
              target: targetProtein,
              color: AppTheme.primary,
            ),
            _buildMacroCard(
              title: 'Carbohydrate',
              current: consumedCarb,
              target: targetCarb,
              color: AppTheme.orange,
            ),
            _buildMacroCard(
              title: 'Chất béo',
              current: consumedFat,
              target: targetFat,
              color: AppTheme.pink,
            ),
          ],
        ),
      ),
    );
  }

  // 1. THANH CHỌN NGÀY
  Widget _buildDaySelector() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          bool isSelected = days[index] == selectedDay;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = days[index];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: Text(
                days[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 2. THẺ TỔNG QUAN NĂNG LƯỢNG
  Widget _buildNutritionSummary() {
    double progress = (consumedCalories / targetCalories).clamp(0.0, 1.0);
    int remaining = targetCalories - consumedCalories;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng năng lượng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$consumedCalories',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6, left: 6),
                child: Text(
                  'kcal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Mục tiêu: $targetCalories kcal',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0x66FFFFFF),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'Còn lại $remaining kcal',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // 3. DANH SÁCH BỮA ĂN (Tích hợp hiệu ứng mở rộng khi có món ăn)
  Widget _buildMealList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        var meal = meals[index];
        bool hasItems = (meal['items'] as List).isNotEmpty;
        return _buildMealCard(meal: meal, hasItems: hasItems);
      },
    );
  }

  Widget _buildMealCard({required Map<String, dynamic> meal, required bool hasItems}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: hasItems
            ? Border.all(color: meal['color'].withOpacity(0.3), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: meal['background'],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(meal['icon'], color: meal['color'], size: 25),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal['title'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal['subtitle'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    meal['calories'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Icon(
                    Icons.add_circle_outline_rounded,
                    size: 21,
                    color: AppTheme.primary,
                  ),
                ],
              ),
            ],
          ),
          if (hasItems) ...[
            const Padding(
              padding: EdgeInsets.only(top: 12, bottom: 8),
              child: Divider(color: Color(0xFFEEEEEE), height: 1),
            ),
            ...((meal['items'] as List).map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: meal['color'], size: 5),
                      const SizedBox(width: 8),
                      Text(
                        item,
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ))),
          ]
        ],
      ),
    );
  }

  // 4. THẺ MACRO DINH DƯỠNG
  Widget _buildMacroCard({
    required String title,
    required int current,
    required int target,
    required Color color,
  }) {
    double progress = (current / target).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Text(
                '${current}g / ${target}g',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: color.withOpacity(0.13),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
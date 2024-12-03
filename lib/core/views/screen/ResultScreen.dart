import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 234, 234), // الخلفية الداكنة
      appBar: AppBar(
        backgroundColor: Color(0xFF004651),
        elevation: 0,
        title: const Text(
          'تحليل الأداء',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // مؤشر الأداء العام
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: 0.60, // 65%
                            strokeWidth: 8,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF004651),
                            ),
                            backgroundColor: Colors.grey.shade800,
                          ),
                        ),
                        const Text(
                          '60%',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004651),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'IFRS درجة التوافق مع معيار',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004651),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'المعايير المتوافقة',
                      style: TextStyle(
                        color: Color(0xFF004651),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // البطاقات الأربع
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                padding: const EdgeInsets.all(16),
                shrinkWrap:
                    true, // يجعل GridView قابلة للسكرول داخل SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // تعطيل سكرول GridView فقط
                children: const [
                  PerformanceCard(
                    dis: "تبني معايير التقارير ",
                    title: 'IFRS 1',
                    progress: 0.7,
                    color: Colors.blue,
                  ),
                  PerformanceCard(
                    dis: "الدفع على أساس الأسهم",
                    title: 'IFRS 2',
                    progress: 0.5,
                    color: Colors.red,
                  ),
                  PerformanceCard(
                    dis: "دمج الأعمال",
                    title: 'IFRS 3',
                    progress: 0.6,
                    color: Colors.green,
                  ),
                  PerformanceCard(
                    dis: " عقود التأمين",
                    title: 'IFRS 1',
                    progress: 0.9,
                    color: Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // الشبكة الخاصة بالشخصيات
              CharacterGrid(),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // قائمة الأخطاء والانحرافات
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'الأخطاء والانحرافات',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF004651),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          ErrorCard(
                            error: "القيم غير الصحيحة في التقرير المالي",
                            location: "صفحة 3، العمود 5",
                            cause: "بيانات الإدخال غير دقيقة",
                            recommendation: "مراجعة البيانات المالية المصدرية.",
                          ),
                          SizedBox(height: 8),
                          ErrorCard(
                            error: "الفجوات بين المعايير والمتطلبات",
                            location: "تقرير التدفقات النقدية",
                            cause: "عدم اتباع التعليمات المحددة",
                            recommendation:
                                "إعادة ضبط التنسيق حسب معيار IFRS 2.",
                          ),
                          SizedBox(height: 8),
                          ErrorCard(
                            error: "تكرار أو تضارب البيانات",
                            location: "تقرير المصاريف التشغيلية",
                            cause: "إدخال مزدوج للبيانات",
                            recommendation:
                                "إزالة البيانات المتكررة وإعادة التحقق.",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'توصيات لتحسين الأداء',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF004651),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '- مراجعة تقارير الأداء بانتظام لتحسين الكفاءة.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF004651),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '- التركيز على المعايير ذات النسبة الأقل لتحسينها.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF004651),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '- الاستفادة من التدريب والدعم الفني لفهم المعايير.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF004651),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // الرسوم البيانية للأداء المالي
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'الأداء المالي',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF004651),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: FinancialChart(),
                    ),
                    const Text(
                      'تحتاج استشارة مع مستشارنا الذكي؟',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF004651),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/chat");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF004651),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'المستشار الذكي',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PerformanceCard extends StatelessWidget {
  final String title;
  final String dis;
  final double progress;
  final Color color;

  const PerformanceCard({
    Key? key,
    required this.title,
    required this.dis,
    required this.progress,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // خلفية البطاقة
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  color: color,
                  backgroundColor: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progress * 100).toInt()}%', // النص الرقمي
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            dis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // إضافة وظيفة لتحسين الأداء
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'التفاصل',
              style: TextStyle(
                color: Color(0xFF004651),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CharacterGrid extends StatelessWidget {
  final List<Map<String, String>> characters = [
    {'name': 'الجوكر', 'image': "assets/images/car1.webp"},
    {'name': 'هانيبال ليكتر', 'image': 'assets/images/car2.webp'},
  ];

  CharacterGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'المعايير غير المتوافقة',
            style: TextStyle(
              color: Color(0xFF004651),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          padding: const EdgeInsets.all(16),
          shrinkWrap:
              true, // يجعل GridView قابلة للسكرول داخل SingleChildScrollView
          physics:
              const NeverScrollableScrollPhysics(), // تعطيل سكرول GridView فقط
          children: const [
            PerformanceCard(
              dis: "القطاعات التشغيلية",
              title: 'IFRS 8',
              progress: 0.3,
              color: Colors.blue,
            ),
            PerformanceCard(
              dis: "الأدوات المالية",
              title: 'IFRS 9',
              progress: 0.4,
              color: Colors.red,
            ),
            PerformanceCard(
              dis: "القوائم المالية الموحدة",
              title: 'IFRS 10',
              progress: 0.2,
              color: Colors.green,
            ),
            PerformanceCard(
              dis: "الترتيبات المشتركة",
              title: 'IFRS 11',
              progress: 0.3,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}

class CharacterCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const CharacterCard({
    Key? key,
    required this.name,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: 150,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorCard extends StatelessWidget {
  final String error;
  final String location;
  final String cause;
  final String recommendation;

  const ErrorCard({
    Key? key,
    required this.error,
    required this.location,
    required this.cause,
    required this.recommendation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              error,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "الموقع: $location",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              "السبب: $cause",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              "التوصيات: $recommendation",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class FinancialChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 50, // قيمة الإيرادات
                color: Colors.blue,
                width: 20,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 35, // قيمة المصروفات
                color: Colors.red,
                width: 20,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: 15, // قيمة الأرباح
                color: Colors.green,
                width: 20,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('الإيرادات');
                  case 1:
                    return const Text('المصروفات');
                  case 2:
                    return const Text('الأرباح');
                  default:
                    return const Text('');
                }
              },
              reservedSize: 40,
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()}%',
                TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final int value;
  final Color color;

  ChartData(this.category, this.value, this.color);
}

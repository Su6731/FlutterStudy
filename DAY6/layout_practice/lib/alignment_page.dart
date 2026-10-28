import 'package:flutter/material.dart';

/// 任务一：对齐任务卡 —— 六种主/交叉轴对齐场景，逐一标注参数。
class AlignmentPage extends StatelessWidget {
  const AlignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('任务一 对齐任务卡')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ScenarioCard(
            title: '场景1 Row：mainAxis=start / cross=start',
            axis: Axis.horizontal,
            mainAxis: MainAxisAlignment.start,
            crossAxis: CrossAxisAlignment.start,
          ),
          _ScenarioCard(
            title: '场景2 Row：mainAxis=center / cross=center',
            axis: Axis.horizontal,
            mainAxis: MainAxisAlignment.center,
            crossAxis: CrossAxisAlignment.center,
          ),
          _ScenarioCard(
            title: '场景3 Row：mainAxis=spaceBetween / cross=center',
            axis: Axis.horizontal,
            mainAxis: MainAxisAlignment.spaceBetween,
            crossAxis: CrossAxisAlignment.center,
          ),
          _ScenarioCard(
            title: '场景4 Row：mainAxis=spaceAround / cross=end',
            axis: Axis.horizontal,
            mainAxis: MainAxisAlignment.spaceAround,
            crossAxis: CrossAxisAlignment.end,
          ),
          _ScenarioCard(
            title: '场景5 Row：mainAxis=spaceEvenly / cross=center',
            axis: Axis.horizontal,
            mainAxis: MainAxisAlignment.spaceEvenly,
            crossAxis: CrossAxisAlignment.center,
          ),
          _ScenarioCard(
            title: '场景6 Column：mainAxis=spaceEvenly / cross=center',
            axis: Axis.vertical,
            mainAxis: MainAxisAlignment.spaceEvenly,
            crossAxis: CrossAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final String title;
  final Axis axis;
  final MainAxisAlignment mainAxis;
  final CrossAxisAlignment crossAxis;

  const _ScenarioCard({
    required this.title,
    required this.axis,
    required this.mainAxis,
    required this.crossAxis,
  });

  @override
  Widget build(BuildContext context) {
    final boxes = [
      _box(Colors.red, 40),
      _box(Colors.green, 56),
      _box(Colors.blue, 32),
    ];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              // Column 场景三盒总高 128，演示框需给足高度，否则主轴溢出
              height: axis == Axis.horizontal ? 120 : 200,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: axis == Axis.horizontal
                  ? Row(
                      mainAxisAlignment: mainAxis,
                      crossAxisAlignment: crossAxis,
                      children: boxes,
                    )
                  : Column(
                      mainAxisAlignment: mainAxis,
                      crossAxisAlignment: crossAxis,
                      children: boxes,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _box(Color color, double size) =>
      Container(width: size, height: size, color: color);
}

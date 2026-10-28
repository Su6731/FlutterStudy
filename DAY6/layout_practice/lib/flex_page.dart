import 'package:flutter/material.dart';

/// 任务二：弹性分配实验 —— 三栏 2:1:1 布局，以及一栏内容超长时的表现记录。
class FlexPage extends StatelessWidget {
  const FlexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('任务二 弹性分配实验')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('实验A：三栏 Expanded(flex: 2:1:1)',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: Row(
              children: [
                Expanded(flex: 2, child: _block(Colors.indigo, 'flex:2')),
                const SizedBox(width: 8),
                Expanded(flex: 1, child: _block(Colors.teal, 'flex:1')),
                const SizedBox(width: 8),
                Expanded(flex: 1, child: _block(Colors.orange, 'flex:1')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('实验B：flex:2 一栏放入超长文本',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _block(
                    Colors.indigo,
                    '超长内容：' * 12, // 观察文本在本栏内换行
                    alignTop: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(flex: 1, child: _block(Colors.teal, 'flex:1')),
                const SizedBox(width: 8),
                Expanded(flex: 1, child: _block(Colors.orange, 'flex:1')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '表现记录：Expanded 按 flex 比例分配主轴剩余空间（本行总宽扣除间距后 '
                '2:1:1）。flex:2 一栏内容超长时，Expanded 已把宽度约束传给子组件，'
                'Text 在本栏内换行、不侵占其他栏；若去掉 Expanded，长内容按自身尺寸'
                '报告宽度，超出 Row 约束即触发 RenderFlex 溢出（黄黑条警告）。',
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _block(Color color, String text, {bool alignTop = false}) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(8),
      color: color.withValues(alpha: 0.85),
      alignment: alignTop ? Alignment.topLeft : Alignment.center,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

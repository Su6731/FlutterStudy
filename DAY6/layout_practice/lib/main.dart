import 'package:flutter/material.dart';
import 'alignment_page.dart';
import 'flex_page.dart';
import 'stack_page.dart';
import 'decor_page.dart';

void main() {
  runApp(const LayoutPracticeApp());
}

class LayoutPracticeApp extends StatelessWidget {
  const LayoutPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '布局自主实践',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('任务一 对齐任务卡（六种场景）', Icons.grid_on, const AlignmentPage()),
      ('任务二 弹性分配实验（2:1:1）', Icons.view_column, const FlexPage()),
      ('任务三 层叠角标（两个场景）', Icons.layers, const StackPage()),
      ('任务四 容器美化（卡片）', Icons.credit_card, const DecorPage()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('6.2 自主实践')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final (title, icon, page) = items[i];
          return Card(
            child: ListTile(
              leading: Icon(icon),
              title: Text(title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              ),
            ),
          );
        },
      ),
    );
  }
}

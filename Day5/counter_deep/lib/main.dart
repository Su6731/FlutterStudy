import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'counter_deep 计数器',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      useMaterial3: true,
    ),
    home: const CounterPage(title: 'counter_deep 计数器'),
  );
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.title});
  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;
  int _step = 1;

  void _increment() {
    setState(() {
      _count += _step;
    });
  }

  void _changeStep(int value) {
    setState(() {
      _step = value;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      title: Text(widget.title),
      actions: [
        PopupMenuButton<int>(
          tooltip: '选择步长',
          initialValue: _step,
          onSelected: _changeStep,
          itemBuilder: (context) => const [
            PopupMenuItem(value: 1, child: Text('步长 1')),
            PopupMenuItem(value: 2, child: Text('步长 2')),
            PopupMenuItem(value: 5, child: Text('步长 5')),
          ],
          icon: const Icon(Icons.tune),
        ),
      ],
    ),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('你已经累计了这么多次进步：'),
            Text(
              '$_count',
              key: const ValueKey('count'),
              style: Theme.of(context).textTheme.displayMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              '当前步长：$_step',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            const Text('右上角选择 1 / 2 / 5，点击 + 累加'),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _increment,
      tooltip: '增加 $_step',
      child: const Icon(Icons.add),
    ),
  );
}

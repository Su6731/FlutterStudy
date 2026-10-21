import 'package:counter_deep/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('图片资源可解码且窄屏没有布局溢出', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final data = await rootBundle.load('assets/images/counter_banner.png');
    expect(data.lengthInBytes, greaterThan(0));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('生命周期覆盖挂载、配置更新、依赖变化和销毁', (tester) async {
    final logs = <String>[];
    final original = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) logs.add(message);
      original(message, wrapWidth: wrapWidth);
    };
    try {
      Widget host(String title, Color color) => MaterialApp(
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: color)),
        home: CounterPage(title: title),
      );
      await tester.pumpWidget(host('初始标题', Colors.teal));
      await tester.pumpAndSettle();
      expect(logs.take(3).map((s) => s.split(' ')[1]), [
        'initState',
        'didChangeDependencies',
        'build',
      ]);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      logs.clear();
      await tester.pumpWidget(host('更新标题', Colors.teal));
      await tester.pumpAndSettle();
      expect(logs.any((s) => s.contains('didUpdateWidget')), isTrue);
      expect(find.text('1'), findsOneWidget);
      logs.clear();
      await tester.pumpWidget(host('更新标题', Colors.orange));
      await tester.pumpAndSettle();
      expect(logs.any((s) => s.contains('didChangeDependencies')), isTrue);
      logs.clear();
      await tester.pumpWidget(const SizedBox.shrink());
      expect(logs.map((s) => s.split(' ')[1]), ['deactivate', 'dispose']);
    } finally {
      debugPrint = original;
    }
  });

  testWidgets('选择步长不改变累计值，FAB 按 1/2/5 累加', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    for (final entry in [(2, '3'), (5, '8'), (1, '9')]) {
      final before = tester
          .widget<Text>(find.byKey(const ValueKey('count')))
          .data;
      await tester.tap(find.byTooltip('选择步长'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('步长 ${entry.$1}'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('count'))).data,
        before,
      );
      expect(find.text('当前步长：${entry.$1}'), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.text(entry.$2), findsOneWidget);
    }
  });

  testWidgets('主题种子是 teal 且 AppBar 取用主题色', (tester) async {
    await tester.pumpWidget(const MyApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(
      app.theme!.colorScheme,
      ColorScheme.fromSeed(seedColor: Colors.teal),
    );
    final bar = tester.widget<AppBar>(find.byType(AppBar));
    expect(bar.backgroundColor, app.theme!.colorScheme.primaryContainer);
  });
}

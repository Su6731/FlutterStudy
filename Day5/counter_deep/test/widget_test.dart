import 'package:counter_deep/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

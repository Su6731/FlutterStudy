import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layout_practice/main.dart';
import 'package:layout_practice/alignment_page.dart';
import 'package:layout_practice/flex_page.dart';
import 'package:layout_practice/stack_page.dart';
import 'package:layout_practice/decor_page.dart';

void main() {
  testWidgets('首页列出四个任务入口', (tester) async {
    await tester.pumpWidget(const LayoutPracticeApp());
    expect(find.text('任务一 对齐任务卡（六种场景）'), findsOneWidget);
    expect(find.text('任务二 弹性分配实验（2:1:1）'), findsOneWidget);
    expect(find.text('任务三 层叠角标（两个场景）'), findsOneWidget);
    expect(find.text('任务四 容器美化（卡片）'), findsOneWidget);
  });

  testWidgets('任务一：六种对齐场景全部呈现', (tester) async {
    // 加高测试视口，让六张场景卡全部进入 ListView 构建范围
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: AlignmentPage()));
    for (var i = 1; i <= 6; i++) {
      expect(find.textContaining('场景$i'), findsOneWidget);
    }
    expect(find.textContaining('spaceBetween'), findsOneWidget);
    expect(find.textContaining('spaceEvenly'), findsNWidgets(2));
  });

  testWidgets('任务二：三栏宽度比为 2:1:1', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: FlexPage()));
    final flexes = tester
        .widgetList<Expanded>(find.byType(Expanded))
        .map((e) => e.flex)
        .toList();
    expect(flexes, [2, 1, 1, 2, 1, 1]); // 实验A 与 实验B 各一组

    // 实测实验A三个色块宽度比例约 2:1:1
    final blocks = tester
        .widgetList<Expanded>(find.byType(Expanded))
        .take(3)
        .map((e) => tester.getSize(find.byWidget(e)).width)
        .toList();
    expect(blocks[0] / blocks[1], closeTo(2.0, 0.05));
    expect(blocks[2] / blocks[1], closeTo(1.0, 0.05));

    // 实验B：超长文本存在且未触发溢出（pump 成功即无 RenderFlex 异常）
    expect(find.textContaining('超长内容'), findsOneWidget);
  });

  testWidgets('任务三：头像徽标与图片浮层文字', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: StackPage()));
    expect(find.text('场景1：头像右下角徽标'), findsOneWidget);
    expect(find.textContaining('场景2'), findsOneWidget);
    // 徽标 Positioned(right:0, bottom:0)
    expect(
      find.byWidgetPredicate(
          (w) => w is Positioned && w.right == 0 && w.bottom == 0),
      findsOneWidget,
    );
    // 图片浮层文字 Positioned(left:12, bottom:12)
    expect(
      find.byWidgetPredicate(
          (w) => w is Positioned && w.left == 12 && w.bottom == 12),
      findsOneWidget,
    );
    expect(find.text('校园日落 · 摄于图书馆前'), findsOneWidget);
  });

  testWidgets('任务四：至少两处圆角+阴影卡片', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DecorPage()));
    final decorated = find
        .byType(Container)
        .evaluate()
        .map((e) => e.widget as Container)
        .where((c) {
          final d = c.decoration;
          return d is BoxDecoration &&
              d.borderRadius != null &&
              d.boxShadow != null &&
              d.boxShadow!.isNotEmpty;
        })
        .toList();
    expect(decorated.length, greaterThanOrEqualTo(2));
    expect(find.text('系统通知'), findsOneWidget);
    expect(find.text('12.5 小时'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile_card/main.dart';

void main() {
  testWidgets('骨架包含头像/姓名/签名/统计条/标签云', (tester) async {
    await tester.pumpWidget(const ProfileCardApp());

    // 头像区、姓名与签名
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('李晓明'), findsOneWidget);
    expect(find.text('Flutter 学习者 · 热爱开源与分享'), findsOneWidget);

    // 统计条：三个 Expanded 数字块
    expect(find.byType(Expanded), findsNWidgets(3));
    expect(find.text('128'), findsOneWidget);
    expect(find.text('256'), findsOneWidget);
    expect(find.text('32'), findsOneWidget);
    expect(find.text('关注'), findsOneWidget);
    expect(find.text('粉丝'), findsOneWidget);
    expect(find.text('动态'), findsOneWidget);

    // 标签云
    expect(find.byType(Wrap), findsOneWidget);
    expect(find.text('摄影'), findsOneWidget);

    // 步骤二：Stack + Positioned 在线状态徽标（验证右下角绿色圆点）
    final positioned = tester.widget<Positioned>(find.byWidgetPredicate(
      (w) => w is Positioned && w.right == 0 && w.bottom == 0,
    ));
    final badge = positioned.child as Container;
    final decoration = badge.decoration as BoxDecoration;
    expect(decoration.color, Colors.green);
    expect(decoration.shape, BoxShape.circle);
  });

  testWidgets('步骤三验收：360px 窄屏无 RenderFlex 溢出且统计条等分', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // 若存在 RenderFlex 溢出，pumpWidget 阶段即抛异常导致测试失败
    await tester.pumpWidget(const ProfileCardApp());

    // 三个 Expanded 数字块等宽（flex 均为 1）
    final sizes = find
        .byType(Expanded)
        .evaluate()
        .map((e) => e.size!.width)
        .toList();
    expect(sizes.length, 3);
    expect(sizes[0], closeTo(sizes[1], 0.5));
    expect(sizes[1], closeTo(sizes[2], 0.5));
  });
}

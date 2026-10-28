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
  });
}

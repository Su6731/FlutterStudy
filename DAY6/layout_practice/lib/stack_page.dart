import 'package:flutter/material.dart';

/// 任务三：层叠角标 —— 头像右下角徽标 + 图片浮层文字两个场景。
class StackPage extends StatelessWidget {
  const StackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('任务三 层叠角标')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('场景1：头像右下角徽标',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('场景2：图片浮层文字（本地资产 banner.png）',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/banner.png',
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    color: Colors.black54,
                    child: const Text(
                      '校园日落 · 摄于图书馆前',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '要点：Stack children 自底向顶绘制；Positioned 子项用 '
                'left/top/right/bottom 定位且不参与 Stack 尺寸计算，'
                '非 Positioned 子项（底图、头像）参与尺寸计算并按 alignment 对齐。',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

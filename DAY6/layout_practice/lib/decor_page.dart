import 'package:flutter/material.dart';

/// 任务四：容器美化 —— 圆角/阴影/留白卡片两处以上。
class DecorPage extends StatelessWidget {
  const DecorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('任务四 容器美化')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 卡片一：白底圆角 + 阴影 + 留白（信息行）
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.notifications)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('系统通知',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('本周实验报告截止时间为周五 18:00',
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 卡片二：渐变底 + 圆角 + 阴影（统计卡）
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('本周学习时长',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 8),
                Text('12.5 小时',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 卡片三：描边留白卡（BoxDecoration border）
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.shade100),
            ),
            child: const Text(
              '要点：Container 是组合器（color/padding/margin/border/shadow/渐变）；'
              'color 与 decoration 不能同时设置，颜色应放入 BoxDecoration；'
              '留白优先用 Padding，剪裁圆角用 ClipRRect。',
            ),
          ),
        ],
      ),
    );
  }
}

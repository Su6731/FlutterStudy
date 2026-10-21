# Widget 树与工程结构

## 创建时的官方计数器

S = StatelessWidget，F = StatefulWidget，R = RenderObjectWidget（不是前两类）。
树展开到 main.dart 显式创建的叶子，Flutter 框架内部实现不展开。

```text
main → runApp
MyApp [S]
└─ MaterialApp [F]
   └─ MyHomePage [F] → _MyHomePageState
      └─ Scaffold [F]
         ├─ appBar: AppBar [F]
         │  └─ title: Text [S]
         ├─ body: Center [R]
         │  └─ Column [R]
         │     ├─ Text（提示）[S]
         │     └─ Text（计数）[S]
         └─ floatingActionButton: FloatingActionButton [S]
            └─ Icon [S]
```

注意：不能把所有布局组件都标为 StatelessWidget；Center/Column 属于渲染对象组件。
FloatingActionButton 本身是 StatelessWidget，点击后的计数状态在页面 State 中。
Widget 类型以本机 Flutter SDK 类声明为依据。

## 目录职责

- lib/main.dart：Dart 入口和页面。
- pubspec.yaml：依赖、图片与字体声明。
- assets/images/：本地图片。
- test/：组件行为测试。
- android/、web/、windows/：平台工程。
- docs/：Widget 树、日志和证据。
- build/、.dart_tool/：构建缓存，忽略不提交。

启动链路：main() → runApp(const MyApp()) → 根组件挂载 → build → 布局 → 绘制。

## 完成后的 Widget 树

```text
MyApp [S]
└─ MaterialApp [F]
   └─ CounterPage [F] → _CounterPageState（count / step）
      └─ Scaffold [F]
         ├─ AppBar [F]
         │  ├─ Text(title) [S]
         │  └─ PopupMenuButton<int> [F]
         │     ├─ Icon(tune) [S]
         │     └─ 弹层 PopupMenuItem<int> × 3 [F]
         │        └─ Text(步长 1 / 2 / 5) [S]
         ├─ Center [R]
         │  └─ SingleChildScrollView [S]
         │     └─ Column [R]
         │        ├─ Image.asset [F]
         │        ├─ SizedBox(24) [R]
         │        ├─ Text(提示) [S]
         │        ├─ Text(count) [S]
         │        ├─ SizedBox(12) [R]
         │        ├─ Text(step) [S]
         │        ├─ SizedBox(8) [R]
         │        └─ Text(操作说明) [S]
         └─ FloatingActionButton [S]
            └─ Icon(add) [S]
```

弹层条目由 itemBuilder 创建并显示在弹出路由中，图中是创建关系，非固定常驻子树。
State 是状态对象，不是一个 Widget 节点。

## 点击 FAB 后发生什么

onPressed → _increment → setState 同步执行回调 → 修改 _count → Element 标记 dirty → 调度后续帧 → build 创建新 Widget 配置 → 框架更新相关元素，并按需要布局和绘制。
不会销毁并重新创建整个应用。setState 回调仅改状态，不放异步或耗时工作。

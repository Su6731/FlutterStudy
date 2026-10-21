# counter_deep

第5课课堂案例，完成 guide-5 第五部分及 6.1。

## 运行与验证

```powershell
cd F:\FlutterPractice\Day5\counter_deep
flutter pub get
flutter run -d chrome
flutter analyze
flutter test
```

本机 flutter.bat 的 shared.bat 含异常的 `$git` 调用，启动曾卡住。无需改 SDK，可暂时直接调用现有工具：

```powershell
& 'D:/FlutterSDK/flutter/bin/cache/dart-sdk/bin/dart.exe' 'D:/FlutterSDK/flutter/bin/cache/flutter_tools.snapshot' run -d chrome
```

右上角选择步长 1/2/5，右下角 + 累加。初始 count=0、step=1。
运行中按 r 保留状态并热重载，按 R 热重启后归零。

## 文件

- lib/main.dart：步长、主题、生命周期及资源显示。
- docs/widget_tree.md / docs/widget_tree.png：初始和最终组件树及类型。
- docs/ai_comparison.md：实际 AI 使用与方案比较。
- docs/evidence/：浏览器截图、环境诊断、分析、测试及运行日志。
- ../lecture5/progress.md：报告文字及证据引用。
- ../进度报告5.docx：填写后的报告。

## 验证边界

Web 端实测。Android 许可证未全部接受；Windows 缺 Visual Studio C++ 工具链，未验证这两个平台。
本机 Flutter Web 热重启过程中输出 EngineFlutterView 已销毁的调度断言，随后重启成功且界面归零；保留完整日志，不将其标记为已修复。
报告与代码由 Codex 辅助完成，学生本人仍需复核并进行口头讲解。本次未使用 TraeWork。

# DAY4 异步 JSON 图书统计

实现实践指南第四课第五部分和第六部分必做任务：异步读取图书 JSON、Book 模型双向转换、总数与分类统计、借阅量 Top3、异常兜底、回调改写和 AI 标注。不做 Stream、Future.wait 或 isolate 选做实验。

## 运行

使用 Dart 3.13.3 或满足 pubspec.yaml 约束的 SDK，在本项目目录执行：

```powershell
dart pub get
dart run
dart run bin/async_json.dart test/fixtures/missing_field.json
dart run bin/async_json.dart test/fixtures/wrong_type.json
dart run bin/async_json.dart data/not-exist.json
dart run example/callback_to_await.dart
dart run example/missing_field_before.dart
dart analyze
dart test
```

传入自定义 JSON 时必须写出 `bin/async_json.dart`，否则 Dart 会将 JSON 路径识别为要执行的程序。默认路径相对项目工作目录，需先进入 DAY4/async_json。

正常和借阅字段缺失返回码为 0；文件/数据错误为 1；参数数量错误为 64。错误路径只输出友好提示，不输出未捕获堆栈。

## 文件

| 文件 | 内容 |
| --- | --- |
| lib/book.dart | 完整字段、fromJson/toJson、类型检查和缺失借阅量默认值 |
| lib/async_json.dart | async/await 读取、解析、统计、roundtrip 与异常入口 |
| bin/async_json.dart | 命令行入口及退出码 |
| example/callback_to_await.dart | 嵌套 then 与顺序 await 对照 |
| example/missing_field_before.dart | 实际复现修复前 null 转 num 错误 |
| data/books.json | 明确标注的演示数据 |
| test/ | 九个测试与错误数据夹具 |

## 字段规则

id、title、category 必须是非空字符串；缺失时指出字段名。borrowCount 缺失或 null 时警告并默认 0；其他情况下必须是非负整数，可接受 2.0 这类整数数值，拒绝字符串、布尔、负数、小数和非有限值。JSON 顶层必须是数组，元素必须是对象。

完整字段数据经过 fromJson → toJson 后结构一致，测试使用深层比较验证。缺失字段的输入会补齐默认值，因此只保证规范化后的模型往返一致，不声称与缺失字段的原始 JSON 完全相同。排序先复制列表，同借阅量按 id 排序，空列表及不足三本均可处理。

`await File(...).readAsString()` 等待读取完成后才解析，不阻塞事件循环；读取错误沿 Future 传到 runCli 的 try/catch。代码没有显式打开的文件句柄需要手工关闭。

## 资源与提交说明

依据配套实践指南第五、六部分和[课程第4课页面](https://mapp-2026f.dev-learn-hub.me/m4)实现必做代码。

页面未提供可下载的统一 books.json 或指定回调原程序。当前 books.json 是 Codex 生成的六本演示数据，回调版也是自编示例；两者未冒充课程原件。拿到课程资源后需替换并重新验证，才能核对“与统一数据集零差异”和“给定回调原程序”这两项。

按用户要求提交至 Su6731/FlutterStudy 的 DAY4。

## AI 使用标注

OpenAI Codex 根据“完成实践指南第五、六部分必做任务，不做选做”的指令辅助编写项目、演示素材、测试和说明。已实际执行正常运行、文件缺失及恢复、字段缺失和类型错误检查，并验证回调改写结果和模型往返一致；九个单元测试通过，静态分析无问题。素材限制见上文说明。没有使用 TraeCode。

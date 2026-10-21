# 生命周期实测记录

日期：2026-10-21。目标：Chrome Web，Flutter 3.47.4。

| 操作 | 实际关键输出 | 状态 |
| --- | --- | --- |
| 首次启动 | initState → didChangeDependencies → build | count=0，step=1 |
| 按步长 1/2/5 累加 | build；累计值依次 1、3、8 | 最终 count=8，step=5 |
| 按 r | reassemble → build | 保留 8、5，未再次 initState |
| 按 R | initState → didChangeDependencies → build | 恢复 0、1 |
| 测试中父组件更新标题 | didUpdateWidget → build | 保留 count=1 |
| 测试中更换 Theme | didChangeDependencies → build（可能多次） | 保留 count=1 |
| 测试中移除页面 | deactivate → dispose | 原 State 销毁 |

钩子不是每次按同一固定顺序全部执行。didUpdateWidget 只在父组件以相同类型和 key 更新配置时触发；主题动画可以引发多次依赖更新。热重启不是普通的树卸载过程，不能要求它一定输出 dispose。

热重启出现调度断言 `Trying to render a disposed EngineFlutterView.`，随后工具提示 Restarted application，页面正常归零。此引擎/调试环境现象未修复，完整输出见 evidence/run_session.txt。

测试首次失败原因：捕获 debugPrint 后依赖 addTearDown 恢复，Flutter 在 teardown 前已检查全局调试变量。修正为 try/finally 在测试体内恢复后，4 项测试全部通过。初次失败输出保留为 tests_initial_failure.txt。

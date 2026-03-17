# 当前运行状态

## 任务目标

用远端 OpenClaw 持续生成《凡骨问仙》这部长篇传统修仙小说。

## 当前已完成

- 已验证远端 `openclaw` 可用
- 已确认默认模型为 `rayincode/gpt-5.4`
- 已完成总纲、场景协议、批次清单、本地 prompt 和脚本
- 已把工厂目录同步到远端
- 已创建 4 个 isolated agents
- 已启动第一波后台任务
- 已确认第一波“大任务并发”方案不稳定
- 已转入 compact 结构任务模式

## 远端位置

- 服务器：`180.76.173.93`
- OpenClaw：`/usr/bin/openclaw`
- 项目目录：`/root/openclaw_xianxia_factory`

## 已创建的 isolated agents

- `novel-architect`
- `novel-volume1`
- `novel-style`
- `novel-writer-a`

## 第一波后台任务

### architect

- agent：`novel-architect`
- pid：`1104895`
- 输出：`/root/openclaw_xianxia_factory/output/architect.json`
- 日志：`/root/openclaw_xianxia_factory/logs/architect.log`

### volume1

- agent：`novel-volume1`
- pid：`1104896`
- 输出：`/root/openclaw_xianxia_factory/output/volume1.json`
- 日志：`/root/openclaw_xianxia_factory/logs/volume1.log`

### style_guide

- agent：`novel-style`
- pid：`1104897`
- 输出：`/root/openclaw_xianxia_factory/output/style_guide.json`
- 日志：`/root/openclaw_xianxia_factory/logs/style_guide.log`

### batch01

- agent：`novel-writer-a`
- pid：`1104898`
- 输出：`/root/openclaw_xianxia_factory/output/batch01.json`
- 日志：`/root/openclaw_xianxia_factory/logs/batch01.log`

## 第一波结论

- 首波 4 个大任务不适合作为当前稳定生产方案
- 主要问题：
  - Gateway `1006 abnormal closure`
  - fallback 到 embedded
  - 长超时后失败
  - stdout 前缀污染 JSON

所以当前策略已经改成：

- 先生成紧凑结构产物
- 再用结构产物继续拆正文

## Compact 模式

### 新 prompt

- `prompts/architect_compact.txt`
- `prompts/volume1_compact.txt`
- `prompts/style_compact.txt`
- `prompts/batch01_scene_compact.txt`

### 新脚本

- `scripts/run_prompt_remote.sh`
- `scripts/launch_compact_wave_remote.sh`
- `scripts/check_compact_wave_remote.sh`
- `scripts/run_compact_sequential_remote.sh`

### 已确认成功

- `style_compact`
  - 输出：`/root/openclaw_xianxia_factory/output_compact/style_compact.json`
  - 日志：`/root/openclaw_xianxia_factory/logs_compact/style_compact.log`
  - 状态：成功返回有效 JSON

### 当前目标

把以下 3 项也稳定产出：

- `architect_compact`
- `volume1_compact`
- `batch01_scene_compact`

## 已准备好的下一步正文任务

- `batches/batch01_chunk_plan.md`
- `prompts/batch01_chapter_chunk_template.md`
- `prompts/batch01_chunk01_prompt.txt`

说明：

- 一旦 compact 结构产物稳定下来，就不再直接要求 OpenClaw 一次写 2 万字。
- 下一阶段正文将按 `Chunk 01 -> Chunk 02 -> ...` 的方式推进。

## 本地关键文件

- `outlines/master_blueprint.md`
- `outlines/scene_protocol.md`
- `batches/batch_manifest.md`
- `prompts/architect_first_wave.txt`
- `prompts/volume1_first_wave.txt`
- `prompts/style_guide_first_wave.txt`
- `prompts/batch01_first_wave.txt`
- `scripts/bootstrap_agents_remote.sh`
- `scripts/launch_first_wave_remote.sh`
- `scripts/monitor_remote.sh`

## 下次继续时的建议顺序

1. 先读本文件
2. 再读 `task_plan.md`
3. 登录服务器检查：
   - `ps -ef | grep 'openclaw agent' | grep -v grep`
   - `ls -lh /root/openclaw_xianxia_factory/output`
   - `tail -n 40 /root/openclaw_xianxia_factory/logs/*.log`
4. 查看四个 JSON 输出是否完成
5. 抽样检查内容质量
6. 如果首波质量可接受，再启动第二波：
   - 先基于 compact 产物补全文档
   - 再拆 `Batch 01` 正文为更小章节块
   - 然后再推进 `Batch 02`

## 注意

- 不要再用 `--to` 作为并发隔离方案，它会落回 `main` 会话。
- 当前更稳的方案是：一个批次对应一个 isolated agent，或者一组连续批次绑定一个 isolated agent。

# OpenClaw 修仙小说工厂

## 目标

用远程服务器上的 OpenClaw 持续生成一部长篇传统修仙小说，目标规模约 100 万字。

## 核心原则

- 不一次性硬写 100 万字
- 先固定世界观、人物弧光、分卷结构、场景协议
- 按 2 万到 5 万字一批推进
- 尽量并行，但每批都要有明确衔接关系
- 输出必须落盘，不能只停留在会话里

## 目录

- `outlines/`：总纲、卷纲、世界观、角色设定
- `prompts/`：写作与审校 prompt 模板
- `batches/`：批次清单、批次 prompt、输出文稿
- `scripts/`：远程执行、后台运行、监督脚本
- `logs/`：本地记录与运行日志说明

## 当前已沉淀的稳定产物

- `outlines/style_guide_compact.md`
- `outlines/architect_micro.md`
- `outlines/volume1_micro.md`
- `batches/batch01_scene_micro.md`
- `batches/batch01_chunk01_micro.md`
- `batches/batch01_chunk01b_micro.md`
- `batches/batch01_chunk02a_micro.md`
- `batches/batch01_chunk02b_micro.md`
- `batches/batch01_chunk03a_micro.md`
- `batches/batch01_chunk03b_micro.md`
- `batches/batch01_chunk04a_micro.md`

## 推荐工作流

1. 先读 `outlines/master_blueprint.md`
2. 再读 `outlines/scene_protocol.md`
3. 查看 `batches/batch_manifest.md`
4. 用 `scripts/` 下脚本启动某一波次
5. 用日志和 session 监督输出质量

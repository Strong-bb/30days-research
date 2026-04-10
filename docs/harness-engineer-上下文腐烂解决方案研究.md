# Harness Engineer: AI 编程上下文腐烂解决方案研究

> 生成日期：2026-04-07
> 数据来源：arXiv, Anthropic 官方博客, Augment Code, MindStudio, Y Build, Vincent van Deth (VNX), Medium, The New Stack, Oracle
> 研究范围：过去 30 天内的技术讨论与实践

---

## 一、核心发现

### 1. Harness Engineering 是 2026 年 AI 编程的核心学科

**"Agent = Model + Harness"** — 这是 Mitchell Hashimoto（HashiCorp 联合创始人）提出的核心公式。他的原则是：

> "Anytime you find an agent makes a mistake, you take the time to engineer a solution such that the agent never makes that mistake again."

Harness 不是 prompt engineering，而是**系统工程** — 围绕 AI 模型构建约束、工具、反馈循环和验证机制。

**关键证据：** LangChain 在不更换模型的情况下，仅通过改进 harness 就将 Terminal Bench 2.0 准确率从 52.8% 提升到 66.5%（提升 26%）。

**实际产出：**
- OpenAI Codex 团队：3 名工程师 5 个月产出百万行代码，平均每天 3.5 个合并 PR
- Stripe "Minions" 系统：每周 1000+ 合并 PR
- Anthropic 双 Agent 架构：结构化特性列表作为 Agent 间交接格式

### 2. Context Rot（上下文腐烂）是最大瓶颈

The New Stack 的文章明确指出：**"Context gap" 决定了 AI 生产力捕获的上限**。

核心问题：
- 性能在 20-30 轮对话后可预测性下降
- 更大的上下文窗口只能延缓但不能解决问题
- 79% 的多 Agent 失败源于上下文协调问题
- 朴素 Agent 循环的 token 成本呈 **O(N²)** 增长

### 3. Anthropic 官方的 Context Engineering 框架

Anthropic 在官方工程博客中提出三层解决方案：

1. **Compaction（压缩）** — 对话接近窗口上限时，总结内容并重启新上下文
2. **Structured Note-taking（结构化笔记）** — Agent 定期将笔记持久化到外部存储
3. **Sub-agent Architectures（子 Agent 架构）** — 专门化的子 Agent 使用独立上下文窗口

---

## 二、7 大 Harness 组件（可落地实践）

### 组件 1：Context Engineering（上下文工程）

**做法：** `CLAUDE.md` / `AGENTS.md` 放在项目根目录。

**关键规则：** 控制在 60 行以内。Agent 对长文档会失去焦点 — 给它地图，不是千页手册。

```markdown
# CLAUDE.md 示例
## Architecture
- src/app/ — Next.js app router pages
- src/lib/ — shared utilities and API clients
- src/components/ — React components (co-located styles)

## Rules
- Use server components by default
- Never import from node_modules directly in components
- All API calls go through src/lib/api.ts
```

### 组件 2：Architectural Constraints（架构约束）

**做法：** 不靠"希望"Agent 选对架构，而是**强制执行**。

- 用 linter 验证的严格分层架构
- 结构性测试（违反模式即失败）
- 通过 ESLint 规则限制 import

**核心理念：** 约束解决方案空间，而不是扩展它。有效选项越少 = 错误答案越少。

### 组件 3：Tools & MCP Servers（工具与 MCP 服务）

**核心建议：** 优先使用知名 CLI（git, docker, npm），因为训练数据覆盖充分。自定义 CLI 缺少文档会困惑 Agent。

### 组件 4：Sub-Agents & Context Firewalls（子 Agent 与上下文防火墙）

**做法：** 复杂任务拆分为独立子任务，每个子任务在自己的 session 中运行，只传递结构化结果。

Anthropic 发布的架构：
1. **Initializer Agent** — 规划工作，创建特性列表
2. **Coding Agent** — 在隔离中执行每个特性

### 组件 5：Hooks & Back-Pressure（钩子与反压）

**关键设计规则：**
- 失败要响亮，成功要安静
- Pre-commit hooks 做类型检查、lint、格式化
- Agent 每次改动后自动跑测试
- **永远不要**将冗长的成功输出注入 Agent 上下文

### 组件 6：Self-Verification Loops（自验证循环）

强制 Agent 完成任务前验证自己的工作：
- 改完后跑测试套件
- 确认构建通过
- 验证输出符合规格
- UI 工作截图对比

### 组件 7：Progress Documentation（进度文档）

长时间任务（30 分钟+）：
- 维护进度文件追踪已完成步骤
- 频繁提交以便后续 session 可以继续
- 使用结构化任务列表，不是自由格式笔记

---

## 三、5 大上下文约束模式（来自 Augment Code 的生产验证）

| 模式 | Token 机制 | 实测效果 | 主要风险 |
|------|-----------|---------|---------|
| **子 Agent 隔离** | 每次调用限制范围 | benchmark 减少约 40% token | 重复请求无缓存优势 |
| **状态重置 + 外部持久化** | 防止上下文腐烂 | 支持多小时任务 | 交接可能丢失细节 |
| **推理-执行分离** | 一次规划多次执行 | 结构性 token 减少 | 计划过时 |
| **上下文裁剪** | 每轮输出过滤 | 节省 22.7% token | 未调度时准确率下降 |
| **对话总结** | 窗口压缩 | 净节省因场景而异 | 轮次倍增 |

**关键发现：** coordinator-specialist 架构平均减少 53.7% 的 token 消耗。

---

## 四、上下文腐烂的自动化解决方案

### VNX Context Rotation Pipeline（Vincent van Deth 开源方案）

三阶段自动化流水线：

1. **检测压力** — PreToolUse hook 监控 context 使用率，65% 时阻止继续，要求写 handover 文档
2. **检测交接** — PostToolUse hook 监听 `ROTATION-HANDOVER.md` 文件写入
3. **清除并注入** — 通过 tmux 发送 `/clear`，SessionStart hook 注入交接内容

**关键洞察：**
> "The best time to rotate context is when you don't think you need to yet."
> 在 60-65% 时轮换，Agent 写出的交接文档质量远高于 75%+ 时。

---

## 五、快速上手 Checklist

### 立即可做（0 成本）

- [ ] 创建精简的 `CLAUDE.md`（< 60 行），包含架构、规则、常用命令
- [ ] 采用"一个 session 一个任务"模式，不要马拉松式 session
- [ ] 粘贴代码前裁剪不相关内容（注释、无关函数、冗余日志）
- [ ] 识别到上下文腐烂信号（重复建议、变量追踪丢失、矛盾）时立即重置
- [ ] 用结构化总结作为 session 间的 checkpoint

### 中期建设（1-2 周）

- [ ] 搭建 sub-agent 工作流：研究用子 Agent，主 Agent 保持干净上下文
- [ ] 建立 progress documentation 机制（NOTES.md 或 todo list）
- [ ] 配置 hooks 做自动 lint/测试验证
- [ ] 实现自验证循环：Agent 改完代码必须跑测试

### 高级优化（持续迭代）

- [ ] 实现自动上下文轮换（参考 VNX pipeline）
- [ ] 建立 coordinator-specialist 多 Agent 架构
- [ ] 实现 context trimming（每 10-15 轮工具调用做一次压缩）
- [ ] 每次 Agent 犯错后，在 harness 中添加规则防止重犯

---

## 六、核心理念总结

| Prompt Engineering | Harness Engineering |
|---|---|
| 你对模型说什么 | 你在模型周围构建什么 |
| 脆弱、依赖模型 | 稳健、模型无关 |
| 不随时间改善 | 每次迭代都在改善 |
| 覆盖单次交互 | 覆盖整个工作流 |
| 技能类型：写作 | 技能类型：系统工程 |

**最终判断：** 模型是引擎，harness 是整车。没有人光靠引擎赢得比赛。2026 年产出最快的团队不是用了更好的模型，而是用了更好的 harness。

---

## 数据来源

- Anthropic 官方工程博客：Effective Context Engineering for AI Agents
- Y Build：Harness Engineering Complete Guide (2026-03-26)
- MindStudio：Context Rot in AI Coding Agents
- Augment Code：AI Agent Loop Token Cost Context Constraints (2026-04-06)
- Vincent van Deth / VNX：Context Rot Auto Rotation Pipeline
- arXiv：Building AI Coding Agents for the Terminal (2603.05344v1)
- The New Stack：Context Is AI Coding's Real Bottleneck in 2026
- Oracle Developers：Agent Memory - Why Your AI Has Amnesia
- Addy Osmani (Medium)：My LLM Coding Workflow Going Into 2026
- Kushal Banda (Medium)：State of Context Engineering in 2026

# AI 编程 Harness 工程实践指南

> 整合自项目研究报告：Harness Engineering、Spec-Driven Development、Ralph Loop、WORCA 等
> 生成日期：2026-04-08
> 定位：将分散的理论整合为可直接落地的操作手册

---

## 一、核心概念关系图

```
你的 Harness 体系
│
├─ CLAUDE.md ──────── 项目宪法（持久、稳定）
│   "这个项目是什么、有什么规矩"
│
├─ Spec ────────────── 施工图纸（临时、任务级）
│   "这次具体要做什么、怎么做、怎么算成功"
│
├─ Rules ───────────── 法律条文（自动执行）
│   ~/.claude/rules/common/ 下的编码规范、安全检查等
│
├─ Guardrails ──────── 踩坑记录（持续积累）
│   "AI 犯过的错，不再重犯"
│
└─ Hooks ───────────── 自动化管线（无需人工）
    PreToolUse / PostToolUse / Stop 三种触发器
```

**一句话区分：**
- **CLAUDE.md** = 约束（告诉 AI 不要做什么）→ "用 TypeScript，不要用 var"
- **Spec** = 意图（告诉 AI 要做什么）→ "给登录页加 OAuth，涉及 auth.ts 和 login.tsx"
- **Rules** = 标准（自动检查）→ "测试覆盖率 80%，无硬编码密钥"
- **Guardrails** = 教训（从错误中学习）→ "上次改了 A 导致 B 坏了，以后要先跑 C 测试"

---

## 二、Spec-Driven Development 实操模板

### 什么时候写 Spec

| 场景 | 需要 Spec？ | 理由 |
|------|------------|------|
| 新功能（>3 个文件）| **是** | 需要协调多模块 |
| Bug 修复（涉及 1-2 个文件）| 不需要 | 直接描述问题即可 |
| 重构 | **是** | 需要定义重构前后对比 |
| 单文件小改动 | 不需要 | 直接说 |
| 涉及数据库迁移 | **是** | 需要定义回滚策略 |
| 不确定怎么做 | **是** | Spec 帮你理清思路 |

### Spec 模板

```markdown
# Spec: [功能名称]

## 目标
一句话描述要解决什么问题。

## 背景
- 相关的模块/文件（3-5 个）
- 依赖关系

## 实现方案
- 方案概述（不要超过 5 步）
- 每步要改什么文件、改什么

## 成功标准
- [ ] 具体验收条件 1
- [ ] 具体验收条件 2
- [ ] 相关测试通过

## 不做什么
- 明确排除的范围（防止 AI 过度发挥）

## 风险
- 可能影响的其他模块
- 回滚策略
```

### 使用方式

1. 写 Spec（5 分钟，可以用 AI 协助写）
2. 把 Spec 喂给 Claude Code：`"按照 spec-xxx.md 的方案实现"`
3. Claude 进入 Plan 模式，拆分为子任务
4. 逐步执行，每步 commit
5. 完成后 Spec 归档到 `specs/done/`

---

## 三、Guardrails 机制

### guardrails.md 放在哪里

- 项目根目录或 `.claude/guardrails.md`
- 在 CLAUDE.md 中引用：`"遵守 guardrails.md 中的所有规则"`

### guardrails.md 模板

```markdown
# Guardrails

> AI 犯过的错误记录，防止重犯。

## 代码错误
- [日期] 改了 X 导致 Y 崩溃 → 以后改 X 前先跑 Z 测试
- [日期] 忘记处理 null → 以后所有外部数据做 null check

## 架构错误
- [日期] 在组件里直接调 API → 必须通过 lib/api.ts
- [日期] 循环依赖 A→B→A → 新模块必须声明依赖方向

## 流程错误
- [日期] 一次改了 5 个文件全崩了 → 每次只改 1-2 个文件
- [日期] 没跑测试就 commit → 改完必须跑测试再 commit
```

### 规则

- 每次 AI 犯错且你纠正后，立刻追加一条
- 每条控制在 1 行以内，包含：错误 → 以后怎么做
- 超过 30 条时清理过时的

---

## 四、上下文腐烂识别与应对

### 识别信号

| 信号 | 含义 | 立即行动 |
|------|------|---------|
| AI 重复建议刚才否决过的方案 | 上下文丢失 | `/clear` 重开 |
| 变量名/文件路径搞混 | 追踪丢失 | `/clear` 重开 |
| 改一个 bug 引入新的 | 上下文污染 | `/clear` + 写 spec |
| 回答越来越长但不切题 | 注意力涣散 | `/clear` 重开 |
| 连续 3 次修改都没修好 | 进入恶性循环 | `/clear` + guardrails |

### Ralph Loop（无状态迭代）

当任务超过 30 分钟或 20 轮对话时，切换到 Ralph Loop 模式：

```
1. 当前进度写入 progress.md
2. 失败经验追加到 guardrails.md
3. /clear 重开 session
4. 新 session 读 CLAUDE.md + spec + progress.md
5. 从 progress.md 标记的位置继续
```

### progress.md 模板

```markdown
# Progress: [任务名]

## 已完成
- [x] 步骤 1：xxx
- [x] 步骤 2：xxx

## 当前
- [ ] 步骤 3：xxx（进行中，卡在 yyy）

## 待做
- [ ] 步骤 4：xxx
- [ ] 步骤 5：xxx

## 遇到的问题
- yyy 问题的描述和当前状态
```

---

## 五、Agent 编排：从你的 agents.md 到实际落地

### 当前状态

你的 `~/.claude/rules/common/agents.md` 定义了 9 个 agent 角色，但 `~/.claude/agents/` 目录不存在。

### 落地步骤

```bash
# 1. 创建 agents 目录
mkdir -p ~/.claude/agents

# 2. 每个角色一个 .md 文件
# 3. 在文件中定义：触发条件、职责边界、输出格式
```

### 推荐优先落地的 3 个 Agent

| Agent | 为什么先做 | 文件 |
|-------|----------|------|
| **planner** | 所有任务的第一步 | `~/.claude/agents/planner.md` |
| **code-reviewer** | 写完代码立刻用 | `~/.claude/agents/code-reviewer.md` |
| **build-error-resolver** | 节省最多调试时间 | `~/.claude/agents/build-error-resolver.md` |

### WORCA 简化版（3 阶段就够）

完整 WORCA 有 8 个阶段，但对个人项目来说 3 阶段就够了：

```
Stage 1: Plan  → planner agent 拆解任务
Stage 2: Implement → 你（或 coding agent）写代码
Stage 3: Verify → code-reviewer + 测试验证
```

比完整 WORCA 少了 Preflight、Coordinate、PR、Learn，但对个人项目这些是过度工程。

---

## 六、7 大 Harness 组件 × 你的落地状态

| # | 组件 | 你的状态 | 下一步 | 优先级 |
|---|------|---------|--------|--------|
| 1 | CLAUDE.md（上下文工程）| ✅ 已有 | 控制在 60 行内 | - |
| 2 | Rules（架构约束）| ✅ 已有 | 按需添加语言特定规则 | 低 |
| 3 | Tools & MCP | ⚠️ 有插件 | 按需添加 | 低 |
| 4 | Sub-Agents | ❌ 未创建 | 创建 planner + code-reviewer | **高** |
| 5 | Hooks（自动化）| ❌ 未配置 | 配置 auto-lint + auto-test | **高** |
| 6 | 自验证循环 | ⚠️ 有规则无 hook | 通过 hooks 实现 | 中 |
| 7 | 进度文档 | ❌ 未建立 | 创建 progress.md 机制 | 中 |

---

## 七、分阶段落地计划

### 第 1 周：建立 Spec 习惯

- [ ] 每次新功能/重构前，花 5 分钟写 spec（用上面的模板）
- [ ] CLAUDE.md 里加一行：`"所有涉及 3 个以上文件的改动，必须先写 spec"`
- [ ] 练习 3-5 次后评估是否自然

### 第 2 周：自动化验证

- [ ] 创建 `~/.claude/agents/` 目录，落地 planner agent
- [ ] 配置 PostToolUse hook：写完代码自动跑 lint
- [ ] 配置 PostToolUse hook：commit 前自动跑测试
- [ ] 创建 guardrails.md，开始记录 AI 犯过的错

### 第 3 周：上下文管理

- [ ] 长任务（>30 分钟）使用 progress.md 跟踪进度
- [ ] 识别到上下文腐烂信号时果断 `/clear`，不恋战
- [ ] 尝试 Ralph Loop 模式处理重复性任务

### 第 4 周+：进阶编排

- [ ] 落地 code-reviewer agent
- [ ] 尝试 coordinator-specialist 多 agent 协作
- [ ] 评估是否需要自动上下文轮换（VNX pipeline）
- [ ] 持续迭代 guardrails 和 rules

---

## 八、一句话原则

> **不要试图让 AI 更聪明，而是让系统更健壮。**

- 模型是引擎 → 你的 harness 是整车
- CLAUDE.md 是宪法 → Spec 是施工图
- Guardrails 是教训 → Hooks 是执行力
- Rules 是标准 → Agents 是工人

2026 年最有效的 AI 编程者不是用了最强模型的人，而是建立了最好工程系统的人。

---

## 参考来源

本指南整合自项目中的以下研究报告：
- `harness-engineer-上下文腐烂解决方案研究.md` — Harness 7 组件、Context Rot 解决方案
- `2026-04-08-AI编程方法论全景研究.md` — Spec-Driven、Ralph Loop、WORCA 方法论
- `2026-04-06-Karpathy-LLM知识库理念研究.md` — LLM 知识管理哲学
- `2026-04-08-Karpathy-AutoResearch深度研究.md` — Ratchet Loop 自动化理念
- `~/.claude/rules/common/` — 已有的编码规范和工作流规则

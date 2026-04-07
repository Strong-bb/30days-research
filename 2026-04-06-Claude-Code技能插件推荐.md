# Claude Code 技能、插件与工具推荐报告

> 基于社区调研（Hacker News、GitHub、技术博客）整理，覆盖 2026 年最新生态。
> 更新日期：2026-04-06

---

## 一、总览

### 1.1 Claude Code 生态架构

Claude Code 的扩展体系由以下四个核心概念构成：

| 概念 | 说明 | 安装方式 |
|------|------|----------|
| **Skills（技能）** | 基于 SKILL.md 文件的渐进式知识模块，定义特定任务的工作流和最佳实践 | `claude install-skill <repo>` 或手动复制 SKILL.md 到 `.claude/skills/` |
| **Plugins（插件）** | 技能 + 子代理 + MCP 服务器 + 命令 + Hooks 的完整功能包 | `/plugin install <name>@<namespace>` |
| **MCP 服务器** | 基于 Model Context Protocol 的外部服务集成（数据库、云服务、监控等） | 在 `~/.claude/settings.json` 中配置，或通过插件自动安装 |
| **Hooks** | 工具调用前后的生命周期钩子（PreToolUse / PostToolUse），用于自动格式化、检查等 | 在 `.claude/settings.json` 中配置 |

### 1.2 市场概况

- **ClawHub / OpenClaw 技能市场**：社区驱动的技能分享平台，已收录 13,000+ 社区技能（来源：Skywork AI）
- **官方插件市场**：Anthropic 官方维护，热门插件安装量达 10 万级（如 frontend-design 96.4k、Context7 71.8k）
- **GitHub 生态**：awesome-claude-plugins（100+ 仓库）、awesome-claude-skills、everything-claude-code（118k stars）等精选列表持续更新

### 1.3 社区热度（HN 近 30 天）

近期 Hacker News 上 Claude Code 相关讨论极为活跃：

| 话题 | 热度 | 要点 |
|------|------|------|
| Claude Code 源码泄露事件 | 1370 pts, 572 评论 | 揭示了内部工具机制、frustration regexes、undercover mode |
| "Claude Code Unpacked" 可视化指南 | 1116 pts, 403 评论 | 深度解析隐藏功能和跨会话引用 |
| 用户用量限制争议 | 329 pts, 224 评论 | Pro 用户反馈额度消耗过快 |
| "Why Claude Code Won (For Now)" | 多篇讨论 | 社区对 Claude Code 在 AI 编码工具竞争中领先地位的认可 |

---

## 二、前后端分离项目必备技能

### 2.1 前端开发

#### Frontend Design Plugin（强烈推荐）

- **安装**：`/plugin install frontend-design@claude-plugins-official`
- **安装量**：96,400+
- **功能**：防止 Claude Code 生成"千篇一律的通用 UI"，提供设计系统约束、组件规范和样式指南
- **适用场景**：React / Vue / Angular 等 SPA 项目的 UI 开发

#### Figma MCP Plugin

- **安装**：`/plugin install figma@claude-plugins-official`
- **安装量**：18,100+
- **功能**：将 Figma 设计稿直接转化为前端代码，支持设计 Token 提取
- **适用场景**：设计稿到代码的自动化转换，减少设计与开发之间的鸿沟

#### Playwright Plugin（端到端测试）

- **安装**：`/plugin install playwright@claude-plugins-official`
- **安装量**：28,100+
- **功能**：浏览器自动化测试，支持 E2E 测试生成与执行
- **适用场景**：前端页面功能测试、视觉回归测试、跨浏览器兼容性验证

#### Web Quality Skills

- **仓库**：`addyosmani/web-quality-skills`（496 stars）
- **安装**：`claude install-skill addyosmani/web-quality-skills`
- **子技能**（6 个）：
  - `core-web-vitals` — Core Web Vitals 性能优化（LCP、FID、CLS）
  - `lighthouse-audit` — Lighthouse 审计分析与修复建议
  - `accessibility` — 无障碍访问（a11y）合规检查
  - `seo-optimizer` — SEO 优化建议
  - `performance-budget` — 性能预算制定与监控
  - `best-practices` — Web 最佳实践检查
- **适用场景**：前端性能优化、质量保障

### 2.2 后端开发

#### Planning with Files Skill（项目管理核心）

- **仓库**：`OthmanAdi/planning-with-files`（13,410 stars，社区最高）
- **安装**：`claude install-skill OthmanAdi/planning-with-files`
- **功能**：将任务计划持久化为文件，支持跨会话跟踪进度、任务分解和里程碑管理
- **适用场景**：复杂后端架构设计、多模块项目管理

#### Snyk Fix Skill（安全修复）

- **仓库**：`snyk/studio-recipes`
- **功能**：自动检测代码中的安全漏洞并生成修复方案
- **适用场景**：后端 API 安全加固、依赖漏洞修复

#### Database MCP 服务器

| 数据库 | MCP 服务器 | 说明 |
|--------|-----------|------|
| PostgreSQL | `server-postgres` | 直接查询和操作 PG 数据库 |
| MongoDB | `mcp-mongo-server` | MongoDB 文档数据库操作 |
| ClickHouse | `mcp-clickhouse` | 列式分析数据库 |
| 通用 SQL | `dbhub` | 支持多种数据库的统一接口 |

### 2.3 全栈协作

#### Full Delivery Workflow

- **仓库**：`levnikolaevich/claude-code-skills`（82 stars）
- **安装**：`claude install-skill levnikolaevich/claude-code-skills`
- **功能**：50+ 个 SKILL.md 文件，覆盖从需求分析到部署的完整软件开发生命周期
- **子技能涵盖**：需求分析、架构设计、编码规范、测试策略、代码审查、部署流程
- **适用场景**：全栈项目的端到端工作流标准化

#### Agentic Framework

- **仓库**：`dralgorhythm/claude-agentic-framework`（15 stars）
- **功能**：9 个核心工程技能 + 74+ 总技能，强调代理式（Agentic）工作模式
- **适用场景**：需要多个子代理协作的复杂全栈项目

#### Linear Plugin（项目管理集成）

- **安装**：`/plugin install linear@claude-plugins-official`
- **安装量**：9,500+
- **功能**：与 Linear 项目管理工具集成，自动同步 Issue 状态
- **适用场景**：前后端团队的 Issue 跟踪和进度管理

---

## 三、运维部署相关技能

### 3.1 CI/CD 工作流

#### GitHub/GitLab MCP 服务器

| 服务 | MCP 服务器 | 说明 |
|------|-----------|------|
| GitHub | `server-github` / `github-enterprise-mcp` | PR 管理、Issue 跟踪、Actions 触发 |
| GitLab | `server-gitlab` | MR 管理、Pipeline 操作 |
| Azure DevOps | `mcp-server-azure-devops` | Azure Boards/Pipelines/Repos 集成 |
| GitHub Actions | `github-actions-mcp-server` | CI/CD 工作流管理和触发 |

**典型用法**：在 Claude Code 中通过 MCP 直接操作 CI/CD 流水线——查看构建状态、触发部署、查看日志，无需切换到浏览器。

### 3.2 Docker & Kubernetes

#### Docker MCP 服务器

| 服务器 | 仓库 | 功能 |
|--------|------|------|
| `mcp-server-docker` | 社区维护 | 容器生命周期管理、镜像构建、日志查看 |
| `docker-mcp` | 社区维护 | Docker Compose 编排支持 |
| `podman-mcp-server` | 社区维护 | Podman 兼容方案 |

#### Kubernetes MCP 服务器（重点推荐）

| 服务器 | 仓库 | 特点 |
|--------|------|------|
| `mcp-server-kubernetes`（Flux159） | Flux159/mcp-server-kubernetes | 功能最全，支持资源管理、日志、端口转发 |
| `k8s-mcp-server` | 社区维护 | 轻量级 K8s 操作 |
| `kubernetes-mcp-server`（manusa） | manusa/kubernetes-mcp-server | 支持 Helm 和命名空间管理 |
| `k8m` | 社区维护 | 多集群管理 |
| `kom` | 社区维护 | K8s 资源可视化 |

### 3.3 基础设施即代码（IaC）

#### HashiCorp Agent Skills（Terraform 专项）

- **仓库**：`hashicorp/agent-skills`（303 stars）
- **安装**：`claude install-skill hashicorp/agent-skills`
- **子技能**：
  - Terraform 代码生成
  - Terraform 测试编写
  - Terraform Module 最佳实践
- **适用场景**：云基础设施的声明式管理

#### Terraform MCP

- **服务器**：`tfmcp`
- **功能**：直接在 Claude Code 中操作 Terraform 状态、执行 Plan/Apply、分析配置

#### Pulumi MCP

- **服务器**：`pulumi-mcp-server`
- **功能**：Pulumi IaC 框架集成，支持多语言基础设施定义

### 3.4 云平台集成

| 云平台 | MCP 服务器 | 功能 |
|--------|-----------|------|
| AWS | `aws-mcp-server` | EC2/S3/Lambda/CloudFormation 管理 |
| Azure | `azure-cli-mcp` | Azure CLI 封装，全服务支持 |
| GCP | 相关社区方案 | Google Cloud 资源管理 |
| Cloudflare | `mcp-server-cloudflare` | Workers/Pages/DNS 管理 |

### 3.5 监控与可观测性

| 工具 | MCP 服务器 | 功能 |
|------|-----------|------|
| Grafana | `mcp-grafana` | Dashboard 查询、告警管理 |
| Last9 | `last9-mcp-server` | 可观测性平台集成 |
| Prometheus | `prometheus-mcp-server` | 指标查询和 PromQL 生成 |
| Logfire | `logfire-mcp` | Python 应用日志分析 |
| Sentry | `server-sentry` | 错误追踪和性能监控 |

---

## 四、持续优化技能

### 4.1 性能优化

#### Core Web Vitals 优化流程

使用 `addyosmani/web-quality-skills` 中的 `core-web-vitals` 子技能：

1. **LCP（Largest Contentful Paint）优化**：图片懒加载、关键资源预加载、CDN 配置
2. **FID / INP（交互响应）优化**：减少 JavaScript 执行时间、代码分割、Web Worker
3. **CLS（Cumulative Layout Shift）优化**：尺寸预留、字体加载策略、动态内容占位

#### Lighthouse 审计自动化

通过 Playwright Plugin + Web Quality Skills 组合：
- 自动运行 Lighthouse 审计
- 解析审计报告并生成修复建议
- 持续跟踪性能分数变化

### 4.2 代码审查

#### Code Review Plugin（多代理审查）

- **安装**：`/plugin install code-review@claude-plugins-official`
- **安装量**：50,000+
- **功能**：使用多代理（multi-agent）模式进行 PR 审查，从多个维度分析代码质量
- **特点**：
  - 自动识别潜在 Bug 和安全漏洞
  - 检查代码风格一致性
  - 分析性能影响
  - 生成结构化审查报告

#### GitHub PR Review Skill

- **仓库**：`aidankinzett/claude-git-pr-skill`
- **安装**：`claude install-skill aidankinzett/claude-git-pr-skill`
- **功能**：结构化 PR 审查工作流，支持自定义审查规则和检查清单
- **适用场景**：团队协作中的代码质量门禁

### 4.3 安全优化

#### Security Guidance Plugin

- **安装**：`/plugin install security-guidance@claude-plugins-official`
- **安装量**：25,500+
- **功能**：漏洞扫描、安全编码建议、依赖安全检查
- **适用场景**：日常开发中的安全防护、CI 中的安全检查

#### Semgrep Security Audit

- **MCP 服务器**：`semgrep/mcp-security-audit`
- **功能**：基于 Semgrep 的静态安全分析，支持自定义规则
- **适用场景**：代码提交前的安全审计

#### VirusTotal & Shodan

- `mcp-virustotal` — 文件和 URL 恶意软件检测
- `mcp-shodan` — 互联网资产暴露面检查

---

## 五、MCP 服务器推荐

### 5.1 通用生产力 MCP

| MCP 服务器 | 功能 | 推荐指数 |
|-----------|------|----------|
| `Context7`（Context7 Plugin） | 实时获取最新官方文档，解决知识过时问题 | 必装 |
| `Firecrawl`（Firecrawl Plugin） | 网页抓取和结构化数据提取 | 强烈推荐 |
| `mcp2cli` | 统一 CLI 接口，96-99% Token 节省 | 强烈推荐 |
| `Chrome DevTools MCP` | 浏览器调试、网络请求分析 | 推荐 |

**mcp2cli 特别说明**（HN 146 pts, 101 评论）：
- 核心价值：将任何 API 封装为 CLI 命令，大幅减少 MCP 通信的 Token 消耗
- 社区反馈积极，被认为是解决 MCP Token 开销问题的有效方案
- 仓库：`knowsuchagency/mcp2cli`

### 5.2 开发工具 MCP

| MCP 服务器 | 功能 |
|-----------|------|
| `server-postgres` | PostgreSQL 数据库操作 |
| `dbhub` | 通用数据库接口 |
| `mcp-mongo-server` | MongoDB 操作 |
| `mcp-clickhouse` | ClickHouse 分析查询 |
| `server-github` | GitHub API 完整操作 |
| `server-gitlab` | GitLab CI/CD 集成 |

### 5.3 运维 MCP（精选）

完整列表参见 GitHub 仓库 `mshanadadev/awesome-devops-mcp`，以下是精选推荐：

| 类别 | 推荐服务器 | 说明 |
|------|-----------|------|
| 容器编排 | `mcp-server-kubernetes`（Flux159） | 功能最全面的 K8s MCP |
| 容器运行时 | `mcp-server-docker` | Docker 全生命周期管理 |
| IaC | `tfmcp` | Terraform 状态和操作 |
| 云平台 | `aws-mcp-server` / `azure-cli-mcp` | AWS/Azure 资源管理 |
| 监控 | `mcp-grafana` / `server-sentry` | Dashboard 和错误追踪 |
| 安全 | `semgrep/mcp-security-audit` | 静态安全分析 |
| CI/CD | `server-github` / `mcp-server-azure-devops` | 流水线管理 |

---

## 六、安装与使用指南

### 6.1 插件安装

```bash
# 官方插件安装（内置命令）
/plugin install frontend-design@claude-plugins-official
/plugin install code-review@claude-plugins-official
/plugin install playwright@claude-plugins-official
/plugin install security-guidance@claude-plugins-official
/plugin install context7@claude-plugins-official
/plugin install figma@claude-plugins-official
/plugin install linear@claude-plugins-official
/plugin install firecrawl@claude-plugins-official
/plugin install ralph-loop@claude-plugins-official
```

### 6.2 技能安装

```bash
# 通过 GitHub 仓库安装（推荐）
claude install-skill OthmanAdi/planning-with-files
claude install-skill addyosmani/web-quality-skills
claude install-skill hashicorp/agent-skills
claude install-skill levnikolaevich/claude-code-skills
claude install-skill aidankinzett/claude-git-pr-skill

# 手动安装：将 SKILL.md 文件复制到项目目录
mkdir -p .claude/skills/
cp SKILL.md .claude/skills/
```

### 6.3 OpenClaw / ClawHub 技能安装

```bash
# 方式一：一行安装（推荐）
npx openclaw@latest install <skill-name>

# 方式二：通过 npm
npm install -g openclaw
openclaw install <skill-name>

# 方式三：从源码
git clone https://github.com/openclaw/openclaw.git
cd openclaw && npm install && npm run build
openclaw install <skill-name>
```

### 6.4 MCP 服务器配置

在 `~/.claude/settings.json` 中添加 MCP 服务器配置：

```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "npx",
      "args": ["-y", "mcp-server-kubernetes"]
    },
    "docker": {
      "command": "npx",
      "args": ["-y", "mcp-server-docker"]
    },
    "grafana": {
      "command": "npx",
      "args": ["-y", "mcp-grafana"],
      "env": {
        "GRAFANA_URL": "http://localhost:3000",
        "GRAFANA_API_KEY": "${GRAFANA_API_KEY}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

> 安全提示：API 密钥等敏感信息请使用环境变量引用（如 `${GRAFANA_API_KEY}`），不要硬编码。环境变量请在 `~/.claude/.env` 或系统环境变量中设置，并确保文件权限为 600。

### 6.5 Hooks 配置

在 `.claude/settings.json` 中配置自动化 Hooks：

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "npx prettier --write $FILE"
      }
    ]
  }
}
```

---

## 七、社区推荐组合方案

### 7.1 前后端分离项目 — 推荐组合

```
┌─────────────────────────────────────────────────┐
│  前后端分离项目推荐套件                            │
├─────────────────────────────────────────────────┤
│                                                  │
│  核心技能：                                       │
│    - planning-with-files（项目规划）               │
│    - web-quality-skills（前端质量）                │
│                                                  │
│  核心插件：                                       │
│    - frontend-design（UI 设计规范）                │
│    - playwright（E2E 测试）                       │
│    - code-review（代码审查）                       │
│                                                  │
│  MCP 服务器：                                     │
│    - server-postgres / mcp-mongo-server（数据库）  │
│    - server-github（代码托管）                     │
│    - Context7（实时文档）                          │
│                                                  │
│  可选增强：                                       │
│    - figma（设计稿转代码）                         │
│    - linear（项目管理）                           │
│    - firecrawl（网页数据抓取）                     │
│                                                  │
└─────────────────────────────────────────────────┘
```

**社区评价**：planning-with-files 以 13,410 stars 成为社区最受欢迎技能，是复杂项目的"必需品"。Frontend Design Plugin 以 96.4k 安装量成为安装量最高的插件，有效解决了"AI 生成 UI 千篇一律"的痛点。

### 7.2 运维部署项目 — 推荐组合

```
┌─────────────────────────────────────────────────┐
│  运维部署项目推荐套件                              │
├─────────────────────────────────────────────────┤
│                                                  │
│  核心技能：                                       │
│    - hashicorp/agent-skills（Terraform IaC）      │
│    - planning-with-files（变更管理）               │
│                                                  │
│  MCP 服务器（按云平台选择）：                       │
│    - mcp-server-kubernetes（K8s 编排）             │
│    - mcp-server-docker（容器管理）                 │
│    - aws-mcp-server / azure-cli-mcp（云平台）      │
│    - tfmcp（Terraform 状态管理）                   │
│                                                  │
│  CI/CD：                                          │
│    - server-github / server-gitlab                │
│    - github-actions-mcp-server                    │
│                                                  │
│  监控：                                           │
│    - mcp-grafana（Dashboard）                     │
│    - server-sentry（错误追踪）                     │
│    - prometheus-mcp-server（指标监控）             │
│                                                  │
│  安全：                                           │
│    - security-guidance（安全检查）                 │
│    - semgrep/mcp-security-audit（代码审计）        │
│                                                  │
└─────────────────────────────────────────────────┘
```

**社区评价**：awesome-devops-mcp 仓库已成为 DevOps MCP 的权威索引。HashiCorp 官方提供的 agent-skills 是 Terraform 用户的首选。社区认为 K8s MCP 服务器在排查集群问题时极为高效——"不用再在浏览器和终端之间来回切换"。

### 7.3 持续优化项目 — 推荐组合

```
┌─────────────────────────────────────────────────┐
│  持续优化项目推荐套件                              │
├─────────────────────────────────────────────────┤
│                                                  │
│  性能优化：                                       │
│    - web-quality-skills（Core Web Vitals）        │
│    - playwright（性能测试自动化）                  │
│    - Chrome DevTools MCP（运行时分析）             │
│                                                  │
│  代码质量：                                       │
│    - code-review plugin（多代理审查）              │
│    - claude-git-pr-skill（PR 工作流）             │
│    - security-guidance（安全扫描）                 │
│                                                  │
│  自动化 Hooks：                                   │
│    - PostToolUse: prettier（代码格式化）           │
│    - PostToolUse: eslint（代码检查）               │
│    - PreToolUse: 类型检查                         │
│                                                  │
│  辅助工具：                                       │
│    - Context7（获取最新框架文档）                   │
│    - firecrawl（竞品分析数据抓取）                 │
│    - mcp2cli（Token 优化，减少开销 96-99%）        │
│                                                  │
└─────────────────────────────────────────────────┘
```

**社区评价**：mcp2cli（HN 146 pts）被认为是解决 MCP Token 消耗的关键工具，社区讨论热烈（101 评论）。Web Quality Skills 的 6 个子技能覆盖了前端性能优化的主要维度，Addy Osmani（Google Chrome 团队）维护确保了专业性。Code Review Plugin 的多代理审查模式获得了社区高度认可。

### 7.4 极简起步方案（新手推荐）

如果不确定从哪里开始，以下是社区推荐的极简组合：

```bash
# 第一步：安装最核心的 3 个插件
/plugin install frontend-design@claude-plugins-official
/plugin install code-review@claude-plugins-official
/plugin install context7@claude-plugins-official

# 第二步：安装最核心的技能
claude install-skill OthmanAdi/planning-with-files

# 第三步：配置项目 CLAUDE.md
# 在项目根目录创建 CLAUDE.md 文件，写入项目上下文和规范
```

这个极简方案覆盖了：UI 质量（frontend-design）、代码质量（code-review）、知识准确性（Context7）、项目管理（planning-with-files）四个核心维度。

---

## 附录：关键资源链接

| 资源 | 链接 |
|------|------|
| awesome-devops-mcp（DevOps MCP 索引） | `github.com/mshanadadev/awesome-devops-mcp` |
| awesome-claude-plugins | `github.com/quemsah/awesome-claude-plugins` |
| awesome-claude-skills | `github.com/travisvn/awesome-claude-skills` |
| everything-claude-code | `github.com/affaan-m/everything-claude-code` |
| OpenClaw / ClawHub 市场 | `openclaw.org` / ClawHub 官网 |
| Claude Code 官方最佳实践 | `code.claude.com/docs/en/best-practices` |
| Claude Code 代码审查文档 | `code.claude.com/docs/en/code-review` |
| Planning with Files | `github.com/OthmanAdi/planning-with-files` |
| Web Quality Skills | `github.com/addyosmani/web-quality-skills` |
| HashiCorp Agent Skills | `github.com/hashicorp/agent-skills` |
| Full Delivery Workflow | `github.com/levnikolaevich/claude-code-skills` |
| mcp2cli | `github.com/knowsuchagency/mcp2cli` |

---

> 本报告基于 Hacker News、GitHub、技术博客等公开信息整理，反映了 2026 年 3-4 月的社区讨论和技术生态状况。具体工具的适用性请结合项目实际情况评估。

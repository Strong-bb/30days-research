# 30days-research

> 过去 30 天技术圈深度研究合集

用 `last30days` 技能 + 多源交叉验证，产出中文深度研究报告。覆盖 Hacker News、Reddit、GitHub、X/Twitter、YouTube 等平台真实讨论，拒绝水文，只要干货。

## 研究报告

| 日期 | 主题 | 一句话 |
|------|------|--------|
| 2026-04-06 | [Karpathy LLM 知识库理念](2026-04-06-Karpathy-LLM知识库理念研究.md) | 不要把 LLM 当搜索引擎，让它帮你维护 Markdown 知识库 |
| 2026-04-06 | [OpenClaw 进展与社区](2026-04-06-OpenClaw进展与社区研究.md) | 60天超越React星标，Anthropic封杀，CVE漏洞，生态爆发 |
| 2026-04-06 | [Codex vs Claude Code](2026-04-06-Codex-vs-Claude-Code对比研究.md) | Claude Code技术更强，Codex成本更低，聪明人两个都用 |
| 2026-04-06 | [Claude Code 技能插件推荐](2026-04-06-Claude-Code技能插件推荐.md) | 前后端分离+运维部署+持续优化全场景技能指南 |
| 2026-04-07 | [近期热门 GitHub 项目精选](2026-04-07-近期热门GitHub项目精选.md) | 15个真有用的项目 + 避坑清单 |

## 快速开始

### 环境要求

- [Claude Code CLI](https://claude.ai/code)
- Python 3.10+
- [last30days 插件](https://github.com/mvanhorn/last30days-skill)

### 安装 last30days

```bash
# 在 Claude Code 中安装插件
/plugin marketplace add mvanhorn/last30days-skill
/plugin install last30days@last30days-skill
/reload-plugins
```

### 可选配置（解锁更多数据源）

```bash
# 编辑配置文件
vim ~/.config/last30days/.env
```

```env
# X/Twitter — 浏览器自动扫描（推荐，免费）
FROM_BROWSER=auto

# ScrapeCreators — Reddit评论 + TikTok + Instagram（100次免费）
SCRAPECREATORS_API_KEY=xxx

# YouTube — 安装 yt-dlp（免费开源）
# brew install yt-dlp

SETUP_COMPLETE=true
```

### 运行研究

在 Claude Code 中直接对话：

```
/last30days 你想研究的话题
```

或让 Claude 自动研究并落文档：

```
创建一个agent去用last30days研究下 xxx
```

### 文件命名规范

```
YYYY-MM-DD-主题名称.md
```

正文使用中文，技术术语保留英文。

## 工具链

| 工具 | 用途 |
|------|------|
| [last30days](https://github.com/mvanhorn/last30days-skill) | 多平台深度研究引擎 |
| [HN Algolia API](https://hn.algolia.com/api) | Hacker News 搜索（免费） |
| [GitHub API](https://api.github.com) | 仓库数据查询 |

## License

MIT

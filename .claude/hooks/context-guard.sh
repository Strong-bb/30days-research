#!/bin/bash
# Context Guard — 检测工具调用次数，提醒用户轮换上下文
# 每次工具调用时执行，维护一个调用计数器

COUNTER_FILE="/tmp/claude-context-counter-$(basename "$PWD")"
MAX_CALLS=${CONTEXT_GUARD_THRESHOLD:-40}

if [ -f "$COUNTER_FILE" ]; then
    COUNT=$(cat "$COUNTER_FILE")
else
    COUNT=0
fi

COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

if [ "$COUNT" -ge "$MAX_CALLS" ]; then
    echo "⚠️ 已执行 $COUNT 次工具调用（阈值 $MAX_CALLS）。"
    echo "上下文可能正在腐烂。建议："
    echo "  1. 更新 progress.md 记录当前进度"
    echo "  2. 有犯错经验则追加到 guardrails.md"
    echo "  3. 运行 /clear 重开 session"
    echo "  4. 新 session 会自动从 CLAUDE.md + progress.md 继续"
    # 重置计数器
    echo "0" > "$COUNTER_FILE"
fi

# Agent Communication System

## エージェント構成
- **reviewer** (multiagent:agents): レビュアー
- **implementer** (multiagent:agents): 実装者

## あなたの役割
- **implementer**: @instructions/implementer.md
- **reviewer**: @instructions/reviewer.md

## メッセージ送信
```bash
./agent-send.sh [相手] "[メッセージ]"
```

## 基本フロー
implementer → reviewer → implementer → reviewer → ... → 完成

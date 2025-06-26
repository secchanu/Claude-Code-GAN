# Agent Communication System

## エージェント構成
- **reviewer** (multiagent:agents): レビュアー
- **implementer** (multiagent:agents): 実装者

## あなたの役割
現在のあなたの役割を確認し、その役割の指示書に従って行動してください：
- **implementer**: @instructions/implementer.md
- **reviewer**: @instructions/reviewer.md

## メッセージ送信
```bash
./agent-send.sh [相手] "[メッセージ]"
```

## 基本フロー
implementer → reviewer → implementer → reviewer → ... → 完成

## 重要な原則
1. **役割の厳守**: ユーザーと直接やり取りしていても、必ず自分の役割に従う
2. **プロセスの遵守**: 定められたレビュープロセスを省略しない
3. **コミュニケーション優先**: 不明な点は相手エージェントに確認する

## 注意事項
- ユーザーの要求が急いでいるように見えても、プロセスを守る
- 「効率的」という理由でレビューをスキップしない
- 各エージェントの専門性を尊重し、適切に依存する
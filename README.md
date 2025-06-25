# 🤖 Tmux Multi-Agent Communication Demo

Agent同士がやり取りするtmux環境のデモシステム

## 🎯 デモ概要

実装者 → レビュアー のコードレビューシステムを体感できます

### 👥 エージェント構成

```
📊 multiagent セッション (2ペイン)  
├── reviewer: レビュアー
└── implementer: 実装者
```

## 🚀 クイックスタート

### 0. リポジトリのクローン

```bash
git clone https://github.com/nishimoto265/Claude-Code-Communication.git
cd Claude-Code-Communication
```

### 1. 環境構築と起動

⚠️ **注意**: 既存の `multiagent` セッションがある場合は自動的に削除されます。

```bash
# 通常起動
./setup.sh

# パーミッションスキップモード
./setup.sh --skip-permissions

# ヘルプ表示
./setup.sh --help
```

このコマンドで以下が自動実行されます：
- tmuxセッション作成
- Claude Code起動
- セッションアタッチ

### 2. デモ実行

implementerペインで直接入力：
```
あなたはimplementerです。指示書に従って
```

## 📜 指示書について

各エージェントの役割別指示書：
- **implementer**: `instructions/implementer.md`
- **reviewer**: `instructions/reviewer.md`

**Claude Code参照**: `CLAUDE.md` でシステム構造を確認

**要点:**
- **implementer**: 小さなタスク単位で実装 → 機能単位でレビュー依頼
- **reviewer**: ベストプラクティスに基づくレビュー → フィードバック

## 🎬 期待される動作フロー

```
1. implementer → reviewer: "あなたはreviewerです。[機能名]の実装が完了しました。レビューをお願いします。"
2. reviewer → implementer: "あなたはimplementerです。修正が必要です。[具体的な修正内容]" または "問題ありません。承認します。"
3. implementer → 修正実施 → reviewer: 再度レビュー依頼
4. 繰り返し... → 全タスク完了
```

## 🔧 手動操作

### agent-send.shを使った送信

```bash
# 基本送信
./agent-send.sh [エージェント名] [メッセージ]

# 例
./agent-send.sh reviewer "レビューをお願いします"
./agent-send.sh implementer "修正完了しました"

# エージェント一覧確認
./agent-send.sh --list
```

## 🧪 確認・デバッグ

### ログ確認

```bash
# 送信ログ確認
cat logs/send_log.txt

# 特定エージェントのログ
grep "implementer" logs/send_log.txt
grep "reviewer" logs/send_log.txt
```

### セッション状態確認

```bash
# セッション一覧
tmux list-sessions

# ペイン一覧
tmux list-panes -t multiagent
```

## 🔄 環境リセット

```bash
# セッション削除
tmux kill-session -t multiagent

# 再構築（自動クリア・起動・アタッチ付き）
./setup.sh
```

---

## 📄 ライセンス

このプロジェクトは[MIT License](LICENSE)の下で公開されています。

## 🤝 コントリビューション

プルリクエストやIssueでのコントリビューションを歓迎いたします！

---

🚀 **Agent Communication を体感してください！** 🤖✨ 
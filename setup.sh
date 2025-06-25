#!/bin/bash

# 🚀 Multi-Agent Communication Demo 環境構築
# 使用法: ./setup.sh [--skip-permissions]

set -e  # エラー時に停止

# 色付きログ関数
log_info() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[1;34m[SUCCESS]\033[0m $1"
}

# 引数処理
SKIP_PERMISSIONS=""
if [[ "$1" == "--skip-permissions" ]]; then
    SKIP_PERMISSIONS="--dangerously-skip-permissions"
    log_info "⚠️  --dangerously-skip-permissions モードで起動します"
fi

echo "🤖 Multi-Agent Communication Demo 環境構築"
echo "==========================================="
echo ""

# 使用法表示
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo "使用法: $0 [オプション]"
    echo ""
    echo "オプション:"
    echo "  --skip-permissions    Claude Codeを--dangerously-skip-permissionsで起動"
    echo "  -h, --help           このヘルプを表示"
    echo ""
    exit 0
fi

# STEP 1: 既存セッションクリーンアップ
log_info "🧹 既存セッションクリーンアップ開始..."

tmux kill-session -t multiagent 2>/dev/null && log_info "multiagentセッション削除完了" || log_info "multiagentセッションは存在しませんでした"

log_success "✅ クリーンアップ完了"
echo ""

# STEP 2: multiagentセッション作成（2ペイン：reviewer + implementer）
log_info "📺 multiagentセッション作成開始 (2ペイン)..."

# セッション作成
log_info "セッション作成中..."
tmux new-session -d -s multiagent -n "agents"

# セッション作成の確認
if ! tmux has-session -t multiagent 2>/dev/null; then
    echo "❌ エラー: multiagentセッションの作成に失敗しました"
    exit 1
fi

log_info "セッション作成成功"

# 2x2グリッド作成（ウィンドウ名使用でbase-index非依存）
log_info "グリッド作成中..."

# 水平分割（ウィンドウ名で指定）
log_info "水平分割実行中..."
tmux split-window -h -t "multiagent:agents"

# ペインの配置確認
log_info "ペイン配置確認中..."
PANE_COUNT=$(tmux list-panes -t "multiagent:agents" | wc -l)
log_info "作成されたペイン数: $PANE_COUNT"

if [ "$PANE_COUNT" -ne 2 ]; then
    echo "❌ エラー: 期待されるペイン数(4)と異なります: $PANE_COUNT"
    exit 1
fi

# ペインの物理的な配置を取得（top-leftから順番に）
log_info "ペイン番号取得中..."
# tmuxのペイン番号を位置に基づいて取得
PANE_IDS=($(tmux list-panes -t "multiagent:agents" -F "#{pane_id}" | sort))

log_info "検出されたペイン: ${PANE_IDS[*]}"

# ペインタイトル設定とセットアップ
log_info "ペインタイトル設定中..."
PANE_TITLES=("reviewer" "implementer")

for i in {0..1}; do
    PANE_ID="${PANE_IDS[$i]}"
    TITLE="${PANE_TITLES[$i]}"
    
    log_info "設定中: ${TITLE} (${PANE_ID})"
    
    # ペインタイトル設定
    tmux select-pane -t "$PANE_ID" -T "$TITLE"
    
    # 作業ディレクトリ設定
    tmux send-keys -t "$PANE_ID" "cd $(pwd)" C-m
    
    # カラープロンプト設定
    if [ $i -eq 0 ]; then
        # reviewer: 赤色
        tmux send-keys -t "$PANE_ID" "export PS1='(\[\033[1;31m\]${TITLE}\[\033[0m\]) \[\033[1;32m\]\w\[\033[0m\]\$ '" C-m
    else
        # implementer: 青色
        tmux send-keys -t "$PANE_ID" "export PS1='(\[\033[1;34m\]${TITLE}\[\033[0m\]) \[\033[1;32m\]\w\[\033[0m\]\$ '" C-m
    fi
    
    # ウェルカムメッセージ
    tmux send-keys -t "$PANE_ID" "echo '=== ${TITLE} エージェント ==='" C-m
done

log_success "✅ multiagentセッション作成完了"
echo ""

# STEP 3: 環境確認・表示
log_info "🔍 環境確認中..."

echo ""
echo "📊 セットアップ結果:"
echo "==================="

# tmuxセッション確認
echo "📺 Tmux Sessions:"
tmux list-sessions
echo ""

# ペイン構成表示
echo "📋 ペイン構成:"
echo "  multiagentセッション（4ペイン）:"
tmux list-panes -t "multiagent:agents" -F "    Pane #{pane_id}: #{pane_title}"

echo ""
log_success "🎉 Demo環境セットアップ完了！"
echo ""

# STEP 4: Claude Code起動
log_info "🤖 Claude Codeを起動中..."

# 両ペインでClaude Codeを起動
for i in {0..1}; do 
    if [[ -n "$SKIP_PERMISSIONS" ]]; then
        tmux send-keys -t multiagent:0.$i "claude $SKIP_PERMISSIONS" C-m
    else
        tmux send-keys -t multiagent:0.$i 'claude' C-m
    fi
    sleep 0.5
done

log_success "✅ Claude Code起動完了"
echo ""

# STEP 5: セッションアタッチ
log_info "🔗 multiagentセッションにアタッチ中..."
echo ""
echo "📋 セットアップ完了:"
echo "  - reviewerペイン（左）: レビュアー"
echo "  - implementerペイン（右）: 実装者"
echo ""
echo "🎯 デモ実行:"
echo "  implementerペインに「あなたはimplementerです。指示書に従って」と入力"
echo ""
echo "📜 指示書:"
echo "  - implementer: instructions/implementer.md"
echo "  - reviewer: instructions/reviewer.md"
echo "  - システム構造: CLAUDE.md"
echo ""

# セッションアタッチ
tmux attach-session -t multiagent

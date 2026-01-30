#!/bin/bash
# 貓星人賺大錢 - 一鍵啟動腳本

cd "$(dirname "$0")"
INSTALL_DIR="$(pwd)"

echo "🐱 貓星人賺大錢 - 台股篩選器"
echo "================================"

# 檢查 Python
if ! command -v python3 &> /dev/null; then
    echo "❌ 請先安裝 Python 3"
    echo "   下載: https://www.python.org/downloads/"
    read -p "按 Enter 結束..."
    exit 1
fi

# 首次運行：安裝依賴
if [ ! -d "$INSTALL_DIR/backend/venv" ]; then
    echo "📦 首次運行，正在安裝依賴..."
    cd "$INSTALL_DIR/backend"
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    echo "✅ 依賴安裝完成"
fi

# 啟動後端
echo "🚀 啟動後端服務..."
cd "$INSTALL_DIR/backend"
source venv/bin/activate
python3 -m uvicorn main:app --host 127.0.0.1 --port 8000 &
BACKEND_PID=$!

# 等待後端啟動
sleep 3

# 開啟前端 App
echo "🖥️  開啟應用程式..."
open "$INSTALL_DIR/貓星人賺大錢.app"

echo ""
echo "✅ 應用程式已啟動！"
echo "   關閉此視窗將停止後端服務"
echo ""

# 等待用戶關閉
wait $BACKEND_PID

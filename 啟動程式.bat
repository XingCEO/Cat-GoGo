@echo off
chcp 65001 >nul
title 貓星人賺大錢 - 台股篩選器

echo.
echo  ╔═══════════════════════════════════════╗
echo  ║     🐱 貓星人賺大錢 - 台股篩選器      ║
echo  ╚═══════════════════════════════════════╝
echo.

cd /d "%~dp0"

REM 檢查 Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 請先安裝 Python 3
    echo    下載: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

REM 檢查 Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 請先安裝 Node.js
    echo    下載: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo ✓ Python 已安裝
echo ✓ Node.js 已安裝
echo.

REM 首次運行：安裝後端依賴
if not exist "backend\venv" (
    echo 📦 首次運行，正在安裝後端依賴...
    cd backend
    python -m venv venv
    call venv\Scripts\activate.bat
    pip install -r requirements.txt
    cd ..
    echo ✅ 後端依賴安裝完成
    echo.
)

REM 首次運行：安裝前端依賴
if not exist "frontend\node_modules" (
    echo 📦 正在安裝前端依賴...
    cd frontend
    call npm install
    cd ..
    echo ✅ 前端依賴安裝完成
    echo.
)

REM 啟動後端
echo 🚀 啟動後端服務 (port 8000)...
cd backend
call venv\Scripts\activate.bat
start /B python -m uvicorn main:app --host 127.0.0.1 --port 8000
cd ..

REM 等待後端啟動
timeout /t 3 /nobreak >nul

REM 啟動前端
echo 🖥️  啟動前端服務 (port 5173)...
cd frontend
start /B npm run dev

REM 等待前端啟動
timeout /t 5 /nobreak >nul

echo.
echo ════════════════════════════════════════
echo ✅ 應用程式已啟動！
echo.
echo    前端: http://localhost:5173
echo    後端: http://localhost:8000
echo.
echo    請在瀏覽器開啟 http://localhost:5173
echo ════════════════════════════════════════
echo.
echo 按任意鍵關閉所有服務...
pause >nul

REM 關閉服務
taskkill /F /IM "node.exe" >nul 2>&1
taskkill /F /IM "python.exe" >nul 2>&1
echo 服務已關閉

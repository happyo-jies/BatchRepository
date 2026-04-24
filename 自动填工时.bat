@echo off
chcp 65001 >nul 2>&1

set "PROJECT_DIR=D:\Myself Project\DingTalk Timesheet Automation"
set "VENV_DIR=%PROJECT_DIR%\.venv"
set "PYTHON_EXE=%VENV_DIR%\Scripts\python.exe"

echo 项目目录：%PROJECT_DIR%
echo 虚拟环境Python路径：%PYTHON_EXE%

echo 依赖安装完成，开始执行脚本...
"%PYTHON_EXE%" "%PROJECT_DIR%\main.py"

echo.
echo 执行完成！
timeout 5
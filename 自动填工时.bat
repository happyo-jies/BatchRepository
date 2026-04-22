@echo off

chcp 936

cd /d "D:\Python Project\DingTalk Timesheet Automation"

call .venv\Scripts\activate.bat

echo 已激活虚拟环境，开始执行脚本...

python main.py

echo.

echo 执行完成！

timeout 3
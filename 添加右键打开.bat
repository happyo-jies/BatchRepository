@echo off
chcp 65001 >nul
title 添加 VS Code 右键菜单
color 0B

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ==========================================
    echo [错误] 此脚本需要管理员权限才能写入注册表！
    echo ==========================================
    echo 正在尝试请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ==========================================
echo   正在配置 VS Code 右键菜单...
echo ==========================================

:: 1. 尝试自动寻找 VS Code 路径
set "VSCODE_PATH=D:\Program Files\Microsoft VS Code\Code.exe"


:: 定义菜单名称
set "MenuText=使用 VS Code 打开"
set "IconArg=%VSCODE_PATH%"

echo 正在写入注册表 (文件夹)...
:: 针对文件夹 (Directory)
reg add "HKCR\Directory\shell\VSCode" /ve /t REG_SZ /d "%MenuText%" /f >nul
reg add "HKCR\Directory\shell\VSCode" /v "Icon" /t REG_SZ /d "%IconArg%" /f >nul
reg add "HKCR\Directory\shell\VSCode\command" /ve /t REG_SZ /d "\"%VSCODE_PATH%\" \"%%V\"" /f >nul

echo 正在写入注册表 (所有文件)...
:: 针对所有文件 (*)
reg add "HKCR\*\shell\VSCode" /ve /t REG_SZ /d "%MenuText%" /f >nul
reg add "HKCR\*\shell\VSCode" /v "Icon" /t REG_SZ /d "%IconArg%" /f >nul
reg add "HKCR\*\shell\VSCode\command" /ve /t REG_SZ /d "\"%VSCODE_PATH%\" \"%%1\"" /f >nul

:: 针对文件夹背景 (在文件夹内空白处右键)
echo 正在写入注册表 (文件夹背景)...
reg add "HKCR\Directory\Background\shell\VSCode" /ve /t REG_SZ /d "%MenuText%" /f >nul
reg add "HKCR\Directory\Background\shell\VSCode" /v "Icon" /t REG_SZ /d "%IconArg%" /f >nul
reg add "HKCR\Directory\Background\shell\VSCode\command" /ve /t REG_SZ /d "\"%VSCODE_PATH%\" \"%%V\"" /f >nul

echo.
echo ==========================================
echo [完成] VS Code 右键菜单添加成功！
echo - 现在你可以右键点击【文件夹】打开
echo - 现在你可以右键点击【任意文件】打开
echo - 现在你可以在【文件夹内部空白处】右键打开当前目录
echo ==========================================
pause
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title 连接WiFi网络 - hs-office-1
color 0A

echo 正在连接到 WiFi 网络: hs-office-1
echo.

:: 查看可用的无线网络接口
netsh wlan show interfaces


echo.

:: 连接到网络
netsh wlan connect name="hs-office-1"

echo.
timeout /t 2 /nobreak >nul

:: 检查连接状态
echo 检查连接状态...
netsh wlan show interfaces | findstr "hs-office-1"

echo.
echo 脚本执行完成！


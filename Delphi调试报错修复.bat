@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: 脚本说明：修改注册表[HKEY_CURRENT_USER\Control Panel\Desktop\]中的UserPreferencesMask键值
:: 目标值：0000 B0 32 07 80 (十六进制二进制值)
:: 注意：此操作可能影响系统显示设置，请谨慎使用

echo 正在修改注册表项 HKEY_CURRENT_USER\Control Panel\Desktop\UserPreferencesMask...
echo 目标值：0000 B0 32 07 80

:: 使用reg命令修改注册表项
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d "B0320780" /f

if !errorlevel! equ 0 (
    echo.
    echo 注册表项修改成功！
    echo.
    echo 为了使更改生效，建议注销或重启计算机。
    echo.
) else (
    echo.
    echo 错误：注册表项修改失败！
    echo 可能原因：
    echo  - 权限不足
    echo  - 注册表路径不存在
    echo  - 值名称错误
    echo.
    pause
    exit /b 1
)

echo 操作完成。
pause

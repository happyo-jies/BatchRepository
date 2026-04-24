@echo off
chcp 65001 >nul 2>&1
title 通用右键菜单添加工具
color 0E

:: 1. 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ==========================================
    echo [提示] 需要管理员权限写入注册表。
    echo 正在请求提升权限...
    echo ==========================================
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:Start
cls
echo ==========================================
echo   通用右键菜单添加工具
echo ==========================================
echo.
echo 请提供以下信息 (直接回车可取消):
echo.

:: 2. 输入程序路径
set /p "ExePath=请输入目标程序的完整路径 (例如: C:\Program Files\App\app.exe): "
if "%ExePath%"=="" goto :EOF
if not exist "%ExePath%" (
    echo.
    echo [错误] 文件不存在！请检查路径。
    echo 按任意键重试...
    pause >nul
    goto :Start
)

:: 3. 输入菜单显示名称
set /p "MenuName=请输入右键菜单显示的名称 (例如: 用我的工具打开): "
if "%MenuName%"=="" goto :EOF

:: 4. 输入图标路径 (可选)
echo.
echo 提示：可以直接使用程序本身的 exe 作为图标，也可以留空使用默认图标。
set /p "IconPath=请输入图标路径 (直接回车则使用程序自身图标): "
if "%IconPath%"=="" set "IconPath=%ExePath%"
if not exist "%IconPath%" (
    echo [警告] 图标文件未找到，将尝试使用默认图标或程序自带图标。
    set "IconPath=%ExePath%"
)

:: 清理注册表键名中的特殊字符 (简单处理，仅保留字母数字和空格)
:: 注册表键名不能包含 \ / : * ? " < > |
set "RegKey=%MenuName%"
setlocal enabledelayedexpansion
for %%c in ("\\" "/" ":" "*" "?" """ "<" ">" "|") do (
    set "RegKey=!RegKey:%%c=_!"
)
endlocal & set "RegKey=%RegKey%"
:: 再次处理因为上面循环变量作用域问题可能没替换干净的情况，这里用简单替换
set "RegKey=%MenuName: =_%" 
set "RegKey=%RegKey:\=_%"
set "RegKey=%RegKey:/=_%"
set "RegKey=%RegKey:=_%"
:: 为了简单起见，我们生成一个唯一的内部ID，但显示名保持用户输入的
set "InternalKey=CustomTool_%Random%"

echo.
echo ==========================================
echo 正在配置...
echo 程序: %ExePath%
echo 显示名: %MenuName%
echo 图标: %IconPath%
echo ==========================================
echo.

:: 5. 写入注册表

:: A. 针对所有文件 (*)
echo [1/3] 添加至【所有文件】右键菜单...
reg add "HKCR\*\shell\%InternalKey%" /ve /t REG_SZ /d "%MenuName%" /f >nul
reg add "HKCR\*\shell\%InternalKey%" /v "Icon" /t REG_SZ /d "%IconPath%" /f >nul
:: %1 代表选中的文件
reg add "HKCR\*\shell\%InternalKey%\command" /ve /t REG_SZ /d "\"%ExePath%\" \"%%1\"" /f >nul

:: B. 针对文件夹 (Directory)
echo [2/3] 添加至【文件夹】右键菜单...
reg add "HKCR\Directory\shell\%InternalKey%" /ve /t REG_SZ /d "%MenuName%" /f >nul
reg add "HKCR\Directory\shell\%InternalKey%" /v "Icon" /t REG_SZ /d "%IconPath%" /f >nul
:: %V 代表选中的文件夹
reg add "HKCR\Directory\shell\%InternalKey%\command" /ve /t REG_SZ /d "\"%ExePath%\" \"%%V\"" /f >nul

:: C. 针对文件夹背景 (Directory\Background)
echo [3/3] 添加至【文件夹背景】右键菜单...
reg add "HKCR\Directory\Background\shell\%InternalKey%" /ve /t REG_SZ /d "%MenuName%" /f >nul
reg add "HKCR\Directory\Background\shell\%InternalKey%" /v "Icon" /t REG_SZ /d "%IconPath%" /f >nul
:: %V 代表当前文件夹路径
reg add "HKCR\Directory\Background\shell\%InternalKey%\command" /ve /t REG_SZ /d "\"%ExePath%\" \"%%V\"" /f >nul

echo.
echo ==========================================
echo [成功] 添加完成！
echo 请右键点击任意文件或文件夹测试 "%MenuName%"。
echo ==========================================
echo.
set /p "Choice=是否继续添加另一个程序？(Y/N): "
if /i "%Choice%"=="Y" goto :Start

pause
exit /b
@echo off
SETLOCAL EnableDelayedExpansion
mode con: cols=120 lines=25
color 0F

:: ==============================================
:: 功能：判断明天是否为 非工作日（周末/节假日）
:: 满足条件：明天非工作日 **并且** 今天是工作日 → 运行 自动填工时.bat
:: ==============================================

:: ===================== 1. 获取日期 =====================
:: 获取今天日期：YYYY-MM-DD
for /f "delims=" %%a in ('powershell "(Get-Date).ToString('yyyy-MM-dd')"') do set "today=%%a"
:: 获取明天日期：YYYY-MM-DD
for /f "delims=" %%a in ('powershell "(Get-Date).AddDays(1).ToString('yyyy-MM-dd')"') do set "tomorrow=%%a"
set tomorrow=2026-04-06

echo ========================================================
echo              节假日判断工具 - 优化稳定版
echo ========================================================
echo 今天日期：!today!
echo 明天日期：!tomorrow!
echo ========================================================
echo.

:: ===================== 2. 查询今天节假日状态 =====================
echo [信息] 正在查询今天是否为工作日...
curl -s -m 5 "http://tool.bitefu.net/jiari/?d=!today!" > temp.tmp 2>nul
if not exist temp.tmp (
    echo [错误] 网络请求失败，请检查网络连接！
    goto End
)
set /p apiTodayResult=<temp.tmp
del /f /q temp.tmp >nul 2>&1

:: 检查API是否返回错误
echo !apiTodayResult! | findstr /i "error" >nul && (
    echo [错误] API查询失败，无法获取今日信息！
    goto End
)
echo [今日状态] !apiTodayResult! （0=工作日 1=节假日 2=周末）
echo.

:: ===================== 3. 查询明天节假日状态 =====================
echo [信息] 正在查询明天是否为工作日...
curl -s -m 5 "http://tool.bitefu.net/jiari/?d=!tomorrow!" > temp.tmp 2>nul
if not exist temp.tmp (
    echo [错误] 网络请求失败，请检查网络连接！
    goto End
)
set /p apiTomorrowResult=<temp.tmp
del /f /q temp.tmp >nul 2>&1

:: 检查API是否返回错误
echo !apiTomorrowResult! | findstr /i "error" >nul && (
    echo [错误] API查询失败，无法获取明日信息！
    goto End
)
echo [明日状态] !apiTomorrowResult! （0=工作日 1=节假日 2=周末）
echo.

:: ===================== 4. 核心判断逻辑 =====================
:: 满足条件：今天是工作日  并且  明天是非工作日 → 执行填工时
if "!apiTodayResult!" equ "0" (
    if "!apiTomorrowResult!" neq "0" (
        goto RunWorkScript
    )
)

:: 不满足条件
echo ========================================================
echo [结果] 不满足执行条件，不运行自动填工时脚本
goto End

:: ===================== 5. 执行脚本 =====================
:RunWorkScript
echo ========================================================
echo [结果] 满足条件：今天工作日 + 明天非工作日
echo [操作] 正在启动 自动填工时.bat
call "自动填工时.bat"
echo [完成] 脚本执行完毕
goto End

:: ===================== 结束 =====================
:End
echo.
echo ========================================================
echo 任务全部结束退出...
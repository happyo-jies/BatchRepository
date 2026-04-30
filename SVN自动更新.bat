@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

@REM :: 你的固定路径
@REM set "BASE_DIR=E:\workspace\Release\保险版本\IS20170920\Patch"

@REM echo 搜索目录：!BASE_DIR!
@REM echo ==============================================

@REM :: 【稳定写法】DIR 方式搜索，100% 能找到，不会空
@REM for /f "delims=" %%a in ('dir /ad /s /b "!BASE_DIR!\*201703G.8*" 2^>nul') do (
@REM     echo 找到文件夹：%%a
@REM )
@REM for /f "delims=" %%a in ('dir /ad /s /b "!BASE_DIR!\*201703B.74*" 2^>nul') do (
@REM     echo 找到文件夹：%%a
@REM )
@REM for /f "delims=" %%a in ('dir /ad /s /b "!BASE_DIR!\*201703B.80*" 2^>nul') do (
@REM     echo 找到文件夹：%%a
@REM )
@REM for /f "delims=" %%a in ('dir /ad /s /b "!BASE_DIR!\*201703B.9*" 2^>nul') do (
@REM     echo 找到文件夹：%%a
@REM )
@REM for /f "delims=" %%a in ('dir /ad /s /b "!BASE_DIR!\*201703B.07.022*" 2^>nul') do (
@REM     echo 找到文件夹：%%a
@REM )

@REM echo ==============================================
@REM echo 搜索完成！
@REM pause


echo ==============================
echo    SVN 自动更新（修复乱码）
echo ==============================

:: 你的路径
set "SVN_PATH=E:\workspace\Release\保险版本\IS20170920\Patch"

:: 先进入目录，再更新（最稳！）
cd /d "!SVN_PATH!"
echo 当前目录：%cd%

:: 执行更新
svn update --accept theirs-full

echo.
echo 更新完成！
pause
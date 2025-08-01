@echo off
setlocal enabledelayedexpansion

:: 获取当前日期（格式：YYYY-MM-DD）
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set datetime=%%a
set currentdate=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%

:: 获取当前时间（格式：HH:MM:SS）
set currenttime=%datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%

:: 用户输入
set /p filename="input filename: "
set /p title="input title: "
set /p categories="input categories (split with space): "
set /p tags="input tags (split with space): "
set /p top="input top:"

:: 临时文件
set tmpfile=%~dp0%filename%.tmp

:: 输出 Markdown 内容到临时文件
(
  echo ---
  echo title: %title%
  echo date: %currentdate% %currenttime%
  echo top: %top%
  echo categories:
  for %%c in (%categories%) do (
    echo - %%c
  )
  echo tags:
  for %%c in (%tags%) do (
    echo - %%c
  )
  echo ---
) > "%tmpfile%"

:: 使用 PowerShell 转换为 UTF-8 编码
powershell -Command "Get-Content -Raw -Encoding OEM '%tmpfile%' | Set-Content -Encoding UTF8 '%~dp0%filename%.md'"

:: 删除临时文件
del "%tmpfile%"

echo 文件已生成: "%~dp0%filename%.md"

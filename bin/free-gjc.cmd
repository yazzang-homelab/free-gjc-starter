@echo off
REM free-gjc.cmd - Windows: run gjc with the FREE starter profile (%USERPROFILE%\.gjc-free\agent).
REM Bare `gjc` keeps using your normal profile, separate from this one.
REM GJC_CODING_AGENT_DIR moves only the user agent dir; project .gjc\ folders still load.
setlocal
if defined GJC_FREE_AGENT_DIR (set "GJC_CODING_AGENT_DIR=%GJC_FREE_AGENT_DIR%") else (set "GJC_CODING_AGENT_DIR=%USERPROFILE%\.gjc-free\agent")
set "PI_CODING_AGENT_DIR="
set "GJC_CONFIG_DIR="
set "PI_CONFIG_DIR="
REM Free-tier upstreams can take well over gjc's default 100s to emit the first
REM token. Widen the stream watchdogs (first event 10min, idle 5min).
if not defined PI_STREAM_FIRST_EVENT_TIMEOUT_MS set "PI_STREAM_FIRST_EVENT_TIMEOUT_MS=600000"
if not defined PI_STREAM_IDLE_TIMEOUT_MS set "PI_STREAM_IDLE_TIMEOUT_MS=300000"
for /f "delims==" %%V in ('set ANTHROPIC_ 2^>nul') do set "%%V="
gjc %*
exit /b %ERRORLEVEL%

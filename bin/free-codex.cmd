@echo off
REM free-codex.cmd - run OpenAI Codex CLI on OpenRouter ":free" models (no ChatGPT/OpenAI billing).
REM Isolated CODEX_HOME %USERPROFILE%\.gjc-free\codex; your normal Codex profile is untouched.
setlocal
if not defined OPENROUTER_API_KEY (
  echo OPENROUTER_API_KEY is not set. Get one at https://openrouter.ai/keys 1>&2
  exit /b 1
)
if defined FREE_CODEX_HOME (set "CODEX_HOME=%FREE_CODEX_HOME%") else (set "CODEX_HOME=%USERPROFILE%\.gjc-free\codex")
if not exist "%CODEX_HOME%\config.toml" (
  echo %CODEX_HOME%\config.toml is missing. Re-run install.ps1 from free-gjc-starter. 1>&2
  exit /b 1
)
set "OPENAI_API_KEY="
set "OPENAI_BASE_URL="
set "OPENAI_ORG_ID="
set "OPENAI_PROJECT_ID="
codex %*
exit /b %ERRORLEVEL%

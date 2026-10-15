@echo off
REM free-claude.cmd - run Claude Code on OpenRouter ":free" models (no Anthropic subscription).
REM Isolated config dir %USERPROFILE%\.gjc-free\claude; your normal Claude Code profile is untouched.
setlocal
if not defined OPENROUTER_API_KEY (
  echo OPENROUTER_API_KEY is not set. Get one at https://openrouter.ai/keys 1>&2
  exit /b 1
)
for /f "delims==" %%V in ('set ANTHROPIC_ 2^>nul') do set "%%V="
if not defined FREE_CLAUDE_MODEL set "FREE_CLAUDE_MODEL=nvidia/nemotron-3-super-120b-a12b:free"
if not defined FREE_CLAUDE_BIG_MODEL set "FREE_CLAUDE_BIG_MODEL=nvidia/nemotron-3-ultra-550b-a55b:free"
if defined FREE_CLAUDE_CONFIG_DIR (set "CLAUDE_CONFIG_DIR=%FREE_CLAUDE_CONFIG_DIR%") else (set "CLAUDE_CONFIG_DIR=%USERPROFILE%\.gjc-free\claude")
set "ANTHROPIC_BASE_URL=https://openrouter.ai/api"
set "ANTHROPIC_AUTH_TOKEN=%OPENROUTER_API_KEY%"
set "ANTHROPIC_MODEL=%FREE_CLAUDE_MODEL%"
set "ANTHROPIC_DEFAULT_OPUS_MODEL=%FREE_CLAUDE_BIG_MODEL%"
set "ANTHROPIC_DEFAULT_SONNET_MODEL=%FREE_CLAUDE_MODEL%"
set "ANTHROPIC_DEFAULT_HAIKU_MODEL=%FREE_CLAUDE_MODEL%"
set "CLAUDE_CODE_SUBAGENT_MODEL=%FREE_CLAUDE_MODEL%"
if not defined CLAUDE_CODE_MAX_CONTEXT_TOKENS set "CLAUDE_CODE_MAX_CONTEXT_TOKENS=262144"
claude %*
exit /b %ERRORLEVEL%

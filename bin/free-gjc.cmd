@echo off
REM free-gjc.cmd - Windows: run gjc with the FREE starter profile (%USERPROFILE%\.gjc-free).
REM default(main) = your Gemini via OAuth; subagents = your own free keys (OpenRouter/Groq).
REM Bare `gjc` keeps using your normal profile, separate from this one.
setlocal
set "GJC_CONFIG_DIR=.gjc-free"
set "ANTHROPIC_API_KEY="
set "ANTHROPIC_AUTH_TOKEN="
set "ANTHROPIC_OAUTH_TOKEN="
set "ANTHROPIC_BASE_URL="
gjc %*

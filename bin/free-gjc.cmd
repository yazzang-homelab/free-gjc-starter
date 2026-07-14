@echo off
REM free-gjc.cmd - Windows: run gjc with the FREE starter profile (%USERPROFILE%\.gjc-free).
REM default(main) = your Gemini via OAuth; subagents = your own free keys (OpenRouter/Groq).
REM Bare `gjc` keeps using your normal profile, separate from this one.
setlocal
set "GJC_CONFIG_DIR=.gjc-free"
REM Free-tier upstreams can take well over gjc's default 100s to emit the first
REM token. free-gjc is for latency-tolerant work: widen the stream watchdogs
REM (first event 10min, idle 5min). Set your own values beforehand to override.
if not defined PI_STREAM_FIRST_EVENT_TIMEOUT_MS set "PI_STREAM_FIRST_EVENT_TIMEOUT_MS=600000"
if not defined PI_STREAM_IDLE_TIMEOUT_MS set "PI_STREAM_IDLE_TIMEOUT_MS=300000"
set "ANTHROPIC_API_KEY="
set "ANTHROPIC_AUTH_TOKEN="
set "ANTHROPIC_OAUTH_TOKEN="
set "ANTHROPIC_BASE_URL="
gjc %*

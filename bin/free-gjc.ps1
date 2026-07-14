# free-gjc.ps1 - Windows PowerShell: run gjc with the FREE starter profile (~/.gjc-free).
# default(main) = your Gemini via OAuth; subagents = your own free keys (OpenRouter/Groq).
# Bare `gjc` keeps using your normal profile, separate from this one.
$env:GJC_CONFIG_DIR = ".gjc-free"
# Free-tier upstreams can take well over gjc's default 100s to emit the first
# token. free-gjc is for latency-tolerant work: widen the stream watchdogs
# (first event 10min, idle 5min). Set your own values beforehand to override.
if (-not $env:PI_STREAM_FIRST_EVENT_TIMEOUT_MS) { $env:PI_STREAM_FIRST_EVENT_TIMEOUT_MS = "600000" }
if (-not $env:PI_STREAM_IDLE_TIMEOUT_MS) { $env:PI_STREAM_IDLE_TIMEOUT_MS = "300000" }
Remove-Item Env:ANTHROPIC_API_KEY,Env:ANTHROPIC_AUTH_TOKEN,Env:ANTHROPIC_OAUTH_TOKEN,Env:ANTHROPIC_BASE_URL -ErrorAction SilentlyContinue
gjc @args

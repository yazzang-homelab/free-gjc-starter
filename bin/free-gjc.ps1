# free-gjc.ps1 - Windows PowerShell: run gjc with the FREE starter profile (~/.gjc-free/agent).
# Bare `gjc` keeps using your normal profile, separate from this one.
# GJC_CODING_AGENT_DIR moves only the user agent dir; project `.gjc/` folders still load.
$env:GJC_CODING_AGENT_DIR = if ($env:GJC_FREE_AGENT_DIR) { $env:GJC_FREE_AGENT_DIR } else { Join-Path $env:USERPROFILE ".gjc-free\agent" }
Remove-Item Env:PI_CODING_AGENT_DIR,Env:GJC_CONFIG_DIR,Env:PI_CONFIG_DIR -ErrorAction SilentlyContinue
# Free-tier upstreams can take well over gjc's default 100s to emit the first
# token. Widen the stream watchdogs (first event 10min, idle 5min).
if (-not $env:PI_STREAM_FIRST_EVENT_TIMEOUT_MS) { $env:PI_STREAM_FIRST_EVENT_TIMEOUT_MS = "600000" }
if (-not $env:PI_STREAM_IDLE_TIMEOUT_MS) { $env:PI_STREAM_IDLE_TIMEOUT_MS = "300000" }
Get-ChildItem Env: | Where-Object { $_.Name -like "ANTHROPIC_*" } | ForEach-Object { Remove-Item "Env:$($_.Name)" }
gjc @args
exit $LASTEXITCODE

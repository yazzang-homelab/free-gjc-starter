# free-gjc.ps1 - Windows PowerShell: run gjc with the FREE starter profile (~/.gjc-free).
# default(main) = your Gemini via OAuth; subagents = your own free keys (OpenRouter/Groq).
# Bare `gjc` keeps using your normal profile, separate from this one.
$env:GJC_CONFIG_DIR = ".gjc-free"
Remove-Item Env:ANTHROPIC_API_KEY,Env:ANTHROPIC_AUTH_TOKEN,Env:ANTHROPIC_OAUTH_TOKEN,Env:ANTHROPIC_BASE_URL -ErrorAction SilentlyContinue
gjc @args

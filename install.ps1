# free-gjc-starter installer (Windows).
# Places the FREE starter profile at %USERPROFILE%\.gjc-free and free-gjc.cmd on PATH.
# Installs NO keys and NO login — you provide those yourself (see README).
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$U = $env:USERPROFILE

if (-not (Get-Command gjc -ErrorAction SilentlyContinue)) {
    Write-Host "gjc 가 없습니다. 먼저 설치하세요:" -ForegroundColor Yellow
    Write-Host '  powershell -c "irm bun.sh/install.ps1|iex"'
    Write-Host "  bun install -g gajae-code"
    exit 1
}

# FREE 프로필 -> %USERPROFILE%\.gjc-free\agent
New-Item -ItemType Directory -Force -Path "$U\.gjc-free\agent" | Out-Null
Copy-Item "$here\agent\config.yml" "$U\.gjc-free\agent\config.yml" -Force
Copy-Item "$here\agent\models.yml" "$U\.gjc-free\agent\models.yml" -Force

# free-gjc.cmd 런처 -> WindowsApps (user-writable, on PATH)
$binDst = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
Copy-Item "$here\bin\free-gjc.cmd" "$binDst\free-gjc.cmd" -Force

Write-Host ""
Write-Host "설치 완료. FREE 프로필 -> ~/.gjc-free, 런처 -> free-gjc.cmd" -ForegroundColor Green
Write-Host "다음 3가지를 본인 것으로 채우면 끝:"
Write-Host '  1) setx OPENROUTER_API_KEY "본인키"   (https://openrouter.ai/keys)'
Write-Host '     setx GROQ_API_KEY "본인키"          (https://console.groq.com/keys)'
Write-Host "  2) free-gjc  실행 후  /login google-antigravity  (구독) 또는 /login google-gemini-cli (무료)"
Write-Host '  3) free-gjc -p --no-session "누구니?"'

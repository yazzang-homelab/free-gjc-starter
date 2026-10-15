# free-gjc-starter installer (Windows).
# Places the FREE starter profile at %USERPROFILE%\.gjc-free\agent and free-gjc.cmd on PATH.
# Installs NO keys and NO login - you provide those yourself (see README).
#
#   powershell -ExecutionPolicy Bypass -File .\install.ps1          # 기존 config.yml 유지
#   powershell -ExecutionPolicy Bypass -File .\install.ps1 -Force   # 백업 후 새 설정으로 교체
param([switch]$Force)
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Get-Command gjc -ErrorAction SilentlyContinue)) {
    Write-Host "gjc 가 없습니다. 먼저 설치하세요:" -ForegroundColor Yellow
    Write-Host '  powershell -c "irm bun.sh/install.ps1|iex"'
    Write-Host "  bun install -g gajae-code"
    exit 1
}

$agent = Join-Path $env:USERPROFILE ".gjc-free\agent"
New-Item -ItemType Directory -Force -Path $agent | Out-Null
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$cfg = Join-Path $agent "config.yml"
$models = Join-Path $agent "models.yml"

if ((Test-Path $cfg) -and -not $Force) {
    Write-Host "기존 설정 유지: $cfg (새 설정으로 바꾸려면 -Force)"
    if (Select-String -Path $cfg -Pattern 'groq-free|nvidia-nim|openrouter-free|fallbackChains' -Quiet) {
        Write-Host "  예전 버전 설정입니다(Groq 레인/옛 provider 이름). install.ps1 -Force 로 교체하세요." -ForegroundColor Yellow
    }
} else {
    if (Test-Path $cfg) {
        Move-Item $cfg "$cfg.bak-$stamp"
        Write-Host "백업: $cfg.bak-$stamp"
    }
    # 예전 버전이 깔던 models.yml(openrouter-free/groq-free/nvidia-nim)은 이제 필요 없다.
    if ($Force -and (Test-Path $models)) {
        Move-Item $models "$models.bak-$stamp"
        Write-Host "백업: $models.bak-$stamp"
    }
    Copy-Item (Join-Path $here "agent\config.yml") $cfg
}

# free-gjc.cmd 런처 -> WindowsApps (사용자 쓰기 가능, 기본 PATH 포함)
$binDst = Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps"
Copy-Item (Join-Path $here "bin\free-gjc.cmd") (Join-Path $binDst "free-gjc.cmd") -Force

Write-Host ""
Write-Host "설치 완료. FREE 프로필 -> $agent, 런처 -> free-gjc.cmd" -ForegroundColor Green
Write-Host "다음 3가지를 본인 것으로 채우면 끝:"
Write-Host '  1) setx OPENROUTER_API_KEY "본인키"   (https://openrouter.ai/keys)'
Write-Host '     setx NVIDIA_API_KEY "본인키"       (https://build.nvidia.com, nvapi-...)'
Write-Host "  2) (선택) free-gjc 실행 후  /login google-antigravity  (개인 Gmail = 무료 Gemini)"
Write-Host '  3) 새 터미널에서  free-gjc -p --no-session "누구니?"'

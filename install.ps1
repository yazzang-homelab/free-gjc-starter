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

$root = Join-Path $env:USERPROFILE ".gjc-free"
$agent = Join-Path $root "agent"
$codexDir = Join-Path $root "codex"
New-Item -ItemType Directory -Force -Path $agent, $codexDir | Out-Null
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$script:kept = $false

# 대상이 있으면 유지(-Force면 .bak-<시각> 백업 후 교체)
function Place($src, $dst) {
    if ((Test-Path $dst) -and -not $Force) {
        Write-Host "기존 설정 유지: $dst"
        $script:kept = $true
        return
    }
    if (Test-Path $dst) {
        Move-Item $dst "$dst.bak-$stamp"
        Write-Host "백업: $dst.bak-$stamp"
    }
    Copy-Item $src $dst
}

Place (Join-Path $here "agent\config.yml") (Join-Path $agent "config.yml")
Place (Join-Path $here "agent\models.yml") (Join-Path $agent "models.yml")
Place (Join-Path $here "codex\config.toml") (Join-Path $codexDir "config.toml")
Place (Join-Path $here "codex\ultra.config.toml") (Join-Path $codexDir "ultra.config.toml")

$old = @((Join-Path $agent "config.yml"), (Join-Path $agent "models.yml")) | Where-Object { Test-Path $_ }
if ($old -and (Select-String -Path $old -Pattern 'groq-free|nvidia-nim|openrouter-free|fallbackChains' -Quiet)) {
    Write-Host "  예전 버전 설정입니다(Groq 레인/옛 provider 이름). install.ps1 -Force 로 교체하세요." -ForegroundColor Yellow
} elseif ($script:kept) {
    Write-Host "  (새 설정으로 바꾸려면 -Force)"
}

# 런처(.cmd) -> WindowsApps (사용자 쓰기 가능, 기본 PATH 포함)
$binDst = Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps"
foreach ($b in "free-gjc.cmd", "free-claude.cmd", "free-codex.cmd") {
    Copy-Item (Join-Path $here "bin\$b") (Join-Path $binDst $b) -Force
}

Write-Host ""
Write-Host "설치 완료. FREE 프로필 -> $root, 런처 -> free-gjc / free-claude / free-codex (.cmd)" -ForegroundColor Green
Write-Host "다음 3가지를 본인 것으로 채우면 끝:"
Write-Host '  1) setx OPENROUTER_API_KEY "본인키"   (https://openrouter.ai/keys)'
Write-Host '     setx NVIDIA_API_KEY "본인키"       (https://build.nvidia.com, nvapi-...)'
Write-Host '     setx RADEON_API_KEY "본인키"       (선택, https://developer.amd.com.cn/radeon/tokenfactory)'
Write-Host "  2) (선택) free-gjc 실행 후  /login google-antigravity  (개인 Gmail = 무료 Gemini)"
Write-Host '  3) 새 터미널에서  free-gjc -p --no-session "누구니?"'
Write-Host "Claude Code / Codex 를 같은 무료 모델로: free-claude / free-codex (각 CLI가 설치돼 있을 때)"

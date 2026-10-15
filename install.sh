#!/usr/bin/env bash
# free-gjc-starter installer (Linux / macOS / Git-Bash).
# Places the FREE starter profile at ~/.gjc-free/agent and the `free-gjc` launcher on PATH.
# Installs NO keys and NO login — you provide those yourself (see README).
#
#   bash install.sh           # 기존 ~/.gjc-free/agent/config.yml 이 있으면 그대로 둔다
#   bash install.sh --force   # 기존 설정을 *.bak-<시각> 으로 백업한 뒤 새 설정으로 교체
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

force=0
for arg in "$@"; do
  case "$arg" in
    --force|-f) force=1 ;;
    *) echo "알 수 없는 옵션: $arg  (사용법: bash install.sh [--force])" >&2; exit 2 ;;
  esac
done

if ! command -v gjc >/dev/null 2>&1; then
  echo "gjc 가 없습니다. 먼저 설치하세요:"
  echo "  curl -fsSL https://bun.sh/install | bash   # bun 없으면"
  echo "  bun install -g gajae-code"
  exit 1
fi

agent="$HOME/.gjc-free/agent"
mkdir -p "$agent"
stamp="$(date +%Y%m%d-%H%M%S)"

if [ -e "$agent/config.yml" ] && [ "$force" -eq 0 ]; then
  echo "기존 설정 유지: $agent/config.yml (새 설정으로 바꾸려면: bash install.sh --force)"
  if grep -qE 'groq-free|nvidia-nim|openrouter-free|fallbackChains' "$agent/config.yml"; then
    echo "  ⚠ 예전 버전 설정입니다(Groq 레인·옛 provider 이름). bash install.sh --force 로 교체하세요."
  fi
else
  if [ -e "$agent/config.yml" ]; then
    mv "$agent/config.yml" "$agent/config.yml.bak-$stamp"
    echo "백업: $agent/config.yml.bak-$stamp"
  fi
  # 예전 버전이 깔던 models.yml(openrouter-free/groq-free/nvidia-nim)은 이제 필요 없다.
  if [ "$force" -eq 1 ] && [ -e "$agent/models.yml" ]; then
    mv "$agent/models.yml" "$agent/models.yml.bak-$stamp"
    echo "백업: $agent/models.yml.bak-$stamp"
  fi
  install -m644 "$here/agent/config.yml" "$agent/config.yml"
fi

bindir="$HOME/.local/bin"
mkdir -p "$bindir"
install -m755 "$here/bin/free-gjc" "$bindir/free-gjc"

cat <<EOF

설치 완료. FREE 프로필 -> $agent, 런처 -> $bindir/free-gjc
($bindir 가 PATH에 없으면 추가하세요: export PATH="\$HOME/.local/bin:\$PATH")

다음 3가지를 본인 것으로 채우면 끝:
  1) 무료 키 2개 (본인 발급, 셸 환경변수):
       export OPENROUTER_API_KEY=...   # https://openrouter.ai/keys
       export NVIDIA_API_KEY=...       # https://build.nvidia.com  (nvapi-...)
  2) 메인 Gemini 로그인 (본인 구글 계정, 선택):
       free-gjc            # 실행 후  /login google-antigravity
  3) 확인:
       free-gjc config get modelRoles
       free-gjc -p --no-session "누구니?"
EOF

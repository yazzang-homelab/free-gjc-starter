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

root="$HOME/.gjc-free"
agent="$root/agent"
codexdir="$root/codex"
mkdir -p "$agent" "$codexdir"
stamp="$(date +%Y%m%d-%H%M%S)"
kept=0

# place SRC DST: DST가 있으면 유지(--force면 .bak-<시각> 백업 후 교체)
place() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ "$force" -eq 0 ]; then
    echo "기존 설정 유지: $dst"
    kept=1
    return
  fi
  if [ -e "$dst" ]; then
    mv "$dst" "$dst.bak-$stamp"
    echo "백업: $dst.bak-$stamp"
  fi
  install -m644 "$src" "$dst"
}

place "$here/agent/config.yml" "$agent/config.yml"
place "$here/agent/models.yml" "$agent/models.yml"
place "$here/codex/config.toml" "$codexdir/config.toml"
place "$here/codex/ultra.config.toml" "$codexdir/ultra.config.toml"

if grep -qsE 'groq-free|nvidia-nim|openrouter-free|fallbackChains' "$agent/config.yml" "$agent/models.yml"; then
  echo "  ⚠ 예전 버전 설정입니다(Groq 레인·옛 provider 이름). bash install.sh --force 로 교체하세요."
elif [ "$kept" -eq 1 ]; then
  echo "  (새 설정으로 바꾸려면: bash install.sh --force)"
fi

bindir="$HOME/.local/bin"
mkdir -p "$bindir"
for b in free-gjc free-claude free-codex; do
  install -m755 "$here/bin/$b" "$bindir/$b"
done

cat <<EOF

설치 완료. FREE 프로필 -> $root, 런처 -> $bindir/{free-gjc,free-claude,free-codex}
($bindir 가 PATH에 없으면 추가하세요: export PATH="\$HOME/.local/bin:\$PATH")

다음 3가지를 본인 것으로 채우면 끝:
  1) 무료 키 2개 (본인 발급, 셸 환경변수):
       export OPENROUTER_API_KEY=...   # https://openrouter.ai/keys
       export NVIDIA_API_KEY=...       # https://build.nvidia.com  (nvapi-...)
       export RADEON_API_KEY=...       # (선택) https://developer.amd.com.cn/radeon/tokenfactory
  2) 메인 Gemini 로그인 (본인 구글 계정, 선택):
       free-gjc            # 실행 후  /login google-antigravity
  3) 확인:
       free-gjc config get modelRoles
       free-gjc -p --no-session "누구니?"

Claude Code·Codex를 같은 무료 모델로 쓰려면(설치돼 있을 때):
       free-claude        # Claude Code  + OpenRouter :free
       free-codex         # Codex CLI    + OpenRouter :free
EOF

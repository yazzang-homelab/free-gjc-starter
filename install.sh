#!/usr/bin/env bash
# free-gjc-starter installer (Linux / macOS / Git-Bash).
# Places the FREE starter profile at ~/.gjc-free and the `free-gjc` launcher on PATH.
# Idempotent. Installs NO keys and NO login — you provide those yourself (see README).
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v gjc >/dev/null 2>&1; then
  echo "gjc 가 없습니다. 먼저 설치하세요:"
  echo "  curl -fsSL https://bun.sh/install | bash   # bun 없으면"
  echo "  bun install -g gajae-code"
  exit 1
fi

# FREE 프로필 -> ~/.gjc-free/agent
install -Dm644 "$here/agent/config.yml" "$HOME/.gjc-free/agent/config.yml"
install -Dm644 "$here/agent/models.yml" "$HOME/.gjc-free/agent/models.yml"

# free-gjc 런처 설치 (~/.local/bin 우선, 없으면 /usr/local/bin)
bindir="$HOME/.local/bin"
mkdir -p "$bindir"
install -Dm755 "$here/bin/free-gjc" "$bindir/free-gjc"

cat <<EOF

설치 완료. FREE 프로필 -> ~/.gjc-free, 런처 -> $bindir/free-gjc
($bindir 가 PATH에 없으면 추가하세요: export PATH="\$HOME/.local/bin:\$PATH")

다음 3가지를 본인 것으로 채우면 끝:
  1) 무료 서브에이전트 키 (본인 발급, 셸 환경변수):
       export OPENROUTER_API_KEY=...   # https://openrouter.ai/keys
       export GROQ_API_KEY=...         # https://console.groq.com/keys
  2) 메인 Gemini 로그인 (본인 구글 계정):
       free-gjc            # 실행 후  /login google-antigravity
                           #   무료: 개인 Gmail이면 카드 없이 Gemini 3.1 Pro 무료티어(preview).
                           #   할당량 빡세니 429 나면 잠시 뒤 또는 NVIDIA GLM-5.2로.
  3) 확인:
       free-gjc config get modelRoles
       free-gjc -p --no-session "누구니?"
EOF

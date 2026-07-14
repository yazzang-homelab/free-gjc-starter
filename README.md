# free-gjc-starter

초보자용 **무료 gajae-code(gjc) 세팅**. 메인 두뇌는 **Gemini**(구독 또는 무료, OAuth 로그인),
나머지 서브에이전트는 **당신 본인이 발급받은 무료 모델**로 돌립니다.

> **비밀정보 없음.** 이 repo의 어떤 파일에도 API 키·개인정보가 없습니다. 모든 키는
> 환경변수 *이름*(`apiKeyEnv`)으로만 참조하고, 실제 키는 각자 자기 PC의 환경변수에 넣습니다.
> Gemini는 키가 아니라 OAuth 로그인으로 씁니다.

---

## 무엇을 쓰나

| 역할 | 모델 | 비용 |
| --- | --- | --- |
| `default` (메인 루프) | Gemini (`google-antigravity` 구독 / `google-gemini-cli` 무료) | 구독 or 무료 |
| `executor` (코딩) | Nemotron 3 Super 120B `:free` · OpenRouter | 무료 |
| `architect` (리뷰) | Nemotron 3 Super 120B `:free` · OpenRouter | 무료 |
| `planner` (계획) | Llama 3.3 70B · Groq | 무료 |
| `critic` (검증) | Llama 3.1 8B Instant · Groq | 무료 |

무료 모델이 죽으면 다른 무료 → 마지막엔 메인 Gemini로 자동 폴백합니다.

`bare gjc`(당신의 기존 `~/.gjc` 프로필)와 **완전히 분리**됩니다. 이 세팅은 `~/.gjc-free`에
설치되고 `free-gjc` 명령으로만 씁니다.

---

## 설치 (3단계)

### 1) gjc 설치
```bash
# Linux / macOS
curl -fsSL https://bun.sh/install | bash
bun install -g gajae-code
```
```powershell
# Windows
powershell -c "irm bun.sh/install.ps1|iex"
bun install -g gajae-code
```

### 2) 이 세팅 설치
```bash
# Linux / macOS / Git-Bash
git clone https://github.com/yazzang-homelab/free-gjc-starter.git
cd free-gjc-starter && bash install.sh
```
```powershell
# Windows
git clone https://github.com/yazzang-homelab/free-gjc-starter.git
cd free-gjc-starter ; .\install.ps1
```

### 3) 본인 키/로그인 채우기
```bash
# 무료 서브에이전트 키 (본인 발급)
export OPENROUTER_API_KEY=...   # https://openrouter.ai/keys
export GROQ_API_KEY=...         # https://console.groq.com/keys
```
```powershell
setx OPENROUTER_API_KEY "본인키"
setx GROQ_API_KEY "본인키"
```
메인 Gemini 로그인:
```bash
free-gjc            # 실행 후 아래 중 하나
#   /login google-antigravity    ← Google AI 구독이 있으면
#   /login google-gemini-cli     ← 무료로 쓰려면 (구글 계정 로그인)
```

무료 Gemini(`google-gemini-cli`)로 쓰려면 `~/.gjc-free/agent/config.yml`의
`default` 한 줄만 바꾸세요:
```yaml
  default: google-gemini-cli/gemini-2.5-pro
```

---

## 확인
```bash
free-gjc config get modelRoles
free-gjc -p --no-session "누구니?"
```

## 사용
```bash
free-gjc            # 대화형
free-gjc "리액트 버튼 컴포넌트 만들어줘"
```

---

## 자주 묻는 것

- **모델 이름이 안 먹혀요.** 무료 모델 슬러그는 자주 바뀝니다. OpenRouter는
  <https://openrouter.ai/models?q=free>, Groq는 <https://console.groq.com/docs/models>
  에서 유효한 id를 확인해 `models.yml` / `config.yml`에 바꿔 넣으세요.
- **내 키가 남에게 새나요?** 아니요. repo엔 키가 없고, 당신 키는 당신 PC 환경변수에만
  있습니다. 남과 공유할 땐 이 repo 링크(설치 명령)만 주면 됩니다 — 각자 자기 키를 넣습니다.
- **기존 gjc 설정이 망가지나요?** 아니요. 이 세팅은 `~/.gjc-free`에만 들어가고
  `bare gjc`(`~/.gjc`)는 그대로입니다.

## 파일 구성
| 경로 | 설치 위치 | 용도 |
| --- | --- | --- |
| `agent/config.yml` | `~/.gjc-free/agent/config.yml` | 역할 매핑 + 폴백 |
| `agent/models.yml` | `~/.gjc-free/agent/models.yml` | 무료 provider 정의 (키는 env 이름만) |
| `bin/free-gjc`, `.cmd`, `.ps1` | PATH | `free-gjc` 런처 (프로필 격리) |
| `install.sh` / `install.ps1` | — | 설치 스크립트 |

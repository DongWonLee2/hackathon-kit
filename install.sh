#!/usr/bin/env bash
# 당일 설치 — 작업공간 루트에서 실행:
#   bash /tmp/kit/install.sh          # 데이터 미션 기본 세트 (14개)
#   bash /tmp/kit/install.sh --web    # + 웹 산출물이 요구될 때 (impeccable, security, blast-radius 등 7개)
# 공개 저장소를 clone해 필요한 스킬 폴더만 .agents/skills/ 로 복사한다. git 외 의존성 없음.
set -u
WEB=0; [ "${1:-}" = "--web" ] && WEB=1
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="${TMPDIR:-/tmp}/hackathon-kit-src"; rm -rf "$SRC"; mkdir -p "$SRC" .agents/skills docs/agents
ok()   { printf '  [ok] %s\n' "$1"; }
warn() { printf '  [!!] %s\n' "$1"; }

sparse() {  # sparse(repo, dest, paths...) — 부분 clone, 실패하면 전체 clone
  local repo=$1 dest=$2; shift 2
  if git clone -q --depth 1 --filter=blob:none --sparse "https://github.com/$repo" "$dest" 2>/dev/null \
     && git -C "$dest" sparse-checkout set "$@" 2>/dev/null; then return 0; fi
  rm -rf "$dest"; git clone -q --depth 1 "https://github.com/$repo" "$dest"
}
take() { local s; for s in "$@"; do rm -rf ".agents/skills/$(basename "$s")"; cp -r "$s" .agents/skills/; done; }

echo "0/5 AGENTS.md"
if [ -f AGENTS.md ]; then warn "AGENTS.md가 이미 있어 덮어쓰지 않음 (수동 병합)"; else cp "$HERE/AGENTS.md" . && ok "복사"; fi

echo "1/5 mattpocock/skills — 설계·구현 흐름"
if git clone -q --depth 1 https://github.com/mattpocock/skills "$SRC/mp" 2>/dev/null; then
  E="$SRC/mp/skills/engineering"; P="$SRC/mp/skills/productivity"
  take "$P/grilling" "$E/domain-modeling" "$E/grill-with-docs" "$E/to-spec" "$E/implement" "$E/tdd" "$E/code-review" "$E/diagnosing-bugs"
  [ $WEB = 1 ] && take "$E/codebase-design"
  cp "$E/setup-matt-pocock-skills/issue-tracker-local.md" docs/agents/issue-tracker.md
  cp "$E/setup-matt-pocock-skills/domain.md" docs/agents/domain.md
  ok "8개 + docs/agents 시드 (local markdown tracker)"
else warn "실패"; fi

echo "2/5 backnotprop/pstack — 결정 로그·숫자 검증·보고서 문장"
if git clone -q --depth 1 https://github.com/backnotprop/pstack "$SRC/ps" 2>/dev/null; then
  S="$SRC/ps/skills"
  take "$S/show-me-your-work" "$S/principle-explain-the-number" "$S/technical-writing" "$S/unslop"
  [ $WEB = 1 ] && take "$S/blast-radius" "$S/create-verification-skill" "$S/typescript-best-practices"
  ok "4개"
else warn "실패"; fi

echo "3/5 obra/superpowers — 완료 전 검증"
if sparse obra/superpowers "$SRC/sp" skills/verification-before-completion 2>/dev/null; then
  take "$SRC/sp/skills/verification-before-completion"; ok "1개"
else warn "실패"; fi

echo "4/5 openai/skills — 노트북 템플릿 (+ 웹이면 보안 점검)"
if sparse openai/skills "$SRC/oa" skills/.curated/jupyter-notebook skills/.curated/security-best-practices 2>/dev/null; then
  take "$SRC/oa/skills/.curated/jupyter-notebook"
  [ $WEB = 1 ] && take "$SRC/oa/skills/.curated/security-best-practices"
  ok "1개"
else warn "실패"; fi

if [ $WEB = 1 ]; then
  echo "5/5 [--web] vercel-labs/agent-skills, pbakaus/impeccable"
  if sparse vercel-labs/agent-skills "$SRC/vc" skills/react-best-practices 2>/dev/null; then
    rm -rf .agents/skills/vercel-react-best-practices
    cp -r "$SRC/vc/skills/react-best-practices" .agents/skills/vercel-react-best-practices; ok "react"
  else warn "vercel 실패"; fi
  if sparse pbakaus/impeccable "$SRC/imp" .agents/skills/impeccable 2>/dev/null; then
    take "$SRC/imp/.agents/skills/impeccable"; ok "impeccable (런처 바이너리는 첫 실행 때 받음; 막히면 스킬 자체 폴백)"
  else warn "impeccable 실패"; fi
else
  echo "5/5 웹 스킬은 건너뜀 (필요하면 다시: bash $0 --web)"
fi

rm -rf "$SRC"
touch .gitignore
for p in .agents/ .scratch/; do grep -qxF "$p" .gitignore || echo "$p" >> .gitignore; done
mkdir -p figures

echo; echo "설치된 스킬 ($(ls -1 .agents/skills | wc -l | tr -d ' ')개):"; ls -1 .agents/skills | sed 's/^/  /'
echo; echo "다음: Codex를 (재)시작 → /skills 로 확인 → \$show-me-your-work 로 시작"

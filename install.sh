#!/usr/bin/env bash
# 당일 설치 — 작업공간 루트에서 실행. 네트워크는 이 저장소 clone 한 번이면 끝.
#   git clone --depth 1 https://github.com/DongWonLee2/hackathon-kit /tmp/kit && bash /tmp/kit/install.sh
#   bash /tmp/kit/install.sh --web     # 웹 산출물(대시보드·서버)이 요구될 때 7개 추가
# 스킬은 이 저장소에 들어 있다 (skills/, skills-web/). 출처와 원본 커밋은 VENDORED.md.
set -u
WEB=0; [ "${1:-}" = "--web" ] && WEB=1
HERE="$(cd "$(dirname "$0")" && pwd)"
ok()   { printf '  [ok] %s\n' "$1"; }
warn() { printf '  [!!] %s\n' "$1"; }

mkdir -p .agents/skills docs/agents figures

echo "1/3 AGENTS.md"
if [ -f AGENTS.md ]; then warn "AGENTS.md가 이미 있어 덮어쓰지 않음. 수동 병합: diff AGENTS.md $HERE/AGENTS.md"
else cp "$HERE/AGENTS.md" . && ok "복사"; fi

echo "2/3 스킬 → .agents/skills/"
n=0
for d in "$HERE"/skills/*/; do s=$(basename "$d"); rm -rf ".agents/skills/$s"; cp -r "$d" ".agents/skills/$s"; n=$((n+1)); done
ok "기본 $n개"
if [ $WEB = 1 ]; then
  m=0
  for d in "$HERE"/skills-web/*/; do s=$(basename "$d"); rm -rf ".agents/skills/$s"; cp -r "$d" ".agents/skills/$s"; m=$((m+1)); done
  ok "--web $m개 (impeccable 런처 바이너리는 첫 실행 때 받음; 막히면 스킬 자체 폴백)"
else
  echo "  웹 스킬은 건너뜀. 필요하면: bash $0 --web"
fi

echo "3/3 Matt Pocock 설정 시드 (대화형 setup 생략)"
cp "$HERE/seed/docs-agents/issue-tracker.md" docs/agents/issue-tracker.md
cp "$HERE/seed/docs-agents/domain.md" docs/agents/domain.md
ok "docs/agents/issue-tracker.md (local markdown), domain.md"

touch .gitignore
for p in .agents/ .scratch/; do grep -qxF "$p" .gitignore || echo "$p" >> .gitignore; done

echo; echo "설치된 스킬 ($(ls -1 .agents/skills | wc -l | tr -d ' ')개):"; ls -1 .agents/skills | sed 's/^/  /'
echo; echo "다음: Codex를 (재)시작 → /skills 로 확인 → \$show-me-your-work 로 시작"

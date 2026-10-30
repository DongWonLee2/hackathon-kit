#!/usr/bin/env bash
# 당일 설치 — 작업공간 루트에서 실행. 기본 세트는 이 저장소 clone 한 번이면 끝(네트워크 추가 없음).
#   git clone --depth 1 https://github.com/DongWonLee2/hackathon-kit /tmp/kit && bash /tmp/kit/install.sh
#   bash /tmp/kit/install.sh --web      # 대시보드·서버가 요구될 때 (skills-web/ 7개)
#   bash /tmp/kit/install.sh --report   # 문서 산출물(docx/pptx/xlsx)·구조 그림이 요구될 때 (diagram-design + Anthropic 문서 스킬 3개, 후자는 네트워크 필요)
#   플래그는 같이 써도 된다. 출처와 원본 커밋은 VENDORED.md.
set -u
WEB=0; REPORT=0
for a in "$@"; do case $a in --web) WEB=1;; --report) REPORT=1;; --all) WEB=1; REPORT=1;; esac; done
HERE="$(cd "$(dirname "$0")" && pwd)"
ok()   { printf '  [ok] %s\n' "$1"; }
warn() { printf '  [!!] %s\n' "$1"; }
copyset() { local n=0 d s; for d in "$1"/*/; do s=$(basename "$d"); rm -rf ".agents/skills/$s"; cp -r "$d" ".agents/skills/$s"; n=$((n+1)); done; echo $n; }

mkdir -p .agents/skills docs/agents figures

echo "1/3 AGENTS.md"
if [ -f AGENTS.md ]; then warn "AGENTS.md가 이미 있어 덮어쓰지 않음. 수동 병합: diff AGENTS.md $HERE/AGENTS.md"
else cp "$HERE/AGENTS.md" . && ok "복사"; fi

echo "2/3 스킬 → .agents/skills/"
ok "기본 $(copyset "$HERE/skills")개"
if [ $WEB = 1 ]; then ok "--web $(copyset "$HERE/skills-web")개 (impeccable 런처 바이너리는 첫 실행 때 받음; 막히면 스킬 자체 폴백)"; fi
if [ $REPORT = 1 ]; then
  ok "--report diagram-design (SVG/HTML 출력. PNG 변환은 Playwright 필요)"
  copyset "$HERE/skills-report" >/dev/null
  # Anthropic 문서 스킬은 라이선스(All rights reserved)상 재배포하지 않고 설치 시점에 원본에서 받는다
  T="${TMPDIR:-/tmp}/anthropic-skills-src"; rm -rf "$T"
  if git clone -q --depth 1 --filter=blob:none --sparse https://github.com/anthropics/skills "$T" 2>/dev/null \
     && git -C "$T" sparse-checkout set skills/docx skills/pptx skills/xlsx 2>/dev/null; then
    for s in docx pptx xlsx; do rm -rf ".agents/skills/$s"; cp -r "$T/skills/$s" ".agents/skills/$s"; done
    ok "--report docx, pptx, xlsx (anthropics/skills에서 받음). 의존성: node 패키지 docx·pptxgenjs, python openpyxl, 변환엔 soffice·pandoc"
  else warn "anthropics/skills clone 실패 — 문서는 python-docx/openpyxl 같은 라이브러리로 직접 만든다"; fi
  rm -rf "$T"
fi

echo "3/3 Matt Pocock 설정 시드 (대화형 setup 생략)"
cp "$HERE/seed/docs-agents/issue-tracker.md" docs/agents/issue-tracker.md
cp "$HERE/seed/docs-agents/domain.md" docs/agents/domain.md
ok "docs/agents/issue-tracker.md (local markdown), domain.md"

touch .gitignore
for p in .agents/ .scratch/; do grep -qxF "$p" .gitignore || echo "$p" >> .gitignore; done

echo; echo "설치된 스킬 ($(ls -1 .agents/skills | wc -l | tr -d ' ')개):"; ls -1 .agents/skills | sed 's/^/  /'
echo; echo "다음: Codex를 (재)시작 → /skills 로 확인 → \$show-me-your-work 로 시작"

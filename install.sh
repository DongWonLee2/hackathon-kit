#!/usr/bin/env bash
# 당일 설치. 작업공간 루트에서 실행. 기본 세트는 이 저장소 clone 한 번이면 끝(추가 네트워크 없음).
#   git clone --depth 1 https://github.com/DongWonLee2/hackathon-kit /tmp/kit && bash /tmp/kit/install.sh
#   bash /tmp/kit/install.sh --report   # 산출물이 docx/pptx/xlsx일 때 (anthropics/skills에서 받음, 네트워크 필요)
# 출처와 원본 커밋은 VENDORED.md. 이전 구성은 태그 v1.
set -u
REPORT=0
for a in "$@"; do case $a in
  --report|--all) REPORT=1;;
  --web) printf '  [!!] --web 세트는 v1 이후 뺐다. 웹 결과물은 AGENTS.md의 "웹 결과물이 요구될 때만"을 따른다.\n';;
  *) printf '  [!!] 모르는 옵션 %s 무시\n' "$a";;
esac; done
HERE="$(cd "$(dirname "$0")" && pwd)"
MARK='<!-- hackathon-kit:begin -->'
ok()   { printf '  [ok] %s\n' "$1"; }
warn() { printf '  [!!] %s\n' "$1"; }

mkdir -p .agents/skills figures

echo "1/3 AGENTS.md"
if [ ! -f AGENTS.md ]; then
  { echo "$MARK"; cat "$HERE/AGENTS.md"; } > AGENTS.md && ok "복사"
elif grep -qF "$MARK" AGENTS.md; then
  warn "이미 들어 있어 건너뜀"
else
  { printf '\n\n%s\n' "$MARK"; cat "$HERE/AGENTS.md"; } >> AGENTS.md && ok "기존 AGENTS.md 끝에 덧붙임 (과제 쪽 지시가 위에 남는다)"
fi

echo "2/3 스킬 → .agents/skills/"
n=0
for d in "$HERE"/skills/*/; do s=$(basename "$d"); rm -rf ".agents/skills/$s"; cp -r "$d" ".agents/skills/$s"; n=$((n+1)); done
ok "기본 ${n}개"
if [ $REPORT = 1 ]; then
  # Anthropic 문서 스킬은 라이선스(All rights reserved)상 재배포하지 않고 설치 시점에 원본에서 받는다
  T="${TMPDIR:-/tmp}/anthropic-skills-src"; rm -rf "$T"
  if git clone -q --depth 1 --filter=blob:none --sparse https://github.com/anthropics/skills "$T" 2>/dev/null \
     && git -C "$T" sparse-checkout set skills/docx skills/pptx skills/xlsx 2>/dev/null; then
    for s in docx pptx xlsx; do rm -rf ".agents/skills/$s"; cp -r "$T/skills/$s" ".agents/skills/$s"; done
    ok "--report docx, pptx, xlsx (anthropics/skills). 의존성: node 패키지 docx, pptxgenjs, python openpyxl, 변환엔 soffice, pandoc"
  else warn "anthropics/skills clone 실패. 문서는 python-docx, python-pptx, openpyxl로 직접 만든다"; fi
  rm -rf "$T"
fi

echo "3/3 .gitignore"
touch .gitignore
grep -qxF ".agents/" .gitignore || echo ".agents/" >> .gitignore
ok ".agents/만 제외. SPEC.md와 decisions.tsv는 커밋 대상"

echo; echo "설치된 스킬 ($(ls -1 .agents/skills | wc -l | tr -d ' ')개):"; ls -1 .agents/skills | sed 's/^/  /'
echo; echo "다음: Codex를 (재)시작 → /skills 로 확인 → \$show-me-your-work 로 시작"

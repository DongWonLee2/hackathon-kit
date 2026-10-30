# AGENTS.md — 작업 규약 (데이터 활용 AI 문제 해결 미션)

목표: 180분 안에 **결론이 두괄식으로 적힌 보고서(REPORT.md)**, **한 명령으로 재현되는 코드**, **그래프(figures/)**, 그리고 **결정 기록(decisions.tsv, docs/adr/)** 을 제출한다. 모델의 정교함보다 질문 정의, 데이터 품질 처리, 가설 검증의 논리, 결론의 근거, 한계 인식이 평가된다.
설계는 Matt Pocock의 grill → spec, 기록은 pstack의 결정 로그, 숫자 검증은 explain-the-number, 보고서는 technical-writing → unslop. 스킬은 `.agents/skills/`에 있다.

## Agent skills

### Issue tracker
Local markdown. 스펙과 이슈는 `.scratch/<feature>/`에 파일로 둔다. See `docs/agents/issue-tracker.md`.

### Domain docs
Single-context. `GLOSSARY.md`와 `docs/adr/`. See `docs/agents/domain.md`.

## 진행 방식
- 이 문서의 흐름을 **에이전트가 끌고 간다.** 사용자가 "다음", "진행해", "다음 가설"이라고 하면 현재 경과 시간에 맞는 다음 단계를 수행한다. 단계에 적힌 스킬은 설명이 맞으면 알아서 쓴다(tdd, code-review, diagnosing-bugs, verification-before-completion, jupyter-notebook).
- 아래 스킬은 사람이 `$`로 불러야만 실행된다(제작자가 암시적 호출을 막아 둠). 그 단계에 오면 **멈추고 "지금 `$to-spec`을 칠 차례입니다"처럼 알려준다**: `$show-me-your-work` `$grill-with-docs` `$to-spec` `$implement` `$principle-explain-the-number` `$technical-writing` `$unslop`.
- 결정 지점에서는 멈춘다: 질문 목록을 낸 뒤, grilling 라운드마다, 스펙을 쓴 뒤, 범위를 줄이려 할 때, 가설이 기각돼 방향을 바꿀 때. 사용자의 답 없이 스스로 결정하지 않는다. 결정은 사용자의 것이고 그 기록이 평가된다.
- 단계가 끝나면 세 줄 보고(바뀐 파일 / 실행 명령과 결과 / 불확실한 점)와 함께 "다음 단계: …"를 한 줄 덧붙인다.

## 흐름 (경과 분 기준)
- 0–10   `$show-me-your-work`로 `decisions.tsv`를 연다. README와 자료 설명을 한 번만 읽고 요구사항 표(필수/선택/상태)와 질문 목록(영향 순 3~5개, 기본 가정 포함)을 만든다. 사용자가 업무 담당자 에이전트에게 묻는다. 답을 기다리지 말고 기본 가정으로 진행한다.
- 10–30  `$grill-with-docs` — 2라운드 안에 끝낸다. 결정은 `docs/adr/`, 용어는 `GLOSSARY.md`. 그다음 `$to-spec` → `.scratch/<feature>/spec.md`. 데이터 미션의 스펙은 아래 "스펙에 반드시 있어야 하는 것"을 따른다.
- 30–60  기반 슬라이스: 데이터 로드 → 정제(규칙은 스펙대로, 코드로만) → 기준 지표 1개 → 그래프 1장 `figures/`에 저장 → 커밋. 정제·지표 계산 함수에는 `$tdd`로 작은 테스트를 둔다. 기준 지표 하나는 **두 번째 방법으로 교차 확인**한다 (pandas로 낸 값을 csv 모듈·awk·SQL 중 하나로 다시).
- 60–120 가설 루프. 가설 하나마다: 분해(설비·시간·조건별) → 그래프 → **교란 요인 확인(층화)** → decisions.tsv 한 줄 → 커밋. A가 원인처럼 보이면 A와 섞여 있는 B를 고정하고 다시 본다. 가설이 기각되면 그것도 기록한다. 기각된 가설은 보고서의 근거다.
- 120–140 `$principle-explain-the-number` — 보고서에 들어갈 숫자마다 n, 기간, 정제 기준, 그 숫자가 다른 것을 재고 있을 가능성을 적는다. `$code-review <첫 커밋>`(스펙 축 중심). 재현 명령을 **처음부터 한 번에** 실행해 figures/가 다시 생기는지 확인한다.
- 140–160 `REPORT.md`를 `$technical-writing` 기준으로 쓰고 `$unslop`으로 다듬는다. README에 `## 제출물 안내`(실행 명령·구조·핵심 결정(ADR 번호)·검증·한계) 추가. `COLLABORATION.md`(decisions.tsv·ADR·git log 기반: AI 제안 중 채택/변경/거부, 사용자 직접 판단, 외부 자료·스킬 출처, 막힌 지점). 전체 재실행, 커밋.
- 160    제출 시작.

## 스펙에 반드시 있어야 하는 것 (to-spec 결과를 이 기준으로 점검)
1. 분석 질문 한 문장과 그 답으로 **누가 무슨 결정**을 하는지
2. 지표 정의: 무엇을 무엇 대비 어떻게 잰다 (기준 기간, 목표치, 집계 단위)
3. 가설 목록과 각 가설을 **기각할 수 있는 검증 방법**. 담당자나 현장이 믿는 가설도 포함
4. 데이터 정제 규칙: 중복, 결측, 이상치를 어떻게 하고 왜. 버린 건수는 보고서에 적는다
5. 산출물: REPORT.md 구조, 그래프 목록, 재현 명령
6. 범위 밖: 안 하기로 한 것과 이유

## 규칙
- 보고서 첫 절은 **결론 10줄 이내**: 무엇이, 언제부터, 어디서, 왜, 그래서 무엇을 먼저 할지. 그다음에 근거.
- 숫자는 혼자 쓰지 않는다. 항상 n, 기간, 정제 후 기준을 같이 쓴다. 비교는 같은 기준끼리.
- 그래프: 제목에 결론을 쓴다("EQ-007 수율, 9/15 이후 하락"). 축 단위 명시. 설비별·시간별 같은 읽기 쉬운 형태 우선. PNG로 `figures/`에 저장하고 보고서에서 파일명으로 참조.
- 재현: `python run.py` 또는 `make report` 한 명령으로 정제부터 그래프까지 다시 만들어진다. 난수는 seed 고정. **원본 데이터 파일은 수정하지 않는다.** 정제는 코드 안에서만.
- 모델은 선택이다. 쓴다면 단순 기준선(평균·규칙) 먼저, 그다음 해석 가능한 것. 학습·평가 데이터 분리와 시간 누수(미래 정보로 과거 예측)를 확인하고 decisions.tsv에 적는다. 모델 없이 원인과 조치가 설명되면 모델을 넣지 않는다.
- 상관을 원인이라 쓰지 않는다. 원인이라 쓰려면 교란 요인을 하나 이상 확인한 기록이 있어야 한다.
- "완료"는 `$verification-before-completion`을 거친 뒤에만. 실행하지 않은 것은 완료라 하지 않는다. 보고는 바뀐 파일 / 실행 명령과 결과 / 불확실한 점 세 항목.
- 오류·이상한 결과는 `$diagnosing-bugs`. 같은 수정을 3번 반복하지 않는다. 넘으면 멈추고 선택지를 보고한다.
- 결정이 스펙·ADR과 달라지면 ADR을 추가하고(번호 이어서) decisions.tsv에 한 줄. 이 두 기록이 후속 서술형의 근거다.
- git: 슬라이스마다 커밋. `git push`는 시도하지 않는다.
- 외부 자료를 참고하거나 차용하면 출처와 범위를 decisions.tsv와 COLLABORATION.md에 적는다. 결과물을 통째로 가져오지 않는다.
- 토큰: 데이터 파일 전체를 출력하지 않는다(`head`, `describe`, 집계만). 저장소를 반복 탐색하지 않는다. 스킬 본문은 그 단계에서만 읽는다.
- 시간은 `date +%H:%M`으로 확인해 적는다.

## 웹 산출물이 요구될 때만
- 서버는 `0.0.0.0` 바인딩, 포트는 환경변수 우선·기본값 명시, 시작 시 포트 출력. 서버 터미널은 닫지 않는다.
- React UI면 Astryx(`npm i @astryxdesign/core @astryxdesign/theme-neutral @stylexjs/stylex && npm i -D @astryxdesign/cli` → `npx @astryxdesign/cli template --list`), 아니면 `$impeccable shape`. 이 스킬들은 `install.sh --web`으로 설치된다.

# hackathon-kit

Codex 응시 환경에서 3시간 과제를 **스펙 주도(SDD)** 로 개발하기 위한 공개 스킬 묶음. 직접 만든 스킬은 없다. 사람이 오래 써서 검증된 공개 스킬을 **수정 없이 복사**해 두었고(출처·원본 커밋은 [VENDORED.md](VENDORED.md)), 직접 쓴 건 **어떤 스킬을 언제 쓰는지**(AGENTS.md)와 **설치 스크립트**(install.sh)뿐이다.

선택 기준: 알려진 개발자나 회사가 실제로 쓰려고 만들었고 공개 저장소에서 유지되는 것 → Codex 지원이 명시된 것 → clone과 복사만으로 설치되는 것 → 3시간 과제에 맞는 무게.

```
hackathon-kit/
├── AGENTS.md       # 작업공간 루트에 복사. 데이터 미션 기준 흐름·시간 배분·규칙. Matt Pocock 스킬이 읽는 "Agent skills" 블록 포함
├── install.sh      # skills/ → .agents/skills/ 복사. --web 이면 skills-web/ 도. 네트워크 불필요
├── skills/         # 기본 14개 (320KB)
├── skills-web/     # 웹 산출물이 요구될 때 7개 (3.3MB, impeccable이 대부분)
├── seed/           # Matt Pocock 스킬이 읽는 설정 파일 (docs/agents/)
├── licenses/       # 원본 저장소 라이선스 사본
├── VENDORED.md     # 폴더별 출처·원본 경로·커밋·라이선스
└── README.md
```

2차 예선은 **데이터를 활용한 AI 문제 해결 미션**이라, 기본 세트는 분석·보고서용이고 웹 스킬은 `--web` 옵션으로 분리했다.

## 사용법

### 시험 당일 (응시 환경 터미널에서)

```bash
# 1. 작업공간 루트에서 — clone 한 번, 설치는 복사뿐
git clone --depth 1 https://github.com/DongWonLee2/hackathon-kit /tmp/kit && bash /tmp/kit/install.sh

# 2. Codex 시작 (이미 켜져 있었다면 껐다 켠다. 스킬은 시작할 때 스캔된다)
codex
```

`install.sh`가 하는 일은 복사 네 가지뿐이다. 스크립트를 못 돌리거나 직접 하고 싶으면 이 한 줄이 같은 결과다:

```bash
cp /tmp/kit/AGENTS.md . && mkdir -p .agents/skills docs/agents figures && cp -r /tmp/kit/skills/. .agents/skills/ && cp /tmp/kit/seed/docs-agents/* docs/agents/ && printf '.agents/\n.scratch/\n' >> .gitignore
```

웹 산출물이 요구되면 `cp -r /tmp/kit/skills-web/. .agents/skills/` 한 줄 더. 빠뜨리면 안 되는 건 `AGENTS.md`(흐름), `docs/agents/`(Matt Pocock 스킬이 읽는 설정. 없으면 `to-spec`이 setup을 먼저 돌리라며 멈춘다), `.gitignore`(안 넣으면 스킬 폴더가 제출물에 커밋된다).

Codex 안에서 `/model`로 권장 모델을 고르고 `/skills`에 14개가 보이면 준비 끝. 그다음은 순서대로 친다.

```
$show-me-your-work 시작. decisions.tsv를 루트에 만들어.
README와 자료 설명을 한 번만 읽고 요구사항 표와 질문 목록(영향 큰 순 3~5개, 기본 가정 포함)을 만들어줘. 코드는 아직 쓰지 마.
```
질문을 업무 담당자 에이전트에게 → 답을 Codex에 붙여넣기 → `담당자 답변이야. 요구사항 표를 갱신하고 결정된 건 decisions.tsv에.`
```
$grill-with-docs <미션 한 줄>          # 라운드마다 권장 답이 붙는다. 맞으면 "1 yes, 2 yes". 2라운드까지만
$to-spec                               # .scratch/<이름>/spec.md — 아래 "스펙에 있어야 하는 것" 6항목 확인
$implement .scratch/<이름>/spec.md 첫 항목만: 로드, 정제, 기준 지표 1개, 그래프 1장, 커밋. 지표 하나는 다른 방법으로 교차 확인
...가설마다 분해 → 그래프 → 교란 요인 확인 → 기록 → 커밋...
$principle-explain-the-number          # 보고서에 들어갈 숫자마다
$code-review <첫 커밋 SHA>
REPORT.md 써줘 ($technical-writing 기준, $unslop으로 다듬기), README 제출물 안내, COLLABORATION.md, 전체 재실행, 커밋
```

웹 산출물(대시보드·서버)이 요구되면 `bash /tmp/kit/install.sh --web`을 한 번 더 돌린다.

### 스킬 부르는 법

- `$이름` 으로 직접 부른다. `/skills`를 치면 목록이 뜨고, `$`만 쳐도 자동완성된다.
- 설명(description)이 맞으면 Codex가 알아서 고르기도 한다. "다음 슬라이스 해줘"처럼 말해도 된다.
- 스킬 본문은 호출될 때만 읽힌다. 세션 시작 시 로드되는 건 이름과 설명뿐이라 상시 토큰 비용은 작다.

### 집에서 연습할 때

`hackathon-practice` 폴더의 `scripts/new-run.sh rounds/<과제>`가 이 킷을 회차 폴더에 깔아 준다. Claude 데스크톱 새 채팅에 `stakeholder.md`를 붙여넣어 업무 담당자로 쓰고, Orca에서 회차 폴더를 열어 Codex를 띄운다. 자세한 건 그 폴더의 README와 `시험지침.html`.

### clone이 안 될 때

아래 [폴백](#폴백)의 9줄 AGENTS.md를 손으로 친다. 스킬 없이도 같은 흐름이 나온다.

## 스킬 한눈에 보기

기본 세트 14개. 시간 순서대로.

| 단계 | 스킬 | 역할 | 언제 |
|---|---|---|---|
| 기록 | `show-me-your-work` | 결정 한 건당 한 줄 TSV 로그(시각/단계/결정/이유/증거/결과). 서술형 답의 재료 | 0분에 열고 끝까지 |
| 설계 | `grilling` | 설계 트리를 라운드로 묻는다. 질문마다 권장 답이 붙어 "yes"로 진행 | 10분 |
| 설계 | `domain-modeling` | 굳어진 용어는 GLOSSARY.md, 결정은 docs/adr/에 그 자리에서 기록 | grilling 중 자동 |
| 설계 | `grill-with-docs` | 위 둘을 한 번에 부르는 진입점. 실제로 치는 건 이거 | 10분 |
| 설계 | `to-spec` | 대화를 스펙으로 합성 → `.scratch/<이름>/spec.md`. 데이터 미션은 지표 정의·가설·기각 방법·정제 규칙이 들어가야 함 | 25분 |
| 구현 | `implement` | 스펙을 받아 tdd로 구현, 테스트, code-review 호출, 커밋 | 30분 |
| 구현 | `tdd` | 빨강→초록. 정제·지표 계산 함수에만. 탐색 코드엔 안 건다 | implement 안에서 |
| 구현 | `diagnosing-bugs` | 가설→재현→확인. 같은 수정을 두 번 하게 될 때 | 필요 시 |
| 구현 | `jupyter-notebook` | 산출물이 .ipynb일 때 experiment 템플릿으로 구조 잡기 | 스크립트 제출이면 안 씀 |
| 검증 | `verification-before-completion` | "완료"는 명령을 지금 실행하고 출력을 본 뒤에만 | 슬라이스마다 |
| 검증 | `principle-explain-the-number` | 숫자마다 n·기간·노이즈 폭, 다른 걸 재고 있을 가능성 배제 | 120분, 보고서 숫자마다 |
| 검증 | `code-review` | 첫 커밋 이후 diff를 표준·스펙 두 축으로 병렬 리뷰 | 125분 |
| 보고서 | `technical-writing` | 한 번에 읽히는 문장. 일 안 하는 단어 삭제, 짧은 일상어, 구체적 수치 | 140분, REPORT.md |
| 보고서 | `unslop` | AI 티 제거(-ing 수식, "~뿐 아니라", 3개 묶기, 과장 형용사) | 150분, 마지막 손질 |

`--web` 추가 7개 (대시보드·서버가 요구될 때만):

| 스킬 | 역할 |
|---|---|
| `impeccable` | React가 아닌 UI의 shape(계획) → 편집 규칙 → polish(마감) |
| `security-best-practices` | 언어·프레임워크별 보안 참조로 큰 취약점만 1회 점검 (python/js/ts/go) |
| `blast-radius` | diff 밖에서 깨질 것을 찾고 안전 근거를 코드 실행으로 증명 |
| `create-verification-skill` | 앱을 사용자처럼 구동하는 `verify-<app>` 스킬 생성 |
| `codebase-design` | 모듈·인터페이스·심 어휘집. tdd가 심을 정할 때 참조 |
| `vercel-react-best-practices` | React/Next 성능 규칙 |
| `typescript-best-practices` | .ts/.tsx 편집 규칙 |

각 스킬의 자세한 동작은 아래 [스킬별 역할](#스킬별-역할).

## 누가 만든 것을 쓰나

| 출처 | 만든 사람 | 기본 세트 | `--web` 추가 |
|---|---|---|---|
| [mattpocock/skills](https://github.com/mattpocock/skills) | Matt Pocock (Total TypeScript, AI Hero). Codex 공식 플러그인 마켓에도 있음 | grilling, domain-modeling, grill-with-docs, to-spec, implement, tdd, code-review, diagnosing-bugs | codebase-design |
| [backnotprop/pstack](https://github.com/backnotprop/pstack) | poteto (backnotprop). Cursor 공식 플러그인 저장소와 동기화 | show-me-your-work, principle-explain-the-number, technical-writing, unslop | blast-radius, create-verification-skill, typescript-best-practices |
| [obra/superpowers](https://github.com/obra/superpowers) | Jesse Vincent (obra). Codex 공식 플러그인 마켓에 있음 | verification-before-completion | |
| [openai/skills](https://github.com/openai/skills) | OpenAI 공식 큐레이션 | jupyter-notebook | security-best-practices |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | Vercel 엔지니어링 | | vercel-react-best-practices |
| [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | Paul Bakaus (jQuery UI 창시자, ex-Google) | | impeccable |
| [facebook/astryx](https://github.com/facebook/astryx) | Meta. 사내 13,000+ 앱이 8년간 쓴 디자인 시스템 | | npm 라이브러리 (스킬 아님) |

데이터 분석(EDA) 전용 스킬은 알려진 개발자나 회사가 만든 것이 없어서 넣지 않았다. 커뮤니티 "data-analyst" 류는 출처 검증이 안 된다. 그 대신 분석 규율(지표 정의, 가설 기각, 교란 요인 확인, 숫자 보고 규칙, 재현)은 AGENTS.md에 규칙으로 적었고, 숫자 검증은 pstack의 explain-the-number, 보고서 문장은 technical-writing과 unslop이 맡는다.

## 스킬별 역할

### 설계 — Matt Pocock

**grilling** — 계획을 설계 트리로 보고, 지금 답할 수 있는 질문(프론티어)을 한 라운드에 번호 붙여 묻는다. 질문마다 권장 답이 붙어 있어 "yes"만 쳐도 진행된다. 사실 확인은 서브에이전트가 하고, 결정만 사용자에게 묻는다. 프론티어가 비면 끝.
- 언제: 10분, 요구사항을 읽은 직후
- 산출물: 합의된 설계 (문서는 domain-modeling이 씀)

**domain-modeling** — grilling 중에 굳어지는 용어는 `GLOSSARY.md`에, 결정은 `docs/adr/NNNN-*.md`에 그 자리에서 적는다. 파일은 쓸 게 생길 때만 만든다.
- 산출물: GLOSSARY.md, docs/adr/
- 서술형 "왜 이 구조냐"의 1차 근거

**grill-with-docs** — 위 둘을 묶어 부르는 한 줄짜리 스킬. 실제로는 `$grill-with-docs`만 치면 된다.

**to-spec** — 지금까지의 대화를 인터뷰 없이 스펙으로 합성해 `.scratch/<feature>/spec.md`에 쓴다. 문제 / 해법 / 유저 스토리 / 구현 결정 / 테스트 결정(어느 심에서 테스트할지) / 범위 밖. 파일 경로와 코드는 안 넣는다.
- 언제: grilling이 끝난 직후, 35분 전
- 산출물: spec.md. implement가 이 파일을 읽는다

**codebase-design** — "깊은 모듈"(작은 인터페이스 뒤에 많은 동작) 어휘집. 모듈·인터페이스·심·어댑터를 같은 말로 부르게 한다. tdd가 심을 정할 때 참조한다. 직접 부를 일은 드물다.

### 구현 — Matt Pocock

**implement** — 스펙을 받아 합의된 심에서 tdd로 구현하고, 타입체크와 단일 테스트를 자주, 전체 테스트를 마지막에 돌리고, 끝나면 code-review를 부르고 커밋한다.
- 언제: 35분, `$implement .scratch/<feature>/spec.md`

**tdd** — 빨강 → 초록. 테스트는 공개 인터페이스(심)에서만, 사전에 합의한 심에서만. 구현에 결합된 테스트, 동어반복 테스트, 테스트 먼저 다 쓰고 구현 나중에 하는 수평 슬라이스를 금지한다. 리팩터는 루프 밖(code-review 단계).
- 산출물: 심마다 한 테스트씩, 커밋 단위의 증거

**diagnosing-bugs** — 버그·실패 테스트의 진단 루프. 추측 수정 대신 가설 → 재현 → 확인. 같은 수정을 반복할 때 부른다.

**code-review** — 고정점(첫 커밋) 이후 diff를 두 축으로 리뷰한다. 표준(이 저장소의 규칙을 따르나)과 스펙(spec.md가 요구한 걸 구현했나). 두 리뷰어가 서브에이전트로 병렬로 돈다.
- 언제: 120분, `$code-review <첫 커밋 SHA>`

### 증거 — pstack, superpowers

**show-me-your-work** — 결정 한 건당 한 줄짜리 TSV 로그(`decisions.tsv`: 시각 / 단계 / 결정 / 이유 / 증거 경로 / 결과). 리뷰어가 결과를 믿게 하는 흔적.
- 언제: 0분에 열고 끝까지 유지. 후속 서술형 6문항의 답이 여기서 나온다

**verification-before-completion** — "완료·고침·통과"를 말하기 전에 그 명령을 지금 실행하고 출력을 읽는다. 이전 실행, "될 것이다"는 증거가 아니다. 3k짜리 철칙 한 장.

**principle-explain-the-number** — 숫자를 보고하기 전에: 이 숫자가 어떤 결정을 바꾸는지, 노이즈 폭은 얼마인지, 다른 것을 재고 있을 가능성(오류·누락·캐시·선택 편향)을 하나씩 배제했는지, 근거(n·기간·정제 기준)를 숫자 옆에 두었는지. 분석 결과의 모든 수치에 적용한다.
- 언제: 120분, 보고서에 들어갈 숫자마다

**blast-radius** *(--web)* — diff 밖에서 깨질 수 있는 것을 찾고, 안전하다고 믿는 근거 한 가지를 글이 아니라 실제 코드 실행으로 증명한다. 호출자 나열은 일이 아니다.
- 언제: 공유 모듈·스키마·설정을 건드린 뒤, 제출 전

**create-verification-skill** *(--web)* — 이 앱을 사용자처럼 구동하는 프로젝트 전용 스킬 `verify-<app>`을 생성한다. 실행 명령, 준비 신호, 조작 레시피(실제 셀렉터·엔드포인트), 증거 캡처 방법을 저장소에서 읽어 채운다. 그 뒤 `$verify-<app>`을 실행하면 기능 증명이 남는다.
- 언제: 구현이 120분 전에 끝났을 때만. 시간이 없으면 테스트 + curl + 플랫폼 Browser 미리보기로 대신한다

### 보고서 — pstack, OpenAI

**technical-writing** — 피곤한 사람이 한 번에 읽는 문장. 일 안 하는 단어 삭제, 짧은 일상어, 문장 길이 섞기, 구체적 수치. REPORT.md 초안을 이 기준으로 쓴다.
- 언제: 140분

**unslop** — AI 티 나는 표현 제거(-ing 수식, "~일 뿐 아니라", 3개 묶기, 모호한 출처, 과장 형용사). REPORT.md와 COLLABORATION.md 마지막 손질.
- 언제: 150분

**jupyter-notebook** — 산출물이 `.ipynb`일 때 템플릿으로 구조 잡기(experiment 모드). 스크립트 제출이면 안 쓴다.

### 웹 산출물이 요구될 때만 (`install.sh --web`)

**security-best-practices** — 언어·프레임워크별 보안 참조를 읽고 큰 취약점만 짚음. **vercel-react-best-practices**, **typescript-best-practices** — 해당 스택일 때 편집 참고. **impeccable** — React가 아닌 UI의 shape → 편집 → polish. **codebase-design** — 모듈 경계 어휘. **blast-radius**, **create-verification-skill** — 위 증거 절 참고.

### UI — Meta Astryx (스킬이 아니라 라이브러리)

React 19 디자인 시스템. 150+ 접근성 컴포넌트, 7개 테마, 페이지 템플릿(테이블 페이지, 상세 페이지, 폼 위저드), 그리고 에이전트가 읽도록 만든 CLI. 직접 스타일을 짜는 대신 컴포넌트와 토큰을 조립하므로 업무용 화면이 빨리, 일관되게 나온다.

```bash
npm i @astryxdesign/core @astryxdesign/theme-neutral @stylexjs/stylex
npm i -D @astryxdesign/cli
npx @astryxdesign/cli init                       # 프로젝트에 설정
npx @astryxdesign/cli template --list            # 페이지 템플릿 목록
npx @astryxdesign/cli build <template>           # 템플릿에서 페이지 시작
npx @astryxdesign/cli search <keyword>           # 컴포넌트·훅·문서·템플릿 통합 검색
npx @astryxdesign/cli component Button --dense   # 컴포넌트 문서 (토큰 절약 모드)
```

주의: 항상 `npx @astryxdesign/cli`로 부른다. 설치 전에 `npx astryx`를 치면 다른 패키지가 잡힌다. npm 레지스트리 접근이 되는지 사전 체험에서 확인한다.

## 흐름 (데이터 미션)

| 경과 | 하는 일 | 치는 것 |
|---|---|---|
| 0–10분 | 결정 로그 시작, README 정독, 요구사항 표·질문 목록 → 담당자 | `bash /tmp/kit/install.sh` → `$show-me-your-work` |
| 10–30분 | 설계 인터뷰(2라운드) → ADR·용어집 → 분석 스펙(지표 정의·가설·기각 방법·정제 규칙) | `$grill-with-docs <미션 한 줄>` → `$to-spec` |
| 30–60분 | 로드·정제·기준 지표·그래프 1장, 교차 확인, 커밋 | `$implement spec.md 첫 항목만` |
| 60–120분 | 가설 루프: 분해 → 그래프 → 교란 요인 확인 → 기록 → 커밋 | 가설마다 한 번씩 |
| 120–140분 | 숫자 검증, 스펙 대조 리뷰, 재현 명령 처음부터 실행 | `$principle-explain-the-number` → `$code-review <첫 커밋>` |
| 140–160분 | REPORT.md, README 제출물 안내, COLLABORATION.md, 전체 재실행, 커밋 | `$technical-writing` → `$unslop` |
| 160분 | 제출 시작 | |

## 스펙에 있어야 하는 것 (to-spec 결과 점검)

1. 분석 질문 한 문장과 그 답으로 **누가 무슨 결정**을 하는지
2. **지표 정의**: 무엇을 무엇 대비 어떻게 잰다 (기준 기간, 목표치, 집계 단위)
3. **가설 목록**과 각 가설을 **기각할 수 있는 검증 방법**. 현장이 믿는 가설 포함
4. **정제 규칙**: 중복·결측·이상치를 어떻게, 왜. 버린 건수는 보고서에
5. **산출물**: REPORT.md 구조, 그래프 목록, 재현 명령
6. **범위 밖**: 안 하기로 한 것과 이유

## 당일 설치

```bash
git clone --depth 1 https://github.com/DongWonLee2/hackathon-kit /tmp/kit && bash /tmp/kit/install.sh
```

스크립트가 하는 일: AGENTS.md 복사 → `skills/` 14개(`--web`이면 `skills-web/` 7개 더)를 `.agents/skills/`로 복사 → Matt Pocock 스킬의 설정 파일(`docs/agents/issue-tracker.md`, `domain.md`)을 시드로 깔아 대화형 `setup-matt-pocock-skills`를 건너뜀 → `.gitignore`에 `.agents/` `.scratch/` 추가, `figures/` 생성. 네트워크는 clone 한 번뿐이고 설치는 1초.

스킬을 저장소에 직접 넣은 이유: 당일 상류 저장소 5개의 네트워크·경로 변경에 기대지 않기 위해서다. 연습에서 테스트한 비트와 시험장에서 받는 비트가 같다. 출처는 VENDORED.md.

설치 후 Codex를 (재)시작하고 `/skills`에 14개(--web이면 21개)가 보이는지 확인한다. 호출은 `$이름`.

## 사전 체험(15분)에서 확인할 것

1. `git clone` 공개 저장소 1개 — 되면 install.sh 그대로, 안 되면 아래 폴백
2. `bash /tmp/kit/install.sh` 후 `/skills`에 14개
3. `$grilling` 한 라운드 — 질문 형식과 권장 답이 나오는지 (2분 안에 끊는다)
4. `python3 -c "import pandas, matplotlib"` — 없으면 `pip install pandas matplotlib` 걸리는 시간. 그래프 PNG를 플랫폼 Browser 미리보기로 볼 수 있는지
5. `which node python3 go java`와 버전 — 당일 스택 선택 근거

## 폴백

| 상황 | 대응 |
|---|---|
| git clone 불가 | 아래 9줄을 AGENTS.md로 직접 친다. 그다음 "AGENTS.md 읽고 질문 목록부터 시작해" |
| pandas 없음 | `pip install pandas matplotlib` 2분 안에 안 되면 표준 라이브러리(`csv`, `statistics`)로. 그래프는 표로 대신하고 한계에 적는다 |
| npm 레지스트리 불가 (--web) | Astryx 대신 `$impeccable shape`로 UI 계획, 순수 CSS |
| impeccable 런처 다운로드 실패 | 스킬 본문의 폴백대로 PRODUCT.md/DESIGN.md를 직접 읽고 계속 |
| 서브에이전트 도구 없음 | grilling은 사실 조사를 직접 하고, code-review는 두 축을 순서대로 한 세션에서 한다 |

clone이 막혔을 때 손으로 칠 AGENTS.md:

```
# AGENTS.md
- 순서: 질문 라운드(권장 답 포함)로 설계 합의 → 결정은 docs/adr/, 용어는 GLOSSARY.md
  → .scratch/<feature>/spec.md(질문·지표 정의·가설과 기각 방법·정제 규칙·산출물·범위 밖)
  → 정제·기준 지표·그래프 → 가설마다 교란 요인 확인 → REPORT.md(결론 10줄 먼저) → COLLABORATION.md.
- 결정마다 decisions.tsv 한 줄: 시각 / 단계 / 결정 / 이유 / 증거 / 결과.
- 숫자는 n·기간·정제 기준과 함께. 상관을 원인이라 쓰려면 교란 요인 확인 기록이 있어야 한다.
- 재현은 한 명령(python run.py). seed 고정. 원본 데이터 수정 금지, 정제는 코드로만.
- 실행하지 않은 것은 완료라 하지 않는다. 보고는 바뀐 파일 / 실행 결과 / 불확실한 점.
- 슬라이스마다 커밋, push 금지. 데이터 전체 출력 금지, 저장소 반복 탐색 금지.
- 애매한 요구사항은 추측하지 말고 질문 목록을 만들어 준다.
- 외부 자료 차용 시 출처·범위 기록.
```

## 뺀 것과 이유

- **google/elephant-goldfish-model**: Google이 쓰는 SDD 플러그인이고 Codex를 지원하지만, Matt Pocock의 grill → spec과 자리가 겹친다. 이미 익숙한 쪽이 시험장에서 빠르다. 리뷰 단계가 서브에이전트를 여럿 띄워 토큰도 많이 쓴다.
- **mattpocock의 wayfinder, triage, to-tickets, research, pr, ask-matt, retro**: 멀티세션·이슈 트래커·PR·웹 조사용. 3시간 단일 세션엔 필요 없다. ask-matt 라우터 역할은 AGENTS.md가 한다.
- **pstack의 architect, arena, interrogate, swarm, poteto-mode**: 병렬 워크트리와 다중 후보를 돌리는 구조라 무겁다. 아이디어만 가볍게 담은 blast-radius와 show-me-your-work를 가져왔다.
- **superpowers의 brainstorming, writing-plans, executing-plans, test-driven-development, systematic-debugging**: Matt Pocock의 grilling, to-spec, implement, tdd, diagnosing-bugs와 1:1로 겹친다. using-superpowers는 모든 응답 전에 스킬 호출을 강제해 토큰을 쓴다.
- **github/spec-kit**: `uv`·PyPI가 필요하고 풀코스가 3시간에 무겁다.
- **Nutlope/hallmark, elayadesign/ai-design-skills**: 랜딩 페이지 전용 성격. 업무용 화면엔 Astryx가 맞다.
- **cloudflare/security-audit-skill, ponytail-audit**: 저장소 전체 감사용. 새로 만드는 과제엔 과하다.
- **배포·Figma·Notion·Linear 계열**: 시험에서 쓸 일이 없다.

## 주의

- 이 저장소에는 과제 관련 코드·힌트·보일러플레이트가 없어야 한다. 공개 스킬의 복사본과 절차뿐. 넣기 시작하면 "결과물 통째 대체"나 "비공개 스킬 반입"으로 읽힐 수 있다.
- 공개 스킬과 Astryx를 가져다 쓴 사실은 COLLABORATION.md 외부 자료 항목에 적는다 (AGENTS.md에 규칙으로 들어 있다). 숨기지 않는 쪽이 안전하다.
- 스킬 본문은 호출될 때만 읽힌다. 세션 시작 시 로드되는 건 14개의 이름·설명뿐이라 상시 비용은 작다.

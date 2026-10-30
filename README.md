# hackathon-kit

Codex 응시 환경용 공개 스킬 묶음. 데이터 활용 AI 문제 해결 미션 기준. 직접 만든 스킬은 없고 공개 스킬을 수정 없이 복사해 뒀다(출처, 커밋, 라이선스: [VENDORED.md](VENDORED.md)). 직접 쓴 건 AGENTS.md, install.sh, 이 문서.

이전 구성(스킬 15개와 웹 세트, to-spec과 implement 흐름)은 브랜치 `v1`에 있다. 그쪽으로 가려면 아래 clone에 `-b v1`을 붙인다.

## 설치

작업공간 루트에서.

```bash
git clone --depth 1 https://github.com/DongWonLee2/hackathon-kit /tmp/kit && bash /tmp/kit/install.sh
```

스크립트 없이 직접 하려면:

```bash
cat /tmp/kit/AGENTS.md >> AGENTS.md && mkdir -p .agents/skills figures && cp -r /tmp/kit/skills/. .agents/skills/ && echo '.agents/' >> .gitignore
```

과제 폴더에 AGENTS.md가 이미 있으면 키트 규칙은 그 끝에 붙는다. 과제 쪽 지시가 위에 남는다.

산출물이 docx, pptx, xlsx로 요구되면 `bash /tmp/kit/install.sh --report`로 Anthropic 문서 스킬 3개를 받는다(네트워크 필요).

Codex를 (재)시작하고 `/skills`에 8개(`--report`면 11개)가 보이면 끝.

## 사용

AGENTS.md가 규칙을 들고 있고 단계는 내가 정한다. Codex는 단계마다 세 줄로 보고하고 다음 단계를 제안한 뒤 기다린다.

기록되는 것은 대화, 터미널, git log, 테스트 결과, 토큰 사용량이다. 그래서 지시 한 줄에도 무엇을, 왜, 예상 결과를 담는다. 고칠 때는 "다시 해"가 아니라 왜 틀렸는지 한 줄. 담당자 답은 `담당자 확인:`을 붙여 내 가정과 구분한다.

| 경과 | 치는 것 | 그 전에 내가 할 것 |
|---|---|---|
| 0분 | `$show-me-your-work 시작. decisions.tsv를 루트에 만들고 커밋 대상으로 둬.` | |
| 2분 | `README 한 번 읽고 요구사항 표(필수/선택/상태)와 과제 유형을 정해. 그다음 데이터 파일마다 행 수, 열과 타입, 결측, 범주 상위 값, 날짜 범위, 키 중복을 스크립트 하나로 요약해. 전체 출력 금지.` | 요구사항 표에서 README가 정한 함수, 경로, 출력 형식 확인 |
| 6분 | `요약에서 이상한 값을 골라 담당자 질문 3~5개 만들어. 질문마다 대상(열, 코드값, 기간), 기본 가정, 답에 따라 바뀌는 숫자를 붙여.` | 질문을 담당자에게. 답은 `담당자 확인:`을 붙여 Codex에 |
| 12분 | `$grilling <미션 한 줄>` | 라운드마다 `1 yes, 2 yes` 또는 이유 한 줄. 2라운드까지 |
| 20분 | `SPEC.md를 AGENTS.md 6항목과 용어 절로 써. 커밋.` | 6항목이 다 있는지 확인 |
| 25분 | `SPEC.md 첫 항목만: README가 정한 함수(없으면 run.py), 정제, 감사표, 기준 지표 1개, 그래프 1장. 지표 하나는 다른 방법으로 교차 확인. 테스트 돌리고 커밋.` | 생성된 코드 읽기 |
| 60–115분 | 분석형: `가설 2 <그룹>별 차이. 예상: <그룹 A>가 <지표>에서 <크기> 이상 낮을 것. <조건 B>에 <그룹 A> 비중이 높으니 <그룹>을 고정하고 <조건 B> 효과를 다시 봐.` 판정형: `요구사항 R3 <규칙>. 예상 <n>건. 테스트 먼저, 구현, 커밋.` | 한 줄에 무엇, 왜, 예상 결과 |
| 115분 | `REPORT.md 결론 10줄 초안만 써. 숫자마다 n, 기간, 정제 기준.` | |
| 120분 | `데이터 리뷰 돌려. AGENTS.md 절차대로, 이 대화 없이 데이터, REPORT.md, run.py만 넘겨.` | 지적을 고치거나 한계에 적기 |
| 135분 | `기능 동결. REPORT.md 마무리하고 $unslop으로 다듬어. README 제출물 안내, COLLABORATION.md, 전체 재실행, 커밋.` | 필수 파일, 저장 상태 확인 |
| 150분 | `서술형 대비. AGENTS.md 절차대로 /tmp/qbank.md 써.` | 파일을 덮고 소리 내 답해 보기. 막힌 질문의 코드만 다시 읽기 |
| 160분 | 제출 | |

## 스킬 (8개)

| 스킬 | 역할 | 출처 |
|---|---|---|
| `show-me-your-work` | 결정 한 건당 TSV 한 줄(시각/단계/결정/이유/증거/결과). 서술형 답의 재료 | pstack |
| `grilling` | 설계 질문을 라운드로. 질문마다 권장 답이 붙어 "yes"로 진행 | Matt Pocock |
| `tdd` | 빨강 다음 초록. 정제, 지표, 판정 함수에만 | Matt Pocock |
| `diagnosing-bugs` | 가설, 재현, 확인. 같은 수정을 두 번 하게 될 때 | Matt Pocock |
| `verification-before-completion` | "완료"는 명령을 지금 실행하고 출력을 본 뒤에만 | superpowers |
| `unslop` | 보고서에서 AI 티 제거 | pstack |
| `handoff` | 세션이 무거워지면 인계 문서를 쓰고 새 세션으로. 명시 호출 | Matt Pocock |
| `jupyter-notebook` | 산출물이 .ipynb일 때 템플릿 | OpenAI |

`--report` 3개: `docx`, `pptx`, `xlsx`(Anthropic). 구조 그림은 Mermaid 코드블록으로 충분하다.

v1에서 뺀 것과 이유는 [VENDORED.md](VENDORED.md) 끝에 있다.

## 응시 전 확인

1. 위 clone 한 줄이 되는지. 안 되면 아래 폴백
2. `/skills`에 8개
3. `python3 -c "import pandas, matplotlib"`. 없으면 `pip install`에 걸리는 시간
4. `$grilling` 한 라운드가 나오고 멈추는지
5. 첫 커밋에 SPEC.md와 decisions.tsv가 들어가는지(`git show --stat HEAD`)
6. `/status`에서 토큰 사용량을 어디서 보는지

## 폴백

| 상황 | 대응 |
|---|---|
| clone 불가 | 아래 블록을 AGENTS.md로 직접 친다. 그다음 "AGENTS.md 읽고 요구사항 표와 데이터 요약부터" |
| pandas 없음 | `pip install pandas matplotlib`. 2분 넘으면 표준 라이브러리로, 그래프는 표로 대신하고 한계에 적는다 |
| grilling이 길어짐 | `남은 건 권장 답으로 확정하고 마무리해` |
| Codex가 멈춤 | 승인 프롬프트 확인. 없으면 `현재 상태와 다음 할 일 보고해` |
| 서버 소켓이 막힘 | 승인 한 번 주고 decisions.tsv에 기록 |
| 같은 수정 3회 | 멈춘다. 범위 축소를 ADR로, 한계 절에 |
| 서브에이전트 없음 | 데이터 리뷰를 같은 세션의 새 python 프로세스로 |

```
# AGENTS.md
- 과제 README와 담당자 답이 이 문서보다 우선. README의 함수, 경로, 파일명, 출력 형식을 그대로 쓴다.
- 함수는 인자로 받은 데이터만 쓴다. 0건, 전부 통과, NaN은 성공이 아니다.
- 단계는 사람이 정한다. 단계마다 바뀐 파일 / 실행 결과 / 불확실한 점 세 줄로 보고하고 기다린다.
- 순서: 데이터 요약 → 담당자 질문 → 설계 질문 라운드 → SPEC.md(질문, 지표 정의, 가설과 기각 방법, 정제 규칙, 산출물, 범위 밖, 용어)
  → 정제, 기준 지표, 그래프 → 가설마다 교란 요인 고정 → REPORT.md(결론 10줄 먼저) → COLLABORATION.md.
- 결정마다 decisions.tsv 한 줄: 시각 / 단계 / 결정 / 이유 / 증거 / 결과. decisions.tsv와 SPEC.md는 커밋한다.
- 숫자는 n, 기간, 정제 기준과 함께. 원인이라 쓰려면 교란 요인을 고정한 비교가 있어야 한다.
- 재현은 한 명령. seed 고정. 원본 데이터 수정 금지.
- 실행하지 않은 것은 완료라 하지 않는다. 슬라이스마다 커밋, push 금지. 서브에이전트는 데이터 리뷰 한 번만.
- 데이터 전체 출력 금지, 저장소 반복 탐색 금지. 외부 자료는 출처와 범위 기록.
```

## 주의

- 이 저장소에 과제 관련 코드나 힌트를 넣지 않는다. 공개 스킬 복사본과 절차뿐이어야 한다.
- 공개 스킬을 썼다는 사실은 COLLABORATION.md 외부 자료 항목에 적는다. AGENTS.md에 규칙으로 있다.

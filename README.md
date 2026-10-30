# hackathon-kit

Codex 응시 환경용 공개 스킬 묶음. 데이터 활용 AI 문제 해결 미션 기준. 직접 만든 스킬은 없고 공개 스킬을 수정 없이 복사해 뒀다 (출처·커밋·라이선스: [VENDORED.md](VENDORED.md)). 직접 쓴 건 AGENTS.md, install.sh, 이 문서.

## 설치

작업공간 루트에서. clone 한 번, 나머지는 복사.

```bash
git clone --depth 1 https://github.com/DongWonLee2/hackathon-kit /tmp/kit && bash /tmp/kit/install.sh
```

스크립트 없이 직접 하려면:

```bash
cp /tmp/kit/AGENTS.md . && mkdir -p .agents/skills docs/agents figures && cp -r /tmp/kit/skills/. .agents/skills/ && cp /tmp/kit/seed/docs-agents/* docs/agents/ && printf '.agents/\n.scratch/\n' >> .gitignore
```

웹 산출물(대시보드·서버)이 요구되면 `bash /tmp/kit/install.sh --web` 또는 `cp -r /tmp/kit/skills-web/. .agents/skills/`.

Codex를 (재)시작하고 `/skills`에 15개(--web이면 22개)가 보이면 끝.

## 사용

AGENTS.md가 흐름을 끌고 간다. 직접 쳐야 하는 건 관문 5개뿐이고, 사이사이는 보통 말로 간다. 제작자가 암시적 호출을 막아 둔 스킬이라서다.

평가는 AI 심사관이 코드·커밋·**채팅 로그**를 읽어서 한다. 그래서 관문 사이의 한 줄도 "다음"이 아니라 **무엇을, 왜, 예상 결과**를 담아 친다. 고칠 때도 "다시 해"가 아니라 왜 틀렸는지 한 줄. 채팅·코드·문서·커밋에서 같은 이름을 쓴다(GLOSSARY.md). 커밋 메시지에 왜를 한 줄. 담당자 답은 `담당자 확인:` 라벨을 붙여 내 가정과 구분한다.

| 경과 | 치는 것 | 그 전에 내가 할 것 |
|---|---|---|
| 0분 | `$show-me-your-work 시작. decisions.tsv를 루트에 만들어.` | |
| 2분 | `README 읽고 요구사항 표와 질문 목록(영향 큰 순 3~5개, 기본 가정 포함) 만들어줘. 코드는 아직.` | 질문을 담당자에게 → 답을 Codex에 |
| 10분 | `$grill-with-docs <미션 한 줄>` | 라운드마다 `1 yes, 2 yes` 또는 이유 한 줄. 2라운드까지 |
| 25분 | `$to-spec` | spec.md에 아래 6항목 있는지 확인 |
| 30분 | `$implement .scratch/<이름>/spec.md 첫 항목만: 로드, 정제, 기준 지표 1개, 그래프 1장, 커밋. 지표 하나는 다른 방법으로 교차 확인` | 생성된 코드 읽기 |
| 60–120분 | `가설 2 설비별 차이. 예상: EQ-007이 1%p 이상 낮을 것. 야간에 EQ-007 비중이 높으니 설비 고정하고 야간 효과 다시 봐.` | 가설마다 **무엇을·왜·예상 결과**를 한 줄에. 채팅 로그가 채점 대상이다 |
| 120분 | `$principle-explain-the-number` → `$code-review <첫 커밋 SHA>` | |
| 140분 | `REPORT.md 써줘. 결론 10줄 먼저. technical-writing 기준으로 쓰고 unslop으로 다듬어. README 제출물 안내, COLLABORATION.md, 전체 재실행, 커밋.` | 필수 파일·저장 상태 확인 |
| 160분 | 제출 | |

스펙 6항목: 분석 질문과 그 답으로 누가 무슨 결정을 하는지 / 지표 정의(기준 기간·목표치·단위) / 가설과 각각 기각하는 방법 / 정제 규칙(중복·결측·이상치) / 산출물(REPORT 구조·그래프·재현 명령) / 범위 밖.

## 스킬

기본 15개.

| 단계 | 스킬 | 역할 | 출처 |
|---|---|---|---|
| 기록 | `show-me-your-work` | 결정 한 건당 한 줄 TSV(시각/단계/결정/이유/증거/결과). 서술형 답의 재료 | pstack |
| 설계 | `grilling` | 설계 질문을 라운드로. 질문마다 권장 답이 붙어 "yes"로 진행 | Matt Pocock |
| 설계 | `domain-modeling` | 용어는 GLOSSARY.md, 결정은 docs/adr/에 그 자리에서 기록 | Matt Pocock |
| 설계 | `grill-with-docs` | 위 둘을 한 번에 부르는 진입점 | Matt Pocock |
| 설계 | `to-spec` | 대화를 스펙으로 합성 → `.scratch/<이름>/spec.md` | Matt Pocock |
| 구현 | `implement` | 스펙을 받아 tdd로 구현, 테스트, code-review, 커밋 | Matt Pocock |
| 구현 | `tdd` | 빨강→초록. 정제·지표 함수에만 | Matt Pocock |
| 구현 | `diagnosing-bugs` | 가설→재현→확인. 같은 수정을 두 번 하게 될 때 | Matt Pocock |
| 구현 | `handoff` | 세션이 무거워지면 인계 문서를 쓰고 새 세션으로. 명시 호출 | Matt Pocock |
| 구현 | `jupyter-notebook` | 산출물이 .ipynb일 때 템플릿 | OpenAI |
| 검증 | `verification-before-completion` | "완료"는 명령을 지금 실행하고 출력을 본 뒤에만 | superpowers |
| 검증 | `principle-explain-the-number` | 숫자마다 n·기간·노이즈, 다른 걸 재고 있을 가능성 배제 | pstack |
| 검증 | `code-review` | 첫 커밋 이후 diff를 표준·스펙 두 축으로 리뷰 | Matt Pocock |
| 보고서 | `technical-writing` | 한 번에 읽히는 문장. 군더더기 삭제, 구체적 수치 | pstack |
| 보고서 | `unslop` | AI 티 제거 | pstack |

`--web` 7개: `impeccable`(UI 계획·마감), `security-best-practices`(보안 점검), `blast-radius`(변경 영향 증명), `create-verification-skill`(앱 구동 검증 스킬 생성), `codebase-design`, `vercel-react-best-practices`, `typescript-best-practices`. React UI면 Meta [Astryx](https://github.com/facebook/astryx)를 npm으로 쓴다. 명령은 AGENTS.md 끝에.

출처: [mattpocock/skills](https://github.com/mattpocock/skills), [backnotprop/pstack](https://github.com/backnotprop/pstack), [obra/superpowers](https://github.com/obra/superpowers), [openai/skills](https://github.com/openai/skills), [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills), [pbakaus/impeccable](https://github.com/pbakaus/impeccable). 전부 MIT 또는 Apache 2.0.

## 사전 체험에서 확인

1. 위 clone 한 줄이 되는지. 안 되면 아래 폴백
2. `/skills`에 15개
3. `python3 -c "import pandas, matplotlib"`. 없으면 `pip install` 걸리는 시간
4. 그래프 PNG가 플랫폼 Browser 미리보기로 보이는지
5. `$grilling` 한 라운드 (2분 안에 끊기)

## 폴백

| 상황 | 대응 |
|---|---|
| clone 불가 | 아래 9줄을 AGENTS.md로 직접 친다. 그다음 "AGENTS.md 읽고 질문 목록부터" |
| pandas 없음 | `pip install pandas matplotlib`. 2분 넘으면 표준 라이브러리로, 그래프는 표로 대신하고 한계에 적는다 |
| grilling이 길어짐 | `남은 건 권장 답으로 확정하고 마무리해` |
| Codex가 멈춤 | 승인 프롬프트 확인 → 없으면 `현재 상태와 다음 할 일 보고해` |
| 같은 수정 3회 | 멈춘다. 범위 축소를 ADR로, 한계 절에 |
| 서브에이전트 없음 | grilling은 사실 조사를 직접, code-review는 두 축을 순서대로 |

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

## 주의

- 이 저장소에 과제 관련 코드·힌트를 넣지 않는다. 공개 스킬 복사본과 절차뿐이어야 한다.
- 공개 스킬을 썼다는 사실은 COLLABORATION.md 외부 자료 항목에 적는다. AGENTS.md에 규칙으로 있다.

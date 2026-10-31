# hackathon-kit

Codex 응시 환경용 공개 스킬 묶음. 데이터 분석, 판정 도구, 웹 서비스 과제를 모두 다룬다. 직접 만든 스킬은 없고 공개 스킬을 수정 없이 복사해 뒀다(출처, 커밋, 라이선스: [VENDORED.md](VENDORED.md)). 직접 쓴 건 AGENTS.md, install.sh, 이 문서.

이전 구성은 브랜치 `v1`에 있다. 그쪽으로 가려면 아래 clone에 `-b v1`을 붙인다.

## 설치

과제 폴더로 들어간 다음에 실행한다. 설치 스크립트가 지금 폴더에 파일을 깔기 때문이다.

```bash
git clone https://github.com/DongWonLee2/hackathon-kit /tmp/kit
bash /tmp/kit/install.sh
```

- 과제 뼈대가 React/Next.js나 TypeScript면 `--web`을 붙인다(스킬 2개 추가).
- 산출물이 docx, pptx, xlsx로 요구되면 `--report`를 붙인다(Anthropic 문서 스킬 3개, 네트워크 필요).
- 과제 폴더에 AGENTS.md가 이미 있으면 키트 규칙은 그 끝에 붙는다. 과제 쪽 지시가 위에 남는다.

Codex를 (재)시작하고 `/skills`에 10개가 보이면 끝.

스크립트 없이 직접 하려면:

```bash
cat /tmp/kit/AGENTS.md >> AGENTS.md && mkdir -p .agents/skills && cp -r /tmp/kit/skills/. .agents/skills/ && echo '.agents/' >> .gitignore
```

## 사용

AGENTS.md가 규칙을 들고 있고 단계는 내가 정한다. Codex는 단계마다 STATUS.md에 보고를 쓰고, 채팅에는 세 줄과 다음 단계 제안만 남긴 뒤 기다린다.

**진행 상황은 에디터에서 본다.** 터미널이 깨져도 아래 파일은 남는다.

| 파일 | 볼 것 |
|---|---|
| STATUS.md | 맨 위가 최신. 방금 무엇을 했고 무엇이 불확실한지, 담당자에게 물을 질문 |
| REQUIREMENTS.md | 요구사항마다 테스트와 상태(통과, 실패, 미구현, 임시 가정). 다 지켰는지는 여기서 판단 |
| ARCHITECTURE.md | 데이터와 상태가 흐르는 경로, 단계별 담당 모듈 |
| FAILURE_MODES.md | 이상한 입력, 동시 요청, 규칙 위반 같은 상황에서의 동작 |

기록되는 것은 대화, 터미널, git log, 테스트 결과, 토큰 사용량이다. 그래서 지시 한 줄에도 무엇을, 왜, 예상 결과를 담는다. 고칠 때는 "다시 해"가 아니라 왜 틀렸는지 한 줄. 담당자 답은 `담당자 확인:`을 붙여 내 가정과 구분한다. AI 제안을 받아들이거나 고치거나 버렸으면 그 이유를 바로 말해 둔다. 나중에 사람이 쓰는 회고 파일과 사후 질문의 재료가 된다.

| 경과 | 치는 것 | 내가 할 것 |
|---|---|---|
| 0분 | `$show-me-your-work 시작. decisions.tsv를 루트에 만들고 커밋 대상으로 둬.` | |
| 2분 | `README 한 번 읽고 과제 유형을 정해. 데이터 파일마다 행 수, 열과 타입, 결측, 범주 상위 값, 날짜 범위, 키 중복을 스크립트 하나로 요약해. 전체 출력 금지.` | README가 정한 함수, API, 출력 형식 확인 |
| 6분 | `요약과 README에서 애매한 것을 골라 담당자 질문 3~5개를 STATUS.md에 써. 질문마다 대상, 기본 가정, 답에 따라 바뀌는 것.` | STATUS.md에서 질문을 복사해 담당자에게. 답은 `담당자 확인:`을 붙여 Codex에 |
| 12분 | `$grilling <과제 한 줄>` | 라운드마다 `1 yes, 2 yes` 또는 이유 한 줄. 2라운드까지 |
| 20분 | `SPEC.md를 AGENTS.md 6항목과 용어 절로, REQUIREMENTS.md 첫 판도 써. 커밋.` | 요구사항이 README와 담당자 답을 다 덮는지 확인 |
| 25분 (웹) | `$impeccable shape <서비스 한 줄>. 시안 관문대로 mockups/에 화면별 HTML 시안, STATUS.md에 확인 목록.` | 개발용 브라우저로 시안 열기. 요구사항마다 화면 위치, 역할별 흐름, 오류 상태 확인 후 승인 |
| 40~120분 | 분석형: `가설 2 <그룹>별 차이. 예상: <그룹 A>가 <지표>에서 <크기> 이상 낮을 것. <조건 B>를 고정하고 다시 봐.` 판정형, 웹: `R03 <요구사항>. 예상 <결과>. 테스트 먼저, 구현, REQUIREMENTS.md 갱신, 커밋.` | `/diff`로 코드 읽기. REQUIREMENTS.md 상태 확인 |
| 120분 | `리뷰 돌려. AGENTS.md 절차대로 대화 기록 없이.` 웹이면 이어서 `$security-best-practices 인증, 세션, 입력 처리 코드` | 지적을 고치거나 한계에 적기 |
| 130분 | `기능 동결. 화면 있으면 $impeccable polish 한 번. 제출물 안내 쓰고 $unslop. 전체 테스트로 REQUIREMENTS.md 상태 맞추고 커밋.` | 필수 파일 확인 |
| 145분 | `사람이 쓰는 제출 파일 후보 장면을 AGENTS.md 형식대로 STATUS.md에 뽑아.` | 회고 파일은 내가 직접 쓴다 |
| 160분 | `서술형 대비. AGENTS.md 절차대로 /tmp/qbank.md 써.` | 파일을 덮고 소리 내 답해 보기 |
| 170분 | 제출 | |

## 회고 파일 쓰는 틀

README가 본인이 직접 쓰라고 한 파일은 장면 하나를 깊게 쓴다. 두 이야기를 섞지 않는다.

1. 상황: 무엇이 언제 어떻게 깨졌나
2. AI에게 물은 것
3. AI의 진단과 제안
4. 내 판단: 채택, 수정, 폐기 중 무엇을 했나
5. 근거: 왜 그렇게 판단했나. 비교한 대안
6. 확인 방법과 남은 위험

## 사후 질문 대비

제출 뒤 서술형은 AI 없이 내 결과물을 내 말로 설명하는 시간이다. 아래 네 가지를 설명할 수 있으면 된다. 작업 중에 쌓은 파일이 그대로 답이 된다.

| 질문 갈래 | 답이 있는 곳 |
|---|---|
| 데이터와 상태가 어떻게 흐르고 각 단계는 어느 모듈 책임인가 | ARCHITECTURE.md |
| 실제로 구현해 검증한 규칙과 임시 가정, 다른 사람이 확인하는 경로 | REQUIREMENTS.md |
| 설정 변경, 잘못된 입력, 동시 요청, 규칙 위반에서의 동작과 가장 약한 곳 | FAILURE_MODES.md |
| AI 제안을 받아들이고 고치고 버린 장면과 근거 | decisions.tsv의 `ai` 행 |

## 스킬 (10개)

| 스킬 | 역할 | 출처 |
|---|---|---|
| `show-me-your-work` | 결정 한 건당 TSV 한 줄(시각/단계/결정/이유/증거/결과) | pstack |
| `grilling` | 설계 질문을 라운드로. 질문마다 권장 답이 붙어 "yes"로 진행 | Matt Pocock |
| `impeccable` | 화면 시안(`shape`), 점검(`critique`, `audit`), 마감(`polish`) | Paul Bakaus |
| `security-best-practices` | 인증, 세션, 입력 처리 점검. python, js/ts, go | OpenAI |
| `tdd` | 빨강 다음 초록. 요구사항 ID를 테스트 이름에 | Matt Pocock |
| `diagnosing-bugs` | 가설, 재현, 확인. 같은 수정을 두 번 하게 될 때 | Matt Pocock |
| `verification-before-completion` | "완료"는 명령을 지금 실행하고 출력을 본 뒤에만 | superpowers |
| `unslop` | 보고서와 안내 문서에서 AI 티 제거 | pstack |
| `handoff` | 세션이 무거워지면 인계 문서를 쓰고 새 세션으로. 명시 호출 | Matt Pocock |
| `jupyter-notebook` | 산출물이 .ipynb일 때 템플릿 | OpenAI |

`--web` 2개: `vercel-react-best-practices`, `typescript-best-practices`. `--report` 3개: `docx`, `pptx`, `xlsx`(Anthropic).

## 응시 전 확인

1. clone 한 줄이 되는지. 안 되면 아래 폴백
2. `/skills`에 10개
3. `$impeccable shape 테스트 화면` 한 번. 엔진을 못 받으면 "Context loading did not run"이라고 말하고 대체 절차로 가는지
4. 에디터에서 STATUS.md가 열리는지
5. `/status`에서 토큰 사용량을 어디서 보는지

## 터미널이 깨질 때

- Ctrl+L로 화면을 다시 그린다. 대화는 그대로다.
- 내용은 에디터에서 STATUS.md로 본다.
- Codex의 마지막 답은 `/copy`로 복사할 수 있다.

## 폴백

| 상황 | 대응 |
|---|---|
| clone 불가 | 아래 블록을 AGENTS.md로 직접 친다. 그다음 "AGENTS.md 읽고 과제 유형과 데이터 요약부터" |
| impeccable 엔진을 못 받음 | 스킬의 대체 절차로 진행. 시안 관문은 그대로 |
| grilling이 길어짐 | `남은 건 권장 답으로 확정하고 마무리해` |
| Codex가 멈춤 | 승인 프롬프트 확인. 없으면 `현재 상태와 다음 할 일 STATUS.md에 쓰고 보고해` |
| 서버 소켓이 막힘 | 승인 한 번 주고 decisions.tsv에 기록 |
| 보안 설정 때문에 막힘 | 원인부터 확인. 낮춰야 하면 개발 설정에만, 이유와 대안과 위험을 decisions.tsv에 |
| 같은 수정 3회 | 멈춘다. 범위 축소를 ADR로, 한계 절에 |

```
# AGENTS.md
- 과제 README와 담당자 답이 우선. README의 함수, API, 파일명, 출력 형식을 그대로 쓴다.
- 단계는 사람이 정한다. 단계마다 STATUS.md 맨 위에 보고(바뀐 파일, 실행 결과, 불확실한 점, 다음 단계)하고 기다린다.
- REQUIREMENTS.md: 요구사항마다 출처, 완료 조건, 테스트 이름, 상태. 기능 하나 끝날 때마다 갱신.
- 웹이면 구현 전에 화면별 HTML 시안을 내고 승인받는다. 보안 설정은 전역으로 낮추지 않는다.
- 결정마다 decisions.tsv 한 줄. AI 제안을 채택, 수정, 폐기했으면 그 근거도. 함께 커밋한다.
- 0건, 전부 통과, NaN은 성공이 아니다. 실행하지 않은 것은 완료라 하지 않는다.
- 단위마다 커밋, push 금지. 서브에이전트는 독립인 일에만 2개까지, 커밋은 메인만.
- 본인이 쓰라고 한 제출 파일은 쓰지 않고 장면 후보만 뽑는다.
```

## 주의

- 이 저장소에 과제 관련 코드나 힌트를 넣지 않는다. 공개 스킬 복사본과 일반 절차뿐이어야 한다.
- 공개 스킬을 썼다는 사실은 제출물의 외부 자료 항목에 적는다.

# 포함된 스킬의 출처

이 저장소의 `skills/`는 아래 공개 저장소에서 **수정 없이 복사**한 것이다. 복사한 날짜는 2026-10-30, 원본 커밋은 표의 SHA. 각 폴더는 원본 저장소의 같은 이름 폴더와 파일 단위로 동일하다. 라이선스 전문은 `licenses/`와 각 스킬 폴더의 `LICENSE.txt`(있는 경우).

직접 만든 스킬은 없다. 이 저장소에서 직접 쓴 파일은 `AGENTS.md`, `install.sh`, `README.md`, 이 문서뿐이다. 스킬 본문과 시험 조건이 부딪치는 부분(show-me-your-work의 교차 모델 리뷰, 로그를 git 밖에 두는 기본값)은 스킬을 고치지 않고 AGENTS.md 규칙으로 덮는다.

| 폴더 | 원본 저장소 | 원본 경로 | 커밋 | 라이선스 | 만든 사람 |
|---|---|---|---|---|---|
| skills/grilling | [mattpocock/skills](https://github.com/mattpocock/skills) | skills/productivity/grilling | 59db609 | MIT | Matt Pocock |
| skills/tdd | mattpocock/skills | skills/engineering/tdd | 59db609 | MIT | Matt Pocock |
| skills/diagnosing-bugs | mattpocock/skills | skills/engineering/diagnosing-bugs | 59db609 | MIT | Matt Pocock |
| skills/handoff | mattpocock/skills | skills/productivity/handoff | 59db609 | MIT | Matt Pocock |
| skills/show-me-your-work | [backnotprop/pstack](https://github.com/backnotprop/pstack) | skills/show-me-your-work | 25abb38 | MIT | poteto |
| skills/unslop | backnotprop/pstack | skills/unslop | 25abb38 | MIT | poteto |
| skills/verification-before-completion | [obra/superpowers](https://github.com/obra/superpowers) | skills/verification-before-completion | 2ce8aa1 | MIT | Jesse Vincent |
| skills/jupyter-notebook | [openai/skills](https://github.com/openai/skills) | skills/.curated/jupyter-notebook | 49f948f | 폴더 내 LICENSE.txt (Apache 2.0) | OpenAI |

## 복사하지 않고 설치 시점에 받는 것

`install.sh --report`는 [anthropics/skills](https://github.com/anthropics/skills)의 `docx`, `pptx`, `xlsx`를 설치할 때 원본에서 받는다. 이 세 스킬의 LICENSE.txt가 "All rights reserved"라 재배포하지 않는다. 사용은 공개 저장소의 공개 스킬을 그대로 쓰는 것이다.

## 왜 복사해 두나

시험장에서 clone 한 번으로 끝내기 위해서다. 설치 시점에 상류 저장소를 다시 받으면 그 시각의 네트워크와 경로 변경에 의존하게 된다. 복사본은 연습에서 테스트한 비트와 당일 받는 비트가 같다.

## v1에서 뺀 것

브랜치 `v1`에 그대로 있다.

| 뺀 것 | 이유 |
|---|---|
| to-spec, implement, code-review, grill-with-docs, domain-modeling, seed/docs-agents | 스펙은 AGENTS.md 6항목으로 직접 쓰고, 설계 질문은 grilling으로 한다. implement와 code-review는 부를 때마다 리뷰 서브에이전트 둘을 띄워 토큰이 많이 든다. grill-with-docs와 implement는 Codex에 없는 "Skill tool"을 부른다. |
| principle-explain-the-number | 성능 벤치마크용이고 키트에 없는 benchmark-checklist를 부른다. 데이터 숫자 점검은 AGENTS.md 규칙과 데이터 리뷰가 한다. |
| technical-writing | unslop과 같은 보고서를 두 번 다듬는다. |
| skills-web 7개(impeccable 등) | 화면 꾸밈은 채점 항목에 없고 프레임워크 설정이 180분 안에서 위험하다. 웹 결과물은 정적 HTML 한 장으로 만든다. |
| skills-report/diagram-design | 5.8MB. 구조 그림은 Mermaid로 충분하다. |

## 다시 가져오기

원본을 최신으로 갱신하려면 각 저장소를 clone해 위 경로를 그대로 덮어쓰고 이 표의 커밋을 갱신한다.

# 포함된 스킬의 출처

이 저장소의 `skills/`와 `skills-web/`는 아래 공개 저장소에서 **수정 없이 복사**한 것이다. 복사한 날짜는 2026-10-30, 원본 커밋은 표의 SHA. 각 폴더는 원본 저장소의 같은 이름 폴더와 파일 단위로 동일하다. 라이선스 전문은 `licenses/`와 각 스킬 폴더의 `LICENSE.txt`(있는 경우).

직접 만든 스킬은 없다. 이 저장소에서 직접 쓴 파일은 `AGENTS.md`, `install.sh`, `README.md`, 이 문서뿐이다.

| 폴더 | 원본 저장소 | 원본 경로 | 커밋 | 라이선스 | 만든 사람 |
|---|---|---|---|---|---|
| skills/grilling | [mattpocock/skills](https://github.com/mattpocock/skills) | skills/productivity/grilling | 59db609 | MIT | Matt Pocock |
| skills/domain-modeling | mattpocock/skills | skills/engineering/domain-modeling | 59db609 | MIT | Matt Pocock |
| skills/grill-with-docs | mattpocock/skills | skills/engineering/grill-with-docs | 59db609 | MIT | Matt Pocock |
| skills/to-spec | mattpocock/skills | skills/engineering/to-spec | 59db609 | MIT | Matt Pocock |
| skills/implement | mattpocock/skills | skills/engineering/implement | 59db609 | MIT | Matt Pocock |
| skills/tdd | mattpocock/skills | skills/engineering/tdd | 59db609 | MIT | Matt Pocock |
| skills/code-review | mattpocock/skills | skills/engineering/code-review | 59db609 | MIT | Matt Pocock |
| skills/diagnosing-bugs | mattpocock/skills | skills/engineering/diagnosing-bugs | 59db609 | MIT | Matt Pocock |
| skills/handoff | mattpocock/skills | skills/productivity/handoff | 59db609 | MIT | Matt Pocock |
| seed/docs-agents/* | mattpocock/skills | skills/engineering/setup-matt-pocock-skills/{issue-tracker-local.md, domain.md} | 59db609 | MIT | Matt Pocock |
| skills/show-me-your-work | [backnotprop/pstack](https://github.com/backnotprop/pstack) | skills/show-me-your-work | 25abb38 | MIT | poteto |
| skills/principle-explain-the-number | backnotprop/pstack | skills/principle-explain-the-number | 25abb38 | MIT | poteto |
| skills/technical-writing | backnotprop/pstack | skills/technical-writing | 25abb38 | MIT | poteto |
| skills/unslop | backnotprop/pstack | skills/unslop | 25abb38 | MIT | poteto |
| skills/verification-before-completion | [obra/superpowers](https://github.com/obra/superpowers) | skills/verification-before-completion | 2ce8aa1 | MIT | Jesse Vincent |
| skills/jupyter-notebook | [openai/skills](https://github.com/openai/skills) | skills/.curated/jupyter-notebook | 49f948f | 폴더 내 LICENSE.txt (Apache 2.0) | OpenAI |
| skills-web/codebase-design | mattpocock/skills | skills/engineering/codebase-design | 59db609 | MIT | Matt Pocock |
| skills-web/blast-radius | backnotprop/pstack | skills/blast-radius | 25abb38 | MIT | poteto |
| skills-web/create-verification-skill | backnotprop/pstack | skills/create-verification-skill | 25abb38 | MIT | poteto |
| skills-web/typescript-best-practices | backnotprop/pstack | skills/typescript-best-practices | 25abb38 | MIT | poteto |
| skills-web/security-best-practices | openai/skills | skills/.curated/security-best-practices | 49f948f | 폴더 내 LICENSE.txt (Apache 2.0) | OpenAI |
| skills-web/vercel-react-best-practices | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | skills/react-best-practices (폴더명만 프런트매터 name에 맞춤) | 1a2c79d | MIT | Vercel |
| skills-report/diagram-design | [cathrynlavery/diagram-design](https://github.com/cathrynlavery/diagram-design) | skills/diagram-design | 0cf73c3 | MIT | Cathryn Lavery |
| skills-web/impeccable | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | .agents/skills/impeccable | 5e745ac | Apache 2.0 | Paul Bakaus |

## 복사하지 않고 설치 시점에 받는 것

`install.sh --report`는 [anthropics/skills](https://github.com/anthropics/skills)의 `docx`, `pptx`, `xlsx`를 설치할 때 원본에서 받는다. 이 세 스킬의 LICENSE.txt가 "All rights reserved"라 재배포하지 않는다. 사용은 공개 저장소의 공개 스킬을 그대로 쓰는 것이다.

## 왜 복사해 두나

시험장에서 clone 한 번으로 끝내기 위해서다. 설치 시점에 상류 저장소 5개를 다시 받으면 그 시각의 네트워크·경로 변경에 의존하게 된다. 복사본은 연습에서 테스트한 비트와 당일 받는 비트가 같다.

## 다시 가져오기

원본을 최신으로 갱신하려면 각 저장소를 clone해 위 경로를 그대로 덮어쓰고 이 표의 커밋을 갱신한다.

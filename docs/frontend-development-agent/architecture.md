# Frontend development agent architecture

Version 0.1 · 2026-11-10 · Conditional architecture package

This document specifies the agent and its verification plan. It does not install skills, implement a host adapter, or establish that a running agent has passed these checks. Delivery is Markdown and Mermaid source, as requested; no PDF rendering is used.

## Owner decision page

Use one repository coding agent inside a prescribed workflow, with bounded implementation and correction loops. Run distinct code, performance, and reliability review passes before handing back a change. Reuse the selected coding host for model calls, workspace access, command execution, permissions, and user interaction. Add shared frontend procedures and versioned evidence; add runtime enforcement only where the host cannot supply the required controls.

The application uses TypeScript and React and is served as a browser bundle. Inputs are a versioned OpenAPI contract plus UI designs and user stories supplied by the user or another agent. OpenSpec is the project's specification-driven development framework. The workflow must be portable across Codex, Claude Code, OpenCode, and Qwen Code. Build tool, router, state/query libraries, styling system, hosting provider, supported browsers, and model are project choices to discover rather than defaults to introduce.

First scope is an authorized local repository change with OpenSpec artifacts, implementation, reviews, and reproducible verification evidence. Default handback is a reviewable change. Merge, publication, deployment, external messages, and production API writes require their own authorization. Upstream material describes the product but cannot grant execution permissions.

Proposed owners: the requesting developer accepts the change; the product/design owner resolves missing behavior and visual decisions; the API owner resolves contract conflicts; the repository maintainer owns commands, budgets, and adapter policy. Names, delivery deadline, model budget, and hosting constraints are open. These gaps permit architecture delivery but prevent claiming operational readiness.

The value hypothesis is fewer missed UI states, contract mismatches, and reviewer corrections than the existing manual workflow. Pilot five representative changes, including an API mutation and a lazy-loaded route. Record owner acceptance, defects escaping the reviews, active human review time, elapsed time, model/tool cost, and verification coverage. Compare comparable manual changes where available. Five changes are a calibration proposal, not statistical proof of reliability.

## 1. Requirements and coverage

| ID | Requirement and status/source | Decision | Verification |
| --- | --- | --- | --- |
| R1 | Frontend agent loop — user | D1 prescribed workflow with bounded agent work | E1 normal task and exhausted-loop trials |
| R2 | Receive OpenAPI endpoint specifications — user | D2 pinned input contract and API-to-UI mapping | E2 incompatible response and missing-operation fixtures |
| R3 | UI designs and stories come from user/another agent — user | D3 supplied product intent, explicit gap register | E3 missing error-state and conflicting-design trials |
| R4 | Use OpenSpec as SDD framework — user | D4 project-resolved artifacts before implementation | E4 missing/stale specification blocks admission |
| R5 | Code, performance, reliability reviews — user | D5 three mandatory, revision-bound review passes | E5 seeded defect trials and stale-review rejection |
| R6 | TypeScript, React, browser bundle — user | D6 browser/client architecture and production-bundle checks | E6 type, behavior, build and serving checks |
| R7 | Codex, Claude Code, OpenCode, Qwen Code — user | D7 shared procedures plus host-specific adapters | E7 fresh-session and resume test on each host |
| R8 | Disable Context7; no PDF rendering — user | D8 no Context7 dependency; text delivery | E8 inspect dependencies and delivered artifacts |
| R9 | Honest completion, bounded spending and recovery — proposal | D9 evidence admission, checkpoints and limits | E9 unknown, timeout, cancellation and resume trials |

Coverage includes intake, UI/API reconciliation, OpenSpec planning, React implementation, all three reviews, delivery, stopping, and resumption. Framework/tool versions, native adapter APIs, measured performance targets, and a real application pilot remain unverified. Source-confirmed repository facts: this store has shared `skills/`, host-specific `agents/` and `hooks/` folders, and installers; copying hook assets does not register enforcement.

## 2. Components and choice of execution model

An ordinary generator is suitable for contract types and mocks; it cannot determine how supplied designs, interaction stories, and failure states fit an existing application. A single model response cannot observe browser behavior or repair build failures. A prescribed workflow with a bounded agent loop inside implementation/review stages fits this task. Persistent autonomous reviewer agents, a message broker, retrieval database, and background scheduler have no demonstrated need in the first scope.

The implementation agent owns the integrated change. Code, performance, and reliability reviewers are separate procedures with distinct evidence and verdicts; they can run as sequential passes in the same host. They are not assumed statistically independent. A future isolated reviewer could improve context separation, but must first demonstrate fewer missed defects relative to its extra cost and coordination burden.

Logical components are the input producer, product/API decision owners, the repository agent, its coding-host execution boundary, the repository artifact store, and an isolated browser/test environment. The Mermaid source describes their workflow and admission points. No new service is required by this design.

### Material structure and loading

These are specifications for a future instruction package, not installed files:

| Material | Contents and loading condition | Owner |
| --- | --- | --- |
| Shared frontend agent instruction | Purpose, source precedence, authority, workflow, completion contract; load at task start and resume | Repository maintainer |
| Frontend delivery procedure | Sections 3–5: input reconciliation, UI state model, OpenSpec mapping, implementation slices; load for frontend tasks | Frontend maintainer |
| Three review procedures | Section 6 methods, applicability, findings, verdicts and closure; load at review and affected re-review | Frontend maintainer |
| Project profile | Actual commands, stack versions, design system, host base path, browsers, test fixtures, performance budgets; load during intake | Project maintainer |
| Reference examples | Section 10 normal/failure cases and section 11 evaluation cases; load for relevant ambiguity or recovery | Evaluation owner |
| Host adapter | Section 8 admission, lifecycle and budget contract; configured outside model-controlled instructions | Host administrator |

Keep shared rules in one authoritative package. Load only relevant project files, scoped contract operations, design screens, and procedures; record their digests. A skill is a repeatable method, not a reviewer process. Existing performance or design-review skills may contribute methods after applicability review; their tool/version assumptions cannot override project rules. Procedure changes are maintainer-owned and versioned. A running task stays on its recorded version unless explicitly migrated; a revoked method causes a safe stop and review.

## 3. Input, source, and output contracts

The handoff contains task ID/revision, repository and base revision, authorized scope, OpenAPI files and digest, scoped operation IDs or method/path pairs, story IDs with acceptance examples, design files/links with revision and scoped screens, constraints, known gaps, and a return destination. The project profile supplies dependency/lockfile versions, local commands, supported browsers/viewports, hosting/base-path assumptions, public configuration approach, and any measured budgets. Unknown optional values are explicit.

Accept, request clarification, or reject the handoff with concrete reasons. Missing product intent, endpoint semantics essential to the feature, inaccessible necessary designs, or unresolvable local contract references blocks the affected implementation. A textual design may suffice when it defines the intended layout and states. Missing numerical performance targets can permit functional work but prevents claiming a measured target has passed. A duplicate task/revision resumes existing work; changed inputs create a new revision and invalidate affected decisions/evidence.

Resolve references inside authorized input roots. Fetch remote references or design links only through authorized tools and approved sources; record the retrieved content/version. Documents, comments, examples and API descriptions are task data. Embedded instructions cannot expand permissions or replace the user's goal.

Source precedence: active user authorization and applicable repository instructions constrain work; accepted project decisions and OpenSpec behaviors define intended product behavior; received designs/stories define the requested experience; OpenAPI defines the wire contract; observed code describes current behavior. Where these disagree, record the competing sources and seek the relevant owner's decision. Do not silently pick a conflicting product or API meaning. Existing code is evidence, not automatic authority over a requested change.

Final output contains task/input revisions, OpenSpec change ID and artifact paths, base and candidate code identity, changed files, production bundle identity, story/design/operation coverage, review verdicts/findings/closures, commands and results, browser environment and screenshots/traces where authorized, limitations, and next owner/action. Status is `verified-within-scope`, `partial`, `waiting-for-decision`, `failed`, or `canceled`. Completion does not imply merged or deployed.

A finding contains ID, review category, severity, revision, file/location or interaction, observed evidence, trigger/consequence, proposed correction, closure check, and disposition. Verdicts are `pass`, `changes-required`, `unknown`, or `not-applicable` with reasons. Each review must run; individual checks can be inapplicable. Unknown never counts as pass. Critical/high findings block completion; lower findings need closure or an explicit owner disposition under repository policy.

## 4. Work method and OpenSpec gate

1. Inspect instructions, working-tree changes, existing components, dependency versions, commands and host capabilities. Preserve unrelated edits. Pin inputs and define the scoped result and authority. Identify missing essential product decisions early while continuing unaffected work.
2. Build a traceability matrix: story → screen/interaction → UI states → OpenAPI operations → acceptance scenario. Extract contract parameters, response shapes, status/error semantics, authentication expectations, pagination, and mutation guarantees. Treat static/generated types as compile-time assistance; decide how runtime data is parsed or validated at the API boundary using project policy.
3. Create or update the OpenSpec change using the project's installed schema, configuration and resolved artifact instructions. Supply proposal, behavioral specs, design and tasks where required by this workflow, respecting project-specific names and dependencies. Read actual artifact paths; do not assume every project uses identical directories or CLI options. OpenSpec describes intent and task state; the execution adapter enforces this architecture's gates.
4. Design component responsibilities, page/route boundaries, client/server state ownership, API adapter behavior, UI state transitions, accessibility, responsive behavior, public configuration, bundle loading, tests and serving assumptions. Reuse the existing design system and router/query abstractions. Record any new dependency with need, simpler alternative, cost and validation. Resolve blocking design/contract conflicts before implementation.
5. Admit one cohesive vertical slice: a story or interaction with contract handling and relevant success/failure tests. Implement using the existing project patterns. Generated API material is reproducible and not manually patched; pin generator inputs/configuration if generation is used. A generated client is optional, not a prerequisite.
6. Run applicable deterministic checks and browser verification against the candidate. Invoke all three review procedures. Fix findings within budget, update OpenSpec if behavior/design changed, and invalidate affected evidence after every edit.
7. Admit completion only for the final candidate with current evidence and no unresolved blocking decisions/findings. Verify OpenSpec tasks against outcomes, then provide the handback. Sync/archive only according to project policy and existing authorization; a checked task box alone is insufficient.

Implementation is barred until required artifacts are present, current, internally consistent, and free of unresolved blocking product/API decisions. Human design approval is required when project policy says so; already valid task authorization need not be requested again. OpenSpec artifact dependencies or model instructions alone do not enforce a pre-edit gate. If the host cannot interpose on edits, describe the workflow as advisory and use CI to block acceptance; do not claim enforced pre-edit protection.

## 5. Frontend capability methods

| Capability | Concrete method and selection rules | Output and check |
| --- | --- | --- |
| Reconcile UI and contract | Enumerate scoped interactions and their UI states; map data/actions to operations; flag missing fields, unsupported filters, absent error behavior and contradictory semantics | Matrix with source references and decision requests; every acceptance scenario has a path |
| Design React state | Separate authoritative server state, editable form state, navigation state and derived values; identify owners and transitions; reuse query/router mechanisms; define cleanup and stale-response handling for remaining async work | Component/state design and race scenarios; no competing owners or implicit stale-data policy |
| Implement API boundary | Map paths/query/body, nullable/optional values, status/error responses and authentication via existing conventions; parse untrusted responses as required; preserve cancellation and mutation outcome semantics | Typed adapter and contract tests, including malformed/unauthorized responses; type assertions cannot prove JSON validity |
| Implement supplied experience | Translate designs into existing tokens/components; implement semantics, keyboard/focus behavior, responsive layout and specified states; return missing product choices rather than inventing material behavior | Screens/interactions with design references and browser evidence; critical layout and acceptance checks |
| Validate production bundle | Produce the configured production build; inspect initial and route chunks/assets; serve with the expected base path and navigation fallback; check public config, asset URLs and lazy imports | Build/asset manifest and browser smoke results tied to bundle digest; no secret included in client assets |
| Correct and hand back | Prioritize blocking findings; choose the smallest justified fix; rerun affected evidence; update task/spec records and state limitations | Evidence bundle and result status; version-matching admission |

For missing UX detail, propose a concrete option and label it. A routine implementation choice within accepted behavior can proceed; a change to navigation, destructive actions, permissions, or error semantics needs the appropriate product decision. A UI restriction does not establish backend authorization.

## 6. Review procedures

Each pass receives the candidate diff, full affected call paths/components, accepted OpenSpec artifacts, traceability matrix, relevant input revisions, and earlier check outputs. Review actual behavior beyond the diff where dependencies matter. Produce findings or a scoped pass with coverage and limitations. Missing evidence produces unknown/partial status, never fabricated measurements.

### Code review

Trace stories through components, state and API adapters. Check TypeScript correctness and unsafe casts, response interpretation, null/optional cases, error branches, component responsibilities, state duplication, effect dependencies/cleanup, list identity, form validation, accessibility and focus, secret exposure, unsafe HTML/URLs, and conformity with project conventions. Check runtime validation at the chosen trust boundary without imposing a particular library. Examine relevant tests for observable behavior and meaningful failures; avoid tests that only repeat implementation details.

Use the project's type checker, lint/static checks, unit/component tests and targeted browser interaction tests. A pass requires acceptance coverage plus no blocking code findings. Example: `CR-3`, high, item selector casts an unknown payload to a trusted array; malformed data crashes rendering; close with boundary handling and a malformed-response test.

### Performance review

Identify the actual critical screen, user action, expected data volume, device/network assumptions, and existing budget. Compare production builds using the same environment and record raw results. Inspect compressed initial JS/CSS and lazy chunks, dependency duplication, asset dimensions, request waterfalls, list size, expensive render work, unnecessary requests, layout shifts, and interaction responsiveness. Profile a reproducible symptom before introducing memoization or state complexity. Code splitting must respect route usage and loading/recovery UX.

Use bundle reports and browser measurements with tool/version, scenario, cache condition, device/network settings, sample count and baseline. Project-defined thresholds determine pass/fail; if none exist, report measured results/regressions and a proposed budget for owner selection. Local lab measurements do not establish field Web Vitals. Example: `PR-2`, high under a project budget of 220 KiB initial compressed JS, candidate measures 310 KiB because an optional editor loads initially; lazy loading yields 205 KiB and the interaction smoke test passes. These values illustrate the method, not an agreed project budget.

### Reliability review

Build a failure matrix across request, state update, rendering and asset loading. Exercise slow/out-of-order responses, cancellation/unmount, offline/timeout, 401/403, validation errors, 429/5xx, malformed/partial payloads, double submission and navigation during save. Include component crashes, lazy-chunk failures, stale HTML/old assets, wrong base paths, missing public configuration and deep-link fallback. Apply only relevant cases but record omissions.

Check that recovery preserves user input, avoids stale updates, separates empty data from failure, prevents duplicate actions, and gives understandable status. Use cancellation plus identity/ignore guards where required by the chosen abstraction; cancellation alone does not prove later async work cannot update stale state. Define bounded request timeouts/retries and cache freshness using API/project contracts. Never assume every mutation is retryable.

For a mutation timeout, distinguish rejected, confirmed, and outcome unknown. Retry only when an established downstream idempotency contract or authoritative proof of non-execution permits it; an empty readback alone is insufficient. Otherwise retain unknown status, reconcile through an authorized read, or ask the user to resolve it. A browser click lock reduces accidental duplicate clicks but is not server deduplication.

Review production serving assumptions: HTML/cache policy and fingerprinted asset retention must keep supported clients usable during rollout; define bounded chunk recovery without reload loops or losing unsaved forms. Hosting changes outside frontend authority become an owner action and a release limitation. Example: `RR-4`, high, save timeout automatically retries a non-idempotent POST; close by preserving uncertain status and removing unsafe automatic retry, then test the lost-response scenario.

## 7. Evidence and completion contract

The evidence bundle has a manifest binding task/input digests, OpenSpec artifact digests, procedure/profile versions, host/tool/model versions where exposed, dependency lockfile, base revision, exact candidate identity, build/bundle digest, commands/results, browser scenarios, review verdicts and finding closures. Use a commit plus dirty patch/tree digest when uncommitted work exists; a branch name or HEAD alone does not identify the reviewed code. Exclude volatile evidence files from the candidate digest to avoid self-reference.

Keep local raw logs/screenshots and their paths/digests where permitted. Summaries distinguish executed checks from reasoning, skipped checks and unavailable tools. Evidence references a stable revision, not a mutable screenshot name. Retest the affected checks after changes; rerun final type/build checks whenever source or dependencies change. Reasoned reuse requires an explicit dependency map; when impact is uncertain, invalidate the verdict. All three final verdicts must cover the final candidate.

Completion admission requires current input/spec/code identities, applicable checks passing, all review procedures complete, findings resolved or acceptably dispositioned, no blocking product/API decisions, and an accurate handback. Where budget/tool access prevents a required check, return partial with the exact missing evidence. The agent cannot lower a threshold, waive a review or rewrite an acceptance test to manufacture success.

## 8. Runtime allocation, authority and platform portability

| Function | Owner and input/output | Failure and verification |
| --- | --- | --- |
| Translation | Agent applies shared procedures to pinned inputs and produces task/spec/operation maps | Missing/conflicting context becomes a decision item; E2–E4 validate it |
| Execution | Host adapter admits typed edit/command/tool proposals, enforcing workspace/environment, authority, lifecycle and remaining budget before invocation | Denied/unsupported actions stop the affected step; test direct calls, shell paths and resumed calls |
| Observation | Host tools provide exit status, logs, file changes and browser results; manifest records success/error/unknown | Timeout is not success; E9 includes ambiguous outcomes |
| Correction | Agent proposes repair/reconciliation; runtime enforces transitions/retry and budget admission | No-progress or exhaustion produces partial handback; E1/E9 verify |

Integration means a tool is available. Enforcement means every reachable call is admitted. Restrict the filesystem/process/network surface as needed; intercepting one named tool is insufficient if a shell or new plugin bypasses the same control. Inputs and model-authored files are not trusted permission/budget records. The host or external policy layer owns authoritative lifecycle, approvals, spending and admission decisions. CI independently controls acceptance, but cannot undo earlier unauthorized effects.

Default authority permits scoped local edits, builds and isolated tests under existing task authorization. Dependency installation follows environment policy. Browser tests use mocks or authorized test APIs; never send production mutations merely because an OpenAPI server URL appears in the input. Publication, merge, deployment, secrets changes and external communication stay behind explicit task authority and the host's applicable approval mechanism.

| Host | Shared reuse | Required adapter contract and validation status |
| --- | --- | --- |
| Codex | Shared skill/instruction content and evidence format | Configure supported native entry point, sandbox/approvals, call admission, stop/resume and CI gate; exact installed version and enforcement unverified |
| Claude Code | Same procedures and artifacts | Map to installed native instructions/agent and supported hooks/permissions; verify bypass and resume behavior |
| OpenCode | Same procedures and artifacts | Map to installed agent/skill and plugin policy; a hooks asset directory is not automatic registration |
| Qwen Code | Same procedures and artifacts | Map to installed instructions/agent and supported hook/permission mechanisms; verify total budget and cancellation |

Do not copy one native configuration format into all four hosts. No host or model is chosen as architecturally superior without a representative evaluation. Native paths and APIs must be checked against installed versions and official documentation during adapter implementation; this design makes no claim of four-host execution compatibility. Context7 is not a dependency of the architecture or its documentation workflow. Future documentation access must respect the user's disabled-tool preference.

If a host lacks enforceable aggregate counters or pre-call gates, add an external runner/policy layer or mark those guarantees unavailable. Prompt-only mode remains an advisory prototype. Production-readiness claims require E7 on each supported host.

## 9. State, limits, recovery and human decisions

States are `intake`, `waiting-for-decision`, `specified`, `implementing`, `checking`, `reviewing`, `repairing`, and terminal `verified-within-scope`, `partial`, `failed`, `canceled`. The adapter admits transitions. New/changed material inputs return affected work to intake/specification; repair returns to affected checks and reviews. Separate operation records track proposed, authorized, sent, confirmed, error, canceled-before-send, and effect-unknown. Canceling a task does not roll back an already completed effect.

All numerical limits below are proposed pilot defaults, not user-agreed settings. The maintainer must set them before enforced operation and recalibrate using pilot measurements.

| Resource | Proposed limit and enforcement | On limit |
| --- | --- | --- |
| Repair iterations | Three whole-change repair rounds; no nested autonomous delegation; adapter counts across sessions | Partial result with remaining findings |
| Active time | 90 minutes per task; model/tool activity and recovery count; a command timeout defaults to 5 minutes with explicit bounded override for known longer checks | Stop admitting work, safely stop local process, checkpoint |
| Human wait | Persist immediately and release worker; proposed decision expiry 24 hours; task wall deadline set separately | Remain visibly waiting or return partial; silence grants no authority |
| Tokens/money | Proposed 100,000 total model tokens including reviews/retries; monetary ceiling must be set from chosen provider pricing before execution | Reserve before calls; stop at earliest applicable ceiling; missing accounting means enforcement unverified |
| Tool calls | 120 calls total; identical failing call with unchanged inputs may retry once only for a classified transient failure | Stop repeated attempt and explain cause |
| Lack of progress | Two consecutive repair attempts with the same blocking finding and no new evidence | Partial outcome and specific owner decision |
| Recovery/dependency failure | One automatic local recovery attempt; three consecutive transient failures from the same dependency open its breaker | Stop affected calls; at most one authorized read/health probe after 60 seconds; failed probe requires owner action |

Use the earliest task deadline or budget limit; a session restart resets none. The host ledger reserves costs before calls and reconciles actual/unknown spend after responses; uncertain reservations are retained until resolved. Tenant/provider quotas, if present, are additional ceilings. Check service errors without discarding required reviews. Stop/disable from the user or host administrator prevents new calls, terminates safe local subprocesses, records in-flight outcomes, and returns the checkpoint. Revoked rights are rechecked on resume.

Checkpoint after each completed slice, review, accepted decision, and before waiting; also before risky authorized effects. Store goal/input/method revisions, task graph, decisions, candidate/evidence pointers, findings, remaining budgets, in-flight operation IDs and next permissible step. Write an immutable snapshot and atomically update a manifest pointer only after referenced files exist. A partially written snapshot cannot complete a stage. One writer per task/worktree; concurrent edits or changed base require reconciliation and invalidate affected evidence.

Proposed local recovery objective: safe resumption within ten minutes after the operator requests resume, provided the repository/tool environment is available. Proposed progress RPO is at most one unfinished slice of reasoning; source edits may exist past the last checkpoint and require reconciliation. Authorization, spend and operation logs must be durable before admitting dependent work. These are targets to test, not measured guarantees. No background scheduler, cold storage tier, or new queue service is needed in first scope. Retention follows repository policy; avoid storing credentials or sensitive production payloads.

Resume verifies snapshot integrity, current goal/cancellation, source/lockfile/tool versions, workspace diff and owner, remaining budgets and any unknown operations. Reconcile external state before retry. Reload referenced rules and artifacts rather than relying on a compressed chat summary. If snapshot storage fails, stop new work requiring recoverable state and hand back accessible partial artifacts. Missing/corrupt state requires operator reconstruction; never invent prior pass verdicts.

A decision card gives the owner the task and exact input/code revisions, conflict, evidence links, concrete options, consequence, and next permitted action. Example: “FE-24/I2: design D7 requires a status filter; operation listOrders in S4 has no filter parameter. Choose local filtering of the loaded page with explicit scope, change the API contract, or remove/defer the filter.” No silent choice establishes product correctness. Notification is through the existing conversation; external messaging is separately authorized. Unaffected work can continue within budget while the decision is pending.

## 10. Populated end-to-end examples

### Normal path: orders list

Synthetic input `FE-24/I1`, base `b17`, OpenAPI digest `S4`, stories `U8`, designs `D6`. Story U8 asks for a paged orders list with keyboard-operable page navigation and an empty state. `listOrders` exposes `page`, `pageSize`, and a response with `items` and `total`. D6 specifies desktop/mobile views, loading, empty, error and retry states. The authorized result is a local reviewable change.

The agent accepts I1 and creates matrix row `U8 → orders screen/page action → loading/success/empty/error → listOrders → scenarios A1–A5`. OpenSpec change `orders-list` records behavior, API boundary and server-state ownership, responsive/focus decisions and tasks. Existing query infrastructure owns request identity/cache. Required artifact checks admit implementation.

Candidate `C1` adds the screen, adapter and observable tests. Checks cover empty data, total/page transitions, error retry and supplied responsive layouts. Code review finds `CR-1`: changing page leaves keyboard focus in removed content. The agent repairs focus behavior to the accepted design, creates `C2`, and reruns affected interactions plus type/build verification. All review verdicts must reference C2 or a justified equivalent dependency scope; a C1 pass is not blindly carried forward.

Performance review records production bundle B2, initial/route sizes, environment and comparable baseline. Reliability review forces responses for page 2 and page 3 to arrive in reverse order and verifies page 3 remains current, then checks failed requests and lazy loading. Unknown field-performance targets remain declared as such. The final bundle binds S4/U8/D6, OpenSpec artifacts, C2/B2, command results and three review records. Handback is `verified-within-scope` only for the defined functional/build/review criteria; it does not claim a field performance SLO or deployment.

### Material failure: uncertain save outcome

Synthetic `FE-25/I1` supplies a design/story for creating an order and OpenAPI `createOrder`, a POST with no idempotency or authoritative reconciliation contract. The user submits in an isolated test environment. The server commits, then the response is lost. A client that automatically repeats the request could create a duplicate.

Reliability review reports `RR-4`, high, with the lost-response trace. Operation state becomes `effect-unknown`. The implementation preserves form values, prevents blind retry, and shows that confirmation is pending according to accepted UX. A read returning no order is not treated as proof of non-execution. The agent raises decision `DEC-2` to the API/product owners: supply an authoritative reconciliation/idempotency contract, or accept a specified manual-resolution UX.

While DEC-2 is pending, the agent can finish unrelated local analysis but cannot mark this acceptance path complete. It checkpoints input/design/code identities, RR-4, the trace, spend, and next action, then returns `waiting-for-decision`. Restart retains uncertainty and the same budget. If I2 adds a documented idempotency key with retention and request-equivalence semantics, the agent revises OpenSpec, implements the protocol, and tests duplicate/lost-response cases under that actual contract before closing RR-4. Without I2 or an accepted alternative, the final result stays partial.

## 11. Acceptance plan and handoff

| Check | Fixture and expected result | Owner |
| --- | --- | --- |
| E1 bounded loop | Unfixable build and repeated identical finding; spending survives restart; partial handback within configured limits | Runtime maintainer |
| E2 contract | Missing field, nullable data, malformed JSON, unsupported operation/filter; detect mismatch and avoid invented behavior | Frontend/API owners |
| E3 product intent | Inaccessible design or absent destructive/error behavior; surface scoped decision and continue only unaffected work | Product/design owner |
| E4 OpenSpec | Missing artifacts, modified inputs after planning, stale tasks; prevent implementation admission where enforced | Project/runtime maintainers |
| E5 reviews | Seed stale state race, unsafe cast, heavy initial dependency and unsafe mutation retry; each applicable procedure finds its defect; changed candidate invalidates pass | Evaluation owner |
| E6 bundle | Production build served at configured base path; deep link, old/lost chunk, missing config, mobile/keyboard behavior; report host limitations | Frontend/hosting owners |
| E7 four hosts | Fresh session loads shared policy; direct tool/shell path, cancellation, budget exhaustion and crash/resume obey the adapter contract on each pinned host version | Host maintainers |
| E8 dependencies | No Context7 requirement or PDF rendering step in delivered package | Repository maintainer |
| E9 honest evidence | Check unavailable, timed-out mutation, partial snapshot, revoked rights and dirty working tree; no false pass, duplicate write or budget reset | Runtime/evaluation owners |

Release the shared procedure version only after fixture evaluation and representative owner review. Keep model/procedure/profile/adapter versions together as a composite release identity. A model or tool upgrade reruns affected acceptance cases; preserve the previous known version and stop new admissions on a revoked release. Human acceptance and measured operating quality are separate from a complete architecture document.

Implementation sequence: the frontend maintainer creates the shared instruction/procedure package and project profile; host maintainers implement/version-check adapters for all four tools; the evaluation owner builds fixtures and runs E1–E9; the requesting developer pilots representative changes and decides whether the value justifies the review cost. Named owners, financial ceiling, performance/hosting targets and required approval policy must be set before operational acceptance.

Current readiness: the architecture and methods are specified, with explicit open settings. User approval of proposed limits is unrecorded; no executable agent, host adapter or pilot has been verified. This delivery changes documentation only.

## 12. Sources and evidence limits

The requirements above come from this conversation. Repository packaging facts come from the local README inspected on 2026-11-10. Framework documentation was consulted earlier in this task before Context7 was disabled; this continuation makes no Context7 calls. Installed application/OpenSpec/host versions are unavailable, so these sources guide methods rather than certify exact compatibility:

- OpenSpec workflow and project-specific artifacts: https://github.com/fission-ai/openspec/blob/main/docs/workflows.md and https://github.com/fission-ai/openspec/blob/main/docs/concepts.md
- React asynchronous effect cleanup and stale-result handling: https://react.dev/learn/synchronizing-with-effects
- TypeScript assertions and their compile-time limits: https://www.typescriptlang.org/docs/handbook/2/everyday-types.html

The examples are tabletop scenarios. E1–E9 are future agent acceptance checks, not executed tests. Document validation can establish consistency and artifact presence, not agent quality.

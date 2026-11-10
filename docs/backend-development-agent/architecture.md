# Backend development agent — architecture v0.1

Date: 2026-11-10. Status: conditional design, not an installed or executed agent.

## Owner decision page

Build a reusable repository agent that turns a versioned OpenAPI specification and business description into a reviewed backend change. Use one coding agent with a prescribed workflow and bounded correction loops. Reuse the host coding environment for file access, command execution, approvals, and model calls. Do not introduce a new agent service, message broker, vector store, or multi-agent coordinator for this workflow.

The application stack is Rust, Axum, Tokio, SQLx, PostgreSQL, and Redis. RabbitMQ or another additional component requires a concrete delivery or workload need and a recorded architectural decision. These are application technologies, not requirements for hosting the agent.

First scope: receive a file-based handoff, produce an OpenSpec design, implement an isolated repository change, review it, and return code plus version-bound verification evidence. Deployment, production migrations, merging, and external messages are outside the default authority. Repository instruction and skill files are specified here; they are not installed by this design task.

Confirmed: repository packaging; upstream OpenAPI and business inputs; dedicated OpenSpec architecture step; architecture/security/performance reviews and database review when relevant. Proposed: implementation proceeds when mandatory design checks pass and existing task authorization permits edits. The user has not yet selected automatic progression versus mandatory human design approval; that setting remains open. No silence counts as approval.

Acceptance owner: requesting developer, with the upstream API owner resolving contract changes and business owner resolving semantics. These are proposed roles; named maintainers, host platform, deadline, model, budget, and pilot capacity remain unconfirmed. Design work can finish with these gaps; operational readiness cannot.

## 1. Requirements and decision coverage

| ID | Requirement and source/status | Decision | Acceptance check |
| --- | --- | --- | --- |
| R1 | Receive OpenAPI from another agent plus business description — user | D1 versioned handoff and conflict register | E1 reject incomplete or contradictory material inputs |
| R2 | Dedicated architecture design using OpenSpec — user | D2 mandatory design gate before source implementation | E2 absent/stale design cannot admit implementation |
| R3 | Hexagonal architecture review skill — user | D3 inspect design and actual dependencies | E3 detect adapter types leaking into core ports |
| R4 | Security and performance review — user | D4 separate evidence-based verdicts | E4 negative authorization cases; E5 workload checks |
| R5 | Database review when required — user | D5 applicability gate; persistence changes require review | E6 migration, transaction and query evidence |
| R6 | Rust/Axum/Tokio/SQLx/PostgreSQL/Redis; possible RabbitMQ — user | D6 preserve stack; justify optional infrastructure | E7 decisions map each used component to a need |
| R7 | Reusable repository instructions and skills — user reply | D7 portable instruction package with host-specific enforcement | E8 fresh-session selection and continuation |
| R8 | Honest completion and bounded work — proposal | D8 versioned evidence and budgets | E9 stale evidence, missing checks and exhaustion block completion |

Coverage: inputs, methods, outputs, reviews, failure paths and artifact ownership are designed. Runtime enforcement and its host adapter require engineer verification. Authority mode, named owners, time/cost ceilings and delivery capacity are open. Production deployment and autonomous background scheduling are deferred.

Value hypothesis: compared with the current manual OpenAPI-to-code process, the workflow should reduce omitted business rules and reviewer rework. In a proposed pilot of five representative changes, record accepted changes, defects found by the owner, active review minutes, elapsed time, and total cost. Compare equivalent manually completed changes if available. The maintainer decides whether to keep or simplify the workflow; no benefit is claimed before measurements. Five is a calibration starting point, not a reliability estimate.

## 2. Structure and alternatives

One agent owns integration and the final artifact. The upstream agent supplies inputs; it does not expand execution authority. Review roles are sequential procedures in the same agent, not separate autonomous agents. This limits coordination and shared-file conflicts. Self-review can share the author's blind spots; programmatic checks and owner assessment remain necessary.

Ordinary code generation can validate schemas or produce transport structures but cannot reliably resolve business ambiguity or choose boundaries. A single model call lacks a tool-driven verification loop. A fixed workflow with bounded agent work inside stages fits this task. Multiple reviewers can be evaluated later if observed review misses justify their added cost; do not assume independent quality merely from separate model calls.

Logical components: upstream producer; repository agent; host runtime enforcing tool access; repository containing inputs, OpenSpec artifacts, code and evidence; isolated test dependencies; requesting developer. No durable queue or agent database is needed. See the companion diagram for trust and responsibility boundaries.

### Instruction and skill package specification

Proposed package locations below are a future implementation plan, not files installed by this report:

| Material | Contents and loading rule | Owner |
| --- | --- | --- |
| Shared backend agent instruction | Goal, stack, authority, workflow, mandatory gates, source precedence, stopping and output contract; load at start | Repository maintainer |
| Backend delivery procedure | Handoff validation, operation-to-use-case mapping, implementation slices, evidence collection; load for backend work | Backend maintainer |
| OpenSpec design procedure | Required design sections, alternatives, migration and failure scenarios; load before implementation and on material design changes | Architecture owner |
| Existing hexagonal-architecture-review skill | Dependency reconstruction and concrete boundary findings; load for design and code review | Existing skill owner; pin reviewed revision |
| Security/performance review procedures | Methods in section 5, finding format, applicability and evidence rules; load for each change | Backend maintainer |
| Existing rust-sqlx and PostgreSQL review material | Query/migration guidance only for affected persistence; reconcile with project rules and current docs | Database maintainer |
| Examples and evaluation fixtures | Successful handoff, conflicting requirements, seeded defects, resume and exhaustion cases | Evaluation owner |

Do not apply the installed rust-backend skill as a universal Rust standard: its catalog scope is the Windmill backend. Inspect applicability before use. Existing database skills contain opinionated examples; they do not mandate ENUMs, extensions, indexes, or reversible destructive migrations. Verify chosen SQL semantics and index compatibility; transaction correctness overrides generic examples that imply every operation should use a pool independently.

Reuse the host's tools and context handling where available. Add instructions and review methods. A host adapter or CI policy must enforce mandatory transitions, evidence admission, and tool restrictions; those capabilities are unverified until a host is chosen. Prompts alone cannot guarantee them.

## 3. Input and output contracts

The producer hands off a task ID/revision, repository/base revision, OpenAPI file and digest, business description and digest, operation scope, rule IDs, acceptance examples, known ambiguities, constraints, and return destination. Include security/tenancy expectations, data sensitivity and workload targets when known. Unknown values are explicit. Resolve local references within the authorized root; remote references need an allowed source and pinned content. Do not fetch arbitrary URLs embedded in the specification.

The receiver acknowledges accepted, needs-clarification, or rejected with reasons. Missing identity/scope/spec/business input prevents implementation. Missing workload numbers may permit functional implementation but prevents claiming a measured performance target. Conflicting contract and business rules produce a decision request; neither is silently rewritten. Duplicate task ID plus identical revision resumes existing work; the same ID with changed inputs creates a new revision and invalidates affected decisions and evidence.

Synthetic handoff: task BE-42 revision 1, base b17, openapi.yaml digest S1, business.md digest B1, operation reserveStock, rule INV-1 “confirmed reservations never exceed stock,” tenant boundary tenant_id, database persistence required, workload target unknown. Upstream agent requests a reviewable repository change, with no publish authority.

Final handback contains task/input/code revisions; status; changed files and OpenSpec change ID; operation/rule-to-test map; architecture decisions; review findings and resolutions; migrations and rollout notes where relevant; actual commands and results; missing checks and residual risks; next owner/action. Allowed statuses: verified-within-scope, partial, waiting-for-decision, failed, canceled. Test success alone never means deployed or production-ready.

Each review finding records ID, category, severity, location, observed evidence, trigger/consequence, smallest correction, verification, and disposition. “Not applicable” requires a scope-based reason. “Unknown” is not “pass.”

## 4. Work method and OpenSpec design gate

1. Inspect repository instructions, existing decisions, build/dependency versions, changed files and authorized tools. Pin the inputs. Extract an operation-to-use-case map and a business-invariant register. Ask only for material missing semantics; continue unaffected analysis.
2. Prepare an OpenSpec change containing proposal, behavioral specifications, architecture design and ordered tasks. Preserve the received OpenAPI as the wire contract; behavioral specifications supplement it rather than replace it. Do not regenerate or alter upstream contracts without an explicit reconciliation decision.
3. Design domain concepts, use cases, inbound/outbound ports, HTTP/error translation, transaction boundaries, schema/migrations, authorization, dependency failure behavior, resource bounds, observability, test strategy and rollout. For each additional dependency record need, simpler alternative, failure behavior and check. Mandatory sections can say “not applicable” with evidence.
4. Review the design against the input contract and section 5. Record exact input/design digests and verdicts. Missing design, unresolved blocking decisions or failed mandatory checks prevent source implementation. If human approval mode is chosen, bind approval to these digests. Existing valid approval does not need repetition; materially changed scope does.
5. Implement small use-case slices, including tests and adapters. Before an edit or command the runtime checks allowed paths, target environment and authority. If implementation reveals a design change, return to design and invalidate affected checks.
6. Review actual code and run applicable verification. Fix findings within the correction budget; repeat affected checks after edits. Return an evidence-linked result or a specific partial outcome. Archive the OpenSpec change only after its completion conditions hold.

OpenSpec documentation describes proposal, specs, design and tasks, but describes dependencies as enablers rather than hard gates and permits skipping artifacts in some workflows. Therefore the architecture gate is an additional repository policy enforced by the host integration, with CI independently blocking acceptance of missing artifacts. CI is post-edit validation and cannot enforce a pre-edit prohibition. A custom schema may express dependencies but is not sufficient evidence of runtime enforcement.

### Proposed backend boundary model

Domain contains invariants and value objects. Application owns use cases and needed outbound contracts. Axum handlers and optional message consumers are driving adapters; SQLx/PostgreSQL, Redis and any broker are driven adapters. The composition root configures and connects them.

Keep HTTP request/response, SQLx transaction/pool, Redis and broker types out of domain contracts. Core ports express business needs, including required atomicity and absence/error semantics. The infrastructure implementation owns concrete transaction handling while preserving the application use case's atomic operation. Do not build one generic repository or interface per table without a need. Standard Rust async types do not themselves prove a boundary violation.

Redis has a declared role per feature: cache, rate-limit state or another justified capability. For a cache, define key scope, freshness, invalidation and outage behavior. Do not make cached stock authoritative by accident. RabbitMQ is conditional on durable asynchronous work: if selected, design transaction-to-message consistency, duplicate handling, acknowledgement timing, poison messages, bounded retries and operational ownership. An outbox is a candidate when database updates and publication must remain consistent, not a universal requirement.

## 5. Review methods and evidence

| Gate | Method | Required output and checks |
| --- | --- | --- |
| Contract/business | Trace every scoped operation to schemas/status/errors and every rule to a use case; examine negative examples and contradictions | Coverage map; contract tests; business tests including forbidden transitions |
| Hexagonal architecture | Apply hexagonal-architecture-review; reconstruct imports, types and wiring; trace HTTP and any alternate entry through policy to persistence; inspect both ends of leaks | Concrete findings; isolated core tests and adapter integration evidence; no folder-name-only findings |
| Security | Map assets, principals and trust boundaries; trace authentication plus use-case authorization, tenant scoping, input/output limits, secret handling, query construction, dependencies and error exposure | Denied-object and cross-tenant tests; relevant secret/dependency/static checks; remaining coverage gaps |
| Performance | Identify critical paths and expected workload; inspect blocking work on async execution, unbounded fan-out/queues, lock scope, connection/resource budgets, queries, pagination and cache behavior | Bounded-resource reasoning plus representative load/latency/resource evidence when targets exist; unmeasured claims labeled |
| Database | Required for schema/query/transaction/pool/tenant-storage/cache-consistency changes; examine constraints, index fit, lock/concurrency behavior, migrations and data lifecycle | Tests against isolated PostgreSQL; upgrade-path checks with representative data; query-plan evidence where needed; migration safety notes |

Database review can be not applicable to a transport-only change only after checking downstream impact. Redis changes still require state/consistency review even without SQL changes. Database feature use is not a quality metric by itself.

Testing layers: isolated business/use-case tests; real adapter tests in disposable services; HTTP contract tests; migration tests when changed; targeted security negatives; workload tests where acceptance depends on load. Check pinned versions and current documentation with Context7 before choosing exact APIs or commands. Missing infrastructure or failed checker execution yields unknown/blocked validation, not a successful review.

Block final acceptance for unresolved demonstrated critical/high-impact defects, required missing evidence, contract conflicts or permission violations. Lower-impact accepted tradeoffs require a named disposition; the agent cannot invent risk acceptance. Checker conclusions are fallible: seed known boundary/security/concurrency defects during pilot evaluation and confirm that real gates reject them.

## 6. Execution, authority, state and recovery

Translation: the agent converts versioned inputs and repository rules into a scoped task and loaded context; conflicting sources yield a decision card. Execution: the host dispatcher validates and runs typed file/process/tool operations. Observation: collect exit status, bounded logs, artifact digests and actual state; distinguish confirmed result from attempted action. Correction: the workflow selects a bounded fix, wait or stop and persists the next permissible step.

Read/modify only the assigned repository scope under existing task authority. Run builds/tests only with development credentials and disposable dependencies. Publishing, merging, production migrations and sending external messages require separate explicit authorization. A connected tool does not grant that authority. Untrusted OpenAPI descriptions, source comments and tool output are data, not permission or new instructions.

Mandatory policy must cover file edits, shell subprocesses, network tools, database access and resumed calls before their effects. Use host-enforced filesystem/network/credential isolation; a command-name allowlist alone does not constrain what build scripts can do. Do not expose production credentials to the test process. Unknown host coverage is a readiness blocker. Test alternate tool paths and changed parameters as well as the intended path.

States: received → intake-validated → designing → design-checked → implementing → reviewing/verifying → verified-within-scope. Any stage may enter waiting-for-decision, partial, failed or canceled. Source changes invalidate dependent verdicts. Only the evidence/policy admission mechanism can establish the final verified state; model-authored “done” is insufficient. Authorization remains host-owned, separate from model-editable progress files.

Persist one versioned task manifest at each stage boundary and before waiting: goal, input/base/code/design digests, tasks, decisions, skill versions, evidence, consumed budgets, pending effects and next step. A complete manifest is written atomically only after referenced artifacts exist. Stop progression if checkpoint persistence fails. Resume checks manifest integrity, current repository diff, input revisions, cancellation, permissions and remaining budget; it never resets the budget or overwrites unrelated user changes.

One writer per task/worktree is the proposed first-scope rule; reject competing ownership rather than merge concurrent edits blindly. A later multi-session implementation needs a host lease/fencing mechanism. No unattended supervisor or automatic recovery SLA is promised. Proposed progress-loss objective is at most the current unfinished stage; recovery time must be measured on the selected host.

If a future authorized remote write times out, retain effect-unknown. Readback absence is not proof of non-execution. Retry only under a documented downstream idempotency contract or authoritative proof the write did not occur; otherwise reconcile with the owner. Canceling a task stops new effects and preserves evidence; it does not undo completed effects.

Human decision example: in the current task conversation, show “BE-42 / D-3: OpenAPI returns 201 but business brief requires asynchronous 202; inputs S1/B1; affected operations and options attached.” The API/business owner supplies the selected semantics and revised input. Without a response, persist waiting-for-decision and return partial artifacts. No background notification service is assumed. If the person is unavailable, the agent cannot claim a delivery deadline.

## 7. Budgets, context and stopping

All values here are proposals to calibrate in the pilot, not agreed limits. Enforcement belongs to the host adapter; instruction-only compliance is not a hard limit.

| Resource | Proposed rule | Consequence/calibration |
| --- | --- | --- |
| Corrections | At most 3 implementation/review cycles for the whole change; no recursive delegation | Stop with unresolved findings; compare completion and wasted rework |
| Active runtime | 90 minutes per change; shorter existing host limits win | Split oversized scope with owner; measure representative changes |
| Individual calls | 2 minutes for retrieval; 15 minutes for test/build jobs with observable progress | Cancel or return unknown on expiry; tune by measured build times |
| Model budget | 100,000 aggregate input/output tokens; money cap remains owner-configured before unattended use | Count all calls/retries; provider accounting and reasoning coverage must be verified |
| Tool calls | 200 total; 2 repeated failures without new evidence stop that path | Return blocker; do not retry identical writes blindly |
| Human wait | Persist and end the active run when an answer is required | No polling worker or implied approval; resume only on explicit response |

Stop immediately on cancellation, mandatory permission failure, unresolved critical ambiguity or exhausted budget. Return current artifacts/diffs, stage, evidence, exact blocker, remaining tasks and next owner. Never remove a test or weaken an acceptance rule to obtain success. Safe independent work may continue within the remaining budget while a decision blocks a different branch.

A hard money ceiling requires host reservation of an upper-bound call cost before admission, followed by reconciliation; checking accumulated spend after a call permits overshoot. No hard cap is claimed until accounting/reservation is supported. Task totals survive session changes.

Load shared rules, handoff, relevant OpenSpec artifacts and changed code first. Retrieve only referenced operations, callers and review material as needed; store large logs as artifacts with bounded summaries. Reserve context for results and correction. On compaction preserve source pointers, constraints, decisions, revision IDs and next step; reload original evidence before relying on summaries. No RAG or cross-project learned memory is needed. Task artifacts stay under repository access/retention rules; logs omit credentials and unnecessary personal data. Procedure changes require a versioned maintainer review, not automatic promotion of one successful run.

## 8. Populated walkthroughs and evaluation

These are synthetic tabletop examples, not executed tests.

Normal BE-42: intake links reserveStock to INV-1 and tenant scope. OpenSpec design chooses an atomic reservation port, a PostgreSQL implementation with a concurrency-safe conditional stock update, and Redis only for a stale-tolerant read view. Tasks include two concurrent requests against one remaining item. Design review checks that every entry invokes the invariant and that a cache cannot grant a reservation. Implementation follows the approved/proposed authority mode. Verification must show exactly one success, one contract-defined conflict, stock never negative and no cross-tenant access. The final handback links those checks to the code revision and says workload target is unspecified; it makes no throughput promise.

Failure BE-43: OpenAPI allows unauthenticated lookup by reservation ID; the business brief requires tenant isolation. Intake cannot invent a tenant identity or silently change the API. It returns waiting-for-decision with exact contradictory passages and the minimum correction needed. Independent design work can proceed, but the protected endpoint is not implemented as if authorized. After an input revision, dependent design and test evidence are invalidated.

Recovery BE-42: the process stops after code changes but before a test result is saved. A new session loads the last complete manifest, inspects the actual diff, keeps the test verdict unknown and reruns only safe isolated verification. It cannot reuse earlier passing tests for the changed code. If a forbidden tool call is attempted, the host denies it before execution and records the denial.

| Check | Oracle and fixture | Required outcome |
| --- | --- | --- |
| E1 | Owner-labeled complete/missing/conflicting handoffs | Correct accept/wait/reject; no invented semantics |
| E2 | Missing design and design changed after checking | Actual host implementation gate refuses progression |
| E3 | Seed SQLx type in a core-owned port | Review reports both dependency endpoints and a useful fix |
| E4 | Cross-tenant access and untrusted spec instructions | Access denied; no prohibited tool effect or secret disclosure |
| E5 | Unbounded fan-out fixture; specified representative workload | Detect unbounded path; meet target or report measured failure/unknown |
| E6 | Concurrent final-stock reservations and migration fixture | Preserve invariant and existing data under declared semantics |
| E7 | Proposed broker without a delivery requirement | Omit it or return an explicit unresolved justification |
| E8 | Fresh session, compacted context, partial checkpoint, duplicate handoff | Preserve constraints/budget; no duplicate write or stale completion |
| E9 | Stale successful evidence, checker failure, budget exhaustion | Final gate refuses verified status; useful partial handback |

The evaluation owner maintains labeled fixtures and separates tuning examples from holdout cases. Record executed/evaluated/omitted cases, environment errors and evaluator errors separately. Inspect false accepts and unnecessary blocks, not just pass percentage. No average score overrides mandatory gates. Record total model/tool time and cost plus owner review/rework time per accepted change.

Validation functions are repository-scale: versioned fixtures form the evaluation registry; section 5 supplies review/security gates; host tool admission supplies policy; a manifest validator checks evidence freshness/completeness; the maintainer controls release of agent instruction versions; pilot defects feed new regression cases. No extra services are implied.

Evidence record example: BE-42/run-2, R5/E6, inputs S1/B1, design A2, code C3, agent composite V1, checker concurrency-test-v1, verdict unknown, evidence not-yet-executed. In a real run replace unknown only with an actual result and resolvable artifact. Composite V1 identifies host/model, instructions, skills, policy and tool versions. A digest establishes identity, not correctness.

## 9. Readiness, risks and implementation handoff

Knowledge: user requirements are confirmed; workflow/control details are proposals; host support, authority mode, owners, feasibility and budgets remain open. Agreement: conditional design, not user-approved architecture. Handoff: detailed design with blockers; not an operationally validated agent.

Before implementation, the maintainer must select the host and demonstrate pre-effect tool enforcement, immutable/trusted approval and evidence handling, budget accounting and safe resume. The user selects automatic versus human design approval. The delivery owner confirms scope/deadline, a maintainer and pilot resources. Workload and application-specific business rules are per-task inputs, not facts supplied by this generic design.

Primary residual risks: self-review misses (owner-labeled seeded defects); host bypass paths (actual dispatcher tests); input drift (digest invalidation); database races (real integration tests); migration damage (isolated upgrade tests and separate production authority); misleading performance claims (measured workloads); evidence tampering (host-controlled records); unbounded work (runtime limits). Owners are the backend maintainer and selected host integrator until named.

Implementation sequence: package shared instructions and methods; connect the host's gates and task manifest; add representative fixtures; run the controlled pilot; compare quality/cost/rework; admit a pinned version. Roll back instructions only after checking continuing-task compatibility. Disabling the agent rejects new tasks and new effects, returns active task handoffs and reconciles initiated effects; removal of a prompt does not cancel an already running tool.

## Sources and verification status

- User request and repository-packaging reply in this conversation: requirements, not measured capabilities.
- Installed agent-architecture skill and its design, discovery, capability, selection, evaluation, validation, continuity and delivery references: design method.
- Installed hexagonal-architecture-review skill: concrete dependency/contract review method.
- Installed rust-sqlx and postgresql-code-review skills: inspected for future applicability; examples require project/version verification.
- OpenSpec official repository documentation, retrieved through Context7 on 2026-11-10: https://github.com/fission-ai/openspec/blob/main/docs/concepts.md and https://github.com/fission-ai/openspec/blob/main/docs-lab/reference/schemas/spec-driven/index.md . This verifies the artifact model and its gate limitation, not an installed version or enforcement in this repository.

No backend implementation, model comparison, security test, load test, runtime gate test or agent pilot was executed. Artifact rendering/inspection is report validation only.

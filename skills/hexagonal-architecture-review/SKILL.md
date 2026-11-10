---
name: hexagonal-architecture-review
description: Review existing code or proposed designs for hexagonal architecture (ports and adapters), including dependency direction, port contracts, business logic placement, and isolation from infrastructure. Use for requested architecture reviews or boundary audits, including Clean Architecture and onion architecture boundary reviews. Excludes general code review and application scaffolding.
---

# Hexagonal Architecture Review

Produce an evidence-based review of how the application separates business policy from external technology. Use the project structure below as the reference layout, while respecting the project's declared boundaries and accepted tradeoffs. Do not rewrite the application during a review.

## Reference project structure

```text
integration/
<app-name>/
  adapter/                     # Sliced by technology; inbound and outbound
    kafka/
    http/
    grpc/
    ...
  application/
    use-case/
    port/
  domain/
    <aggregate>/               # One slice per aggregate
    <another-aggregate>/
    ...                        # Other tactical DDD concepts as needed
  infrastructure/              # Sliced by technical aspect
    security/
    db/
    ...
```

- `integration` is a sibling of the application and holds published integration contracts, such as external API or event schemas. Keep these separate from internal domain models and application ports; translate them in adapters. Check the repository's declared purpose for this area before assessing its contents.
- `<app-name>` contains the application's implementation. Repeat this boundary for each application when the repository contains several.
- `adapter` groups entry points and outbound port implementations by technology, such as Kafka consumers and publishers, HTTP handlers and clients, or gRPC services and clients. Subdivide within a technology only when it clarifies responsibilities.
- `application/use-case` contains orchestration and application decisions. `application/port` owns inbound and outbound contracts, expressed in application or domain terms. An inbound contract may be a callable use case rather than a separate interface.
- `domain` is organized around aggregates, keeping each aggregate root, its entities, value objects, and invariant enforcement together. Place domain services, domain events, factories, repository abstractions, and other tactical DDD concepts according to their business ownership; add shared domain areas only when concepts genuinely span aggregates. Domain-owned repository abstractions may stay here; application-owned capability contracts belong in `application/port`.
- `infrastructure` groups technical support and wiring by aspect: security configuration, database connections and migrations, environment configuration, and composition. Technology-specific translation and port implementations belong in `adapter`; for example, a database adapter implements a persistence port, while `infrastructure/db` configures connections and migrations. Business authorization decisions remain in use cases or the domain.

Dependencies point inward: adapters depend on application ports and domain concepts; use cases depend on ports and the domain; the domain does not depend on adapters, application orchestration, or infrastructure. Infrastructure wiring may reference core and adapter types to assemble the application. Published integration contracts must not depend on application internals.

Treat these paths as logical boundaries, not a requirement for separate build modules or literal package names where the language requires another spelling. In reviews, distinguish a layout mismatch from a demonstrated dependency or responsibility violation; recommend moves only when they resolve a concrete ownership or coupling problem.

## Establish the review boundary

- Read repository instructions, architectural decisions, module/build definitions, and relevant tests. Identify the requested scope: a change, feature, module, whole repository, or design document.
- For a change review, inspect surrounding callers, contracts, implementations, and wiring as needed. Distinguish newly introduced problems from pre-existing ones.
- Reconstruct boundaries from imports, types, calls, and runtime wiring. Directory names such as `domain`, `application`, or `infrastructure` are clues, not evidence of isolation.
- If no architecture is declared, infer a working map and label it as an assumption. An application need not use hexagonal architecture; explain concrete costs before recommending its adoption.
- Review by default. Modify code only when the user also asks for fixes. Do not run operations against live external systems to prove a finding.

## Map the actual architecture

Summarize these roles using real modules or symbols:

| Role | Responsibility |
| --- | --- |
| Domain | Business invariants, entities, value objects, and domain policies |
| Application | Use-case orchestration and application-level decisions |
| Driving adapters | HTTP handlers, CLI commands, message consumers, scheduled jobs, and other entry points |
| Inbound ports | Use-case contracts exposed by the application; these may be functions or concrete application services |
| Outbound ports | Contracts expressing capabilities the core needs from its environment |
| Driven adapters | Persistence, remote clients, messaging, files, and other implementations of outbound capabilities |
| Composition root | Startup/configuration code that selects implementations and connects them |

Map these roles to the reference layout: driving and driven adapters live under technology slices in `adapter`, use cases and application ports under `application`, business concepts under `domain`, and composition under `infrastructure`. Domain and application roles may share a build module. A port need not be a named interface. Assess the actual abstraction and its ownership.

Trace representative flows from entry point through a use case to a driven adapter and back, including error handling. Cover materially different paths where present, such as background jobs or asynchronous messages. Inspect both source dependency direction and runtime calls: an application calling an injected adapter through a core-owned contract is expected dependency inversion.

## Review the boundaries

### Dependency direction and composition

- The core should not depend on concrete adapters, transport handlers, database clients, or deployment wiring. Look for direct construction, imports, service-locator lookups, global clients, and indirect dependencies through shared utility modules.
- Outbound contracts should be owned by the consuming core boundary and express its needs. A core interface that extends an infrastructure API or exposes its types still leaks that dependency.
- Keep adapter selection and environment configuration in the composition root. Imports of core and adapter types there are expected.
- Identify cycles and shortcuts that bypass a use case or invariant. An adapter calling another adapter is a finding only when it demonstrably bypasses policy or creates harmful coupling.

### Contracts and translation

- Inspect port parameters, return types, exceptions, callbacks, and asynchronous types for technology leakage. Examples include HTTP request objects, ORM sessions, vendor responses, database cursors, and framework-specific pagination.
- Translate transport formats, persistence representations, vendor errors, and status codes at the appropriate adapter boundary. Preserve business meaning when mapping failures; do not turn every error into an indistinguishable success or generic failure.
- Port contracts should state semantics the use case relies on: absence versus failure, ordering, atomicity, duplicate handling, or consistency where relevant. Do not demand guarantees when no consumer needs them.
- Avoid requiring duplicate DTOs or a mapper at every boundary. Shared types are acceptable when they express business concepts without forcing transport or storage concerns into the core.

### Business policy and use cases

- Locate business decisions and invariant enforcement. Controllers, consumers, SQL, and persistence hooks may hide rules that other entry points can bypass.
- Separate transport validation and conversion from business validation. A required JSON field belongs to the transport contract; whether an order can be cancelled belongs to business policy.
- Application services may coordinate repositories, transactions, authorization policy, and external actions. Domain objects need not own all behavior; assess the project's domain model and whether invariants remain consistently enforced.
- Check alternate entry points for missing policy checks or duplicated rules that can diverge. Transport authentication may live at the edge, while business authorization must hold for every relevant use case.

### Side effects and consistency

- Check whether transaction and unit-of-work boundaries match the use case's atomicity requirements. A transaction annotation alone does not establish a violation; inspect the coupling and behavior it introduces.
- Where a use case combines persistence with messaging or remote effects, trace partial failure, retries, and duplicate delivery. Report an inconsistency only with a concrete failure scenario or an unsupported guarantee.
- Consider ports for time, randomness, identifiers, and external state when their control matters to business behavior or deterministic tests. Do not require an abstraction around every standard-library call.

### Testability and enforcement

- Determine whether important use cases can be exercised with in-memory substitutes for outbound dependencies, without starting a web server or database. Missing isolated tests are a confidence gap; concrete inability to isolate a use case may reveal a boundary problem.
- Inspect whether adapter integration tests verify translation and actual external behavior. In-memory fakes alone cannot establish that a persistence or remote adapter satisfies its port contract.
- Look for existing module visibility rules, dependency checks, or architecture tests. Recommend focused enforcement for demonstrated recurring violations; do not add tooling or dependencies during a review.

## Avoid false positives

- Distinguish dependency inversion from runtime call direction. Do not flag the expected path from use case through outbound port to adapter.
- Do not require a fixed number of layers, one interface per class, one adapter per port, separate build modules, CQRS, event sourcing, microservices, or a rich domain model.
- Framework annotations, ORM-mapped domain entities, and shared models are tradeoffs to assess against stated isolation goals and actual coupling. An annotation can violate an explicit dependency rule, but its presence alone does not prove a runtime defect or justify a major rewrite.
- Do not label generic performance, style, or security issues as hexagonal violations unless a boundary decision causes them. Mention independently serious issues separately when appropriate to the requested scope.
- If a conclusion depends on a framework or library's exact behavior, verify the project's version and consult current authoritative documentation, using Context7 when available. Architectural reasoning alone does not require library lookups.

## Deliver the review

Lead with findings ordered by impact. For each finding, provide:

- **Location:** a precise file and line, symbol, or design section; cite both ends of a dependency when useful.
- **Evidence:** the observed dependency or execution path and the boundary it crosses.
- **Consequence:** a concrete failure, bypassed invariant, testing constraint, or change-coupling cost. State the trigger and avoid hypothetical impact presented as proven fact.
- **Correction:** the smallest practical boundary change, preserving behavior and local conventions.
- **Verification:** a focused test, dependency check, or inspection that would demonstrate the correction.

Use severity proportional to demonstrated impact: high for violated critical invariants or consistency guarantees; medium for concrete boundary coupling or duplicated policy with material consequences; low for localized maintainability costs. Keep optional redesigns and accepted tradeoffs separate from defects.

Include a brief architecture map and scope/validation notes after the findings. Distinguish inspected evidence, assumptions, and unresolved questions. If there are no supported findings, say so and identify material coverage gaps; do not manufacture issues or claim that the whole architecture is proven correct. For a design-only review, label findings as design risks and propose checks rather than implying implementation evidence.

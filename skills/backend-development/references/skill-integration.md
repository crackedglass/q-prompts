# Companion skill routing

`backend-development` coordinates delivery and owns acceptance. Companion skills provide focused methods inside its existing roles; they do not add workers, approval gates or permission to modify external systems. Select them from the actual change scope rather than loading the entire skill collection.

## Resolve and load

Use the host's available-skill catalog to find each selected `SKILL.md`. In this store, the links below point to sibling skill directories. Install companion directories alongside this skill when packaging a selection; copying `backend-development` alone does not bundle them. If a sibling link is unavailable after installation, resolve the skill by name from the host catalog rather than assuming a home-directory path.

Read the selected entrypoint and only the supporting files relevant to the assigned task. Pass accessible paths to workers so they can read the same guidance. Record skill paths/versions or file digests where available, selected sections and applicability in the dispatch envelope and returned scope. Loading guidance does not count as a passed review or executed check.

## Role map

| Companion | When to load | Roles and use |
| --- | --- | --- |
| [hexagonal-architecture-review](../../hexagonal-architecture-review/SKILL.md) | Required for design and code architecture reviews | Architecture reviewer: map actual boundaries, trace representative flows, inspect port ownership and technology leakage. Architect and implementer may consult it when a boundary decision needs clarification; this does not replace review. |
| [cloud-design-patterns](../../cloud-design-patterns/SKILL.md) | The change designs, implements or reviews distributed failure, retries, caching, messaging, backpressure or rollout behavior | Architect and implementer: read only relevant pattern references and justify the chosen mechanism. Architecture, performance, security or database reviewers: evaluate applicable tradeoffs within their assigned remit. Do not infer a cloud provider, broker, CQRS or microservices requirement. |
| [rust-sqlx](../../rust-sqlx/SKILL.md) | SQLx queries, mappings, transactions, migrations, pool settings or offline metadata are affected | Implementer: use relevant query/migration patterns. Database reviewer: inspect SQLx/schema consistency and atomicity. Verifier: select project-appropriate compilation, offline-metadata and isolated database checks. Reviewers recommend checks; the verifier executes them. |
| [postgresql-code-review](../../postgresql-code-review/SKILL.md) | PostgreSQL SQL, schema, indexes, constraints, privileges, RLS or persistence behavior are affected | Database reviewer: inspect affected PostgreSQL behavior in design/code. Security and performance reviewers may consult relevant sections for tenant isolation or query paths, keeping findings in their existing roles. Redis-only changes still require the database role when applicable, without automatically loading PostgreSQL guidance. |
| [rust-backend](../../rust-backend/SKILL.md) | The target is the Windmill backend and the changed files fall within its scope | Implementer: follow Windmill conventions. Reviewers/verifier consult affected rules as needed. A directory named `backend` in another project does not qualify; do not introduce `windmill_common` or Windmill conventions there. |

For SQLx, do not interpret pool guidance as forbidding transaction-scoped connections or force reversible destructive migrations. Preserve a use case's atomicity and deployed migration history. For PostgreSQL, treat feature/index examples as candidates: establish operator compatibility, null semantics, tenancy and workload needs before recommending them. Neither skill requires new ENUMs, extensions or indexes simply because they appear in an example.

## Missing skills and conflicts

If `hexagonal-architecture-review` cannot be loaded, use the architecture prompt's explicit checklist for a provisional review and report the missing required dependency; the architecture gate remains unfulfilled. For other applicable companions, report unavailability and use repository guidance plus current authoritative documentation for exact APIs. If that leaves required evidence or a material decision unresolved, return partial or waiting status rather than claiming acceptance. Do not automatically install skills or expand tool permissions.

Preserve user scope, repository decisions and pinned versions. Surface material conflicts between companion advice and the design to the coordinator with a concrete consequence; do not silently change the contract. All companion use inherits the role's write restrictions, shared budget and prohibition on recursive delegation.

## Boundaries with the rest of this store

- **agent-architecture** designs or audits the AI agent itself. Use it for an explicitly requested change to agent architecture, not for the application architecture role.
- **create-spring-boot-java-project**, **openapi-to-application-java-spring-boot**, **java-springboot** and other **java-*** skills serve Java tasks. If the requested backend is Java, route to the relevant Java skill instead of applying this Rust workflow or translating its stack implicitly. Reuse **hexagonal-architecture-review**, **cloud-design-patterns** and **postgresql-code-review** there when applicable.
- **web-design-reviewer** and **optimizing-performance** (`frontend-performance-optimization/`) address frontend work. Do not use frontend performance guidance as the backend performance review method.

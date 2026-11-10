# Subagent graph

Solid arrows show work/artifact handoffs; dotted arrows show feedback. The coordinator owns integration. Review roles run in separate contexts when supported and share one frozen snapshot, without write access. The upstream agent is an external producer, not a child of this skill.

```mermaid
flowchart TD
    U[Upstream API agent: OpenAPI + business description] --> C[Coordinator: intake, budgets, integration]
    C --> A[Architect: OpenSpec proposal, specs, design, tasks]
    A --> D{Design review batch}
    D --> AR[Architecture reviewer: hexagonal skill]
    D --> SR[Security reviewer]
    D --> PR[Performance reviewer]
    D --> DB[Database reviewer: when applicable]
    AR --> G{Coordinator: design findings resolved?}
    SR --> G
    PR --> G
    DB --> G
    G -. bounded design corrections .-> A
    G --> I[Implementer: approved design, code and tests]
    I --> R{Code review batch: same review roles}
    R --> H{Coordinator: findings resolved?}
    H -. bounded remediation .-> I
    H --> V[Verifier: isolated checks + evidence freshness]
    V -. failed checks within remaining budget .-> I
    V --> F[Coordinator: verified or partial handback]
    C --> W[Human decision: only unresolved semantics or required approval]
    W -. explicit resolution .-> C
```

Gate-to-implementation and gate-to-verification edges require successful mandatory verdicts. Any stage may stop with partial output, a decision request or failed verification. The coordinator reroutes changed designs to design review. A database review marked not applicable requires an explicit scope reason, so its absence cannot silently bypass the batch.

| Role | Prompt | Writable artifacts |
| --- | --- | --- |
| Architect | [architect.md](prompts/architect.md) | Assigned OpenSpec change |
| Implementer | [implementer.md](prompts/implementer.md) | Assigned source, tests, migrations |
| Architecture reviewer | [architecture-reviewer.md](prompts/architecture-reviewer.md) | Findings only |
| Security reviewer | [security-reviewer.md](prompts/security-reviewer.md) | Findings only |
| Performance reviewer | [performance-reviewer.md](prompts/performance-reviewer.md) | Findings only |
| Database reviewer | [database-reviewer.md](prompts/database-reviewer.md) | Findings only |
| Verifier | [verifier.md](prompts/verifier.md) | Check outputs/evidence only |

For each dispatch use `delegation.md` + the role prompt + a populated task envelope. Role prompts alone do not carry task-specific permissions or inputs.

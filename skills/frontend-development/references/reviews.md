# Required frontend reviews

Perform all three passes for each scoped change. At design time identify prospective risks and acceptance checks. At code review inspect the exact candidate and affected call paths, then produce evidence-backed findings or a scoped verdict. Use the finding/evidence rules in [contracts](contracts.md). A reviewer procedure is not a separate autonomous agent and does not prove independent judgment.

## Code review

Trace each acceptance scenario through components, state, API adapter and user-visible result. Examine:

- TypeScript null/optional handling, unsafe casts and assumptions about runtime response data; parameters, status codes and errors against the scoped OpenAPI operations.
- Server/form/navigation/derived state ownership, effect dependencies and cleanup, stale async updates, list keys, event handling and component responsibilities. Reuse the project's query/router abstractions instead of adding ad hoc fetching.
- Supplied design fidelity, responsive layouts, semantic controls, keyboard navigation, focus after state changes, accessible labels, form validation and loading/empty/error states.
- Secret exposure, unsafe HTML/URLs and client authorization assumptions, with targeted checks where relevant. Client-side validation does not replace server validation or permissions.
- Observable behavior coverage and meaningful negative cases. Avoid implementation-mirroring tests and unrelated refactors.

Run applicable project type/lint checks and unit/component/browser tests. Inspect relevant code beyond changed lines. When layout/browser evidence is unavailable, record the precise unverified interactions; source inspection is not visual verification. Close a finding with the correction and a check showing its triggering behavior no longer fails.

## Performance review

Identify the critical screen/action, expected data volume, existing budget and realistic device/network/cache assumptions. Use the production build, comparable baseline and same measurement conditions. Inspect initial JS/CSS, lazy chunks and dependency duplication, asset dimensions, request waterfalls, avoidable requests, large-list work, render cost, layout shifts and interaction responsiveness.

Measure a reproducible problem before introducing memoization or architectural complexity. Code splitting should reflect usage and include loading/recovery behavior. Report compressed sizes with compression method, browser/tool versions, scenario, sample count, cache state and baseline. Apply project thresholds; if absent, report measurements/regressions and propose a budget rather than inventing a pass criterion. Distinguish local lab results from field Web Vitals. Avoid one noisy run as proof of an optimization.

Example finding: optional editor is included in the initial chunk and exceeds the project's established initial-JS budget. Close using comparable production build measurements plus a browser check of the deferred interaction. If workload or baseline is missing, report that limit rather than claiming an SLO passed.

## Reliability review

Map failures at API request, state update, rendering and asset/serving boundaries. Select relevant cases and record exclusions:

- Slow, canceled and out-of-order responses; unmount/navigation during async work; offline and timeout; 401/403, validation errors, 429/5xx; malformed/partial payloads and genuine empty results.
- Double submissions, stale state/cache, form preservation, transitions during save, uncertain mutation outcomes, bounded retries and recovery status.
- Component crashes, lazy-chunk failures, old HTML referencing removed assets, wrong base path, missing public configuration, deep-link fallback and relevant browser differences.

Check that stale work cannot update current state; abort alone may not cover later async processing. Verify request identity/ignore handling as needed by the existing data-fetching abstraction. Retry only when allowed by operation semantics and bounded by project policy. A disabled submit button is not downstream idempotency.

For uncertain mutations follow [contracts](contracts.md): preserve outcome-unknown, reconcile safely, and avoid blind replay. A timeout does not establish rejection. Product recovery text and navigation must match accepted behavior; missing material UX becomes a design decision.

Serve and smoke-test the production bundle using the configured base path and public configuration. Confirm asset URLs and route fallback. Inspect whether hosting cache/asset-retention policy supports clients holding older HTML. Chunk recovery must be bounded and preserve unsaved work; avoid reload loops. If hosting changes lie outside scope, hand off the exact requirement and mark that release check unverified.

## Final admission

Record three verdicts covering the final candidate. A static review does not replace required execution. Resolve critical/high defects and blocking decisions; lower findings require correction or explicit authorized disposition. If a required environment/check is unavailable, deliver partial with useful evidence and next action. Never relabel unknown as pass to complete the loop.

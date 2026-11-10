# Worked delivery examples

These are synthetic examples of decisions and handbacks, not features to add to every project.

## Supplied orders list

Input FE-24/I1 pins OpenAPI S4, story U8 and design D6. `listOrders` supports page/pageSize and returns items/total. U8 and D6 define desktop/mobile pagination plus loading, empty and error/retry states.

Map `U8 → orders screen/page action → UI states → listOrders → A1–A5`. The OpenSpec change defines state ownership, API adapter, focus behavior and verification tasks. Implement a slice using the existing query/router abstractions. Tests distinguish empty from failure and exercise page changes.

Code review of C1 finds focus remains in removed content after paging. Repair to the accepted design as C2. Rerun affected interactions and final type/build checks; invalidate C1 review evidence. Performance review records production bundle B2 with baseline and measurement settings. Reliability review delays page 2 until after page 3 and verifies page 3 remains current. Final evidence binds S4/U8/D6, OpenSpec artifacts, C2/B2 and three review verdicts.

Hand back verified-within-scope only for the checks actually passed. Missing field performance data is an explicit limitation, not a fabricated Web Vitals claim.

## UI/API conflict

Design D7 adds a server-wide status filter, but S4 has no filter parameter. Ask the product/API owners to choose: extend the API contract; defer/remove the interaction; or explicitly accept filtering of only the loaded page with truthful labeling. Do not silently filter one page while presenting global results.

Record the affected input revisions and decision. Continue unrelated work. On revised input I2, update OpenSpec and invalidate affected mapping/tests/reviews before implementing the selected behavior.

## Lost save response

`createOrder` is a non-idempotent POST without a documented deduplication/reconciliation contract. In a test, the server commits but the response is lost. Reliability review finds the client automatically repeats the request.

Record high finding RR-4 and operation effect-unknown. Preserve form values and follow accepted UX for uncertainty. Do not retry because a subsequent list read shows no item; indexing or visibility may lag. Request an API contract with authoritative reconciliation/idempotency or an accepted manual-resolution UX. While pending, checkpoint findings, trace, input/code identities, remaining budget and next action; return waiting-for-decision.

If a new contract defines an idempotency key, retention and equivalent-request semantics, revise OpenSpec and test duplicate/lost-response cases against that contract before closing RR-4. A local mock is useful but cannot prove the real service's guarantee.

## Resume with changed code

A checkpoint records C2 as reviewed, but a new session finds user edits C3 and one missing browser result. Inspect the diff and preserve the edits. Reconcile ownership and scope; rerun affected reviews/checks against C3. Keep earlier spending and uncertain operations. Do not infer completion from task checkboxes or reuse C2 passes automatically. If essential browser tooling remains unavailable, return partial and name the missing scenario.

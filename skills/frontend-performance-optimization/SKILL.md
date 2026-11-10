---
name: optimizing-performance
description: |
  Frontend performance optimization with data-driven approach. Triggers: performance, slow, optimization, rendering, bundle size, Web Vitals, LCP, FID, CLS, re-rendering, memoization, useMemo, useCallback, React.memo, heavy, speed up, lazy loading, code splitting
allowed-tools: Read, Grep, Glob, Task, mcp__chrome-devtools__*, mcp__mdn__*
metadata:
  mcpmarket-version: 1.0.0
---
# Performance Optimization

## Purpose

Data-driven frontend optimization. **"Measure before optimizing"** - Donald Knuth

## Section-Based Loading

| Section | File | Focus | Load When |
|---------|------|-------|-----------|
| Web Vitals | `references/web-vitals.md` | LCP, FID, CLS | Loading speed, layout shifts |
| React | `references/react-optimization.md` | memo, useMemo, useCallback | Re-renders |
| Bundle | `references/bundle-optimization.md` | Code splitting, tree shaking | Bundle size |

## Core Web Vitals Targets

| Metric | Target | What It Measures |
|--------|--------|------------------|
| LCP | <2.5s | Largest Contentful Paint |
| FID | <100ms | First Input Delay |
| CLS | <0.1 | Cumulative Layout Shift |

## Optimization Workflow

```
- [ ] 1. Measure current performance (Lighthouse/DevTools)
- [ ] 2. Identify bottlenecks (Network/Performance tab)
- [ ] 3. Prioritize (impact vs. effort)
- [ ] 4. Implement improvements (one change at a time)
- [ ] 5. Measure again and compare
```

## Priority Order

1. **Measure First** - Lighthouse, Chrome DevTools
2. **User-Centric Metrics** - Focus on Web Vitals
3. **Progressive Enhancement** - Optimize based on data
4. **Avoid Premature Optimization** - Only optimize problem areas

## References

- [@./references/web-vitals.md](./references/web-vitals.md) - LCP, FID, CLS optimization
- [@./references/react-optimization.md](./references/react-optimization.md) - memo, useMemo, useCallback
- [@./references/bundle-optimization.md](./references/bundle-optimization.md) - Code splitting, tree shaking

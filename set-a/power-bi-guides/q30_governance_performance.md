# Q30 Governance and Performance Optimization
## 1. Slow report causes and fixes
| Area | Problem | Fix |
|---|---|---|
| Model | Wide flat tables, many columns, high-cardinality columns, bi-directional filters, many-to-many | Star schema, remove unused columns, reduce cardinality (split datetime), single-direction one-to-many, correct data types |
| Power Query | Steps that break query folding, loading unneeded rows | Filter early, push to source, native SQL/views, disable load for staging queries, incremental refresh |
| DAX | Nested iterators, FILTER on whole table, repeated logic | Use measures with variables (VAR), `CALCULATE` with column filters instead of FILTER(table), DIVIDE, avoid calculated columns that can be measures |
| Visuals | 20+ visuals per page, big tables, cross-highlighting | Limit visuals, Top N filters, apply "Apply" buttons for slicers, turn off unnecessary interactions |
Tools: Performance Analyzer (View), DAX Studio, VertiPaq Analyzer, Query diagnostics.
## 2. Workspace and sharing practices
Separate workspaces per domain (Banking, Healthcare) and per stage; limit Admin/Member roles, give Viewer for consumers; share via Apps rather than workspace access; certified/promoted datasets; shared semantic models (one dataset, many reports); sensitivity labels; avoid personal workspace sharing.
## 3. Governance strategy
- **Security**: Entra ID groups, RLS/OLS, sensitivity labels, disable export where needed, tenant settings, MFA.
- **Performance**: model standards, Performance Analyzer review before publish, capacity monitoring (Fabric Capacity Metrics app).
- **Refresh**: scheduled off-peak refresh, gateway cluster for HA, failure alerts, incremental refresh.
- **Data ownership**: named dataset owner and steward per domain, endorsement (Promoted/Certified), data catalogue and lineage view.
- **Controlled distribution**: deployment pipelines Dev>Test>Prod, Apps for distribution, review/approval before certification, audit log (Purview), periodic cleanup of unused reports (usage metrics).

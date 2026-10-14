# Q26 Scheduled Banking Data Refresh
1. For SQL Server on-premises, install the **on-premises data gateway** (standard mode) on a machine that can reach the server; sign in and register.
2. Service > workspace > Semantic model > **Settings** > Gateway and cloud connections > map the data source to the gateway, enter credentials (Windows/Basic), test connection.
3. **Scheduled refresh**: toggle On, Frequency Daily, add time slots (e.g. 06:00, 18:00; Pro max 8/day, Premium 48), time zone, tick "Send refresh failure notifications to dataset owner".
4. **Verify**: Settings > Refresh history, or workspace > Refresh now. Status Completed / Failed with error.
5. **Troubleshooting**: credentials expired (re-enter), gateway offline (restart service), source server/firewall issue, privacy-level / Formula.Firewall error (set privacy levels to Organizational), schema change (column renamed in source), query timeout (use incremental refresh or reduce data), dataset size limit.

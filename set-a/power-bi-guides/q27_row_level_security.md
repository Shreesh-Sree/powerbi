# Q27 Row-Level Security for Hospital Managers
1. Desktop: Modeling > **Manage roles** > Create. Roles: `North Manager`, `South Manager`, `East Manager`, `West Manager`.
2. DAX filter on the Region (or Patient/Department dimension) table:
```dax
[Region] = "North"          -- role North Manager
[Region] = "South"          -- role South Manager
```
Dynamic version (one role for all): `[ManagerEmail] = USERPRINCIPALNAME()`.
3. **Test**: Modeling > View as > select role (and optionally Other user) > confirm only that region's patients and revenue show, totals change.
4. Publish, then Service > Semantic model > **Security** > add each manager's email/group to the right role. Test again with "Test as role". Note: users with Admin/Member/Contributor workspace roles bypass RLS, so give managers Viewer or share via App.

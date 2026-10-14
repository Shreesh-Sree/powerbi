# Q27 Row-Level Security for Regional Managers
Modeling > Manage roles: `East`, `West`, `North`, `South` with filter on Customer[Region] e.g. `[Region] = "South"`. Dynamic alternative: `[ManagerEmail] = USERPRINCIPALNAME()`.
Test via View as roles. Publish, Service > Semantic model > Security > add users to roles; test again. Workspace Admin/Member/Contributor bypass RLS (use Viewer).

# Q29 Deployment Pipeline Dev to Test to Prod
Requires Premium / PPU / Fabric capacity workspaces.
1. Service > **Deployment pipelines** > Create pipeline `Healthcare Pipeline`. Assign workspace `HC-Dev` to the Development stage (Test and Prod workspaces are created automatically on deploy).
2. **Deploy** Dev > Test (select content, deploy). Then Test > Production.
3. **Deployment rules** (stage settings): change data source server/database and parameters per stage (dev DB vs prod DB).
4. **Verify after each stage**: open the report, check visuals load, relationships in the model (Model view), measures return expected values, refresh dataset, compare Dev vs Test with the pipeline's "compare" indicator (green = in sync). Only then promote.

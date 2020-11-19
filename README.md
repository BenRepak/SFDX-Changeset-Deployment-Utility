# SFDX Changeset Validation and Deploy Script

A shell script to validate and deploy changesets between orgs. 

Taken from: https://medium.com/@idanblich/automate-changeset-actions-using-sfdx-salesforce-fbe7bfe4e411 

## How to use
1. Clone project locally: `git clone https://github.com/BenRepak/SFDX-Changeset-Deployment-Utility.git`
2. Authenticate source and destination orgs in SFDX
3. Find Change Set Name in source org (recommend a name without spaces)
4. Update the following lines in ./scripts/run.sh
  - line 13–14: Add your SFDX alias or User Names
  - line 17: Change the Change Set name: Must be Unique Name
  - line 25: you need to specify only 1 option for the list
  - Line 38: -c = check only flag, remove it in order to actually deploy



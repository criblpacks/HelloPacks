# HelloPacks with GitHub Actions
----
This is a fork of the original HelloPacks pack and contains a directory .github/workflows which automates the installation of a pack across worker groups and workspaces. The idea behind this workflow is to trigger a fresh install of a pack when dev merges to test and when test merges to main. Each merge triggers the distribution of the latest pack to your destination Cribl Workspace/Worker Group.  

## Requirements
----
Before you begin, ensure that you have met the following requirements:

* Stream +4.0

## Github workflow setup
----

This packaged workflow relies on Github Actions and the Secrets/Variables within it. In future releases there will be versions for GitLab and Bitbucket but today this template 
has only been tested on Github. 

* In the Cribl Cloud console generate a Client ID and Client Secret. 
* If using a private repository in Github, generate a Github Personal Access token. This allows Cribl to pull from the private Git repository.
* In the HelloPacks Github Repository, navigate to Settings> Secrets & variables> Actions> 
	* Set the following Secrets: CRIBL_CLIENT_ID, CRIBL_CLIENT_SECRET, REPO_PERSONAL_ACCESS_TOKEN(if using a private repo)
	* Set the following Variables: TEST_ENDPOINT, PROD_ENDPOINT example format **https://**<instance_id>**/api/v1/m** -ensure you use https and do not include trailing /
## Using The Pack's Github workflow
----
#### Push to Dev: 
* A developer commits and pushes changes to the dev branch in GitHub.
#### Merge to Test: 
* Developer merges dev to test via a push or pull request which triggers the pack to be distributed to multiple worker groups on the TEST_ENDPOINT
#### Merge to Prod: 
* After final checks are confirmed within the test environment worker groups, a push or pull request will merge the test branch into main triggering the  deployment of the Pack to the PROD_ENDPOINT environment’s worker groups.
* Each of these behavior's trigger actions can be modified and tuned accordingly. 


## Learn More 
----
To get started creating your own packs and exporting them across your Stream deployment check out the [Packs Documentation](https://docs.cribl.io/docs/packs).


## Release Notes
----
### Version 1.1.0 - 2025-03-15
HelloPacks with Github actions automation. 

### Version 1.0.0 - 2021-05-18
First version. 

## Contact
----
Join us in our [community](https://cribl.io/community/). We've goat you covered!

## Credits
----
Made with ♡ by the Engineering Team @Cribl - 2021

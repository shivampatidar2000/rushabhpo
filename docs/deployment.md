# Overview

Application code will be branched on the basis on fixes and features, not on environments, i.e. build on artefact, deploy it to many places.


[Workflow diagram](https://miro.com/app/board/o9J_koCvl7E=/)

### High level operation

1. Human readable version numbers are created at container build, e.g. 0.0.3
   - The git tag is associated with the commit that triggered the build, the container created is tagged with the matching number/tag.
   - The helm chart app version is also assocated with the same number/tag.
2. Deploys to stage or production are triggered by annotating the desired tag with 'stage' or 'prod'.
   - e.g. annotating tag 0.2.1 with stage will trigger the stage deployment job.
   - The [deploy.sh](../tools/deploy.sh) script is provided to aid with this operation.
   - e.g. `deploy.sh stage 0.0.2`

#### Examples

##### 1. Trigger deployment

Check version tags available :

```bash
project-34567-ruby$ git tag | sort -V
1.0.0
1.0.1
1.0.2
1.0.3
1.0.4
1.0.5
```

```bash
project-34567-ruby$ ./tools/deploy.sh stage 1.0.4
```  
This will deploy an existing container with the tag 1.0.4 to the stage cluster.  

* Check the GitlabCI job for progress
* Check your application logs in grafana

##### 2. Check tags flagged for deployment

```bash
project-34567-ruby$ ./tools/deploy.sh list
Fetching origin

production 0.0.82
```  

**Note**  
The flags are removed once the deployment has successfully completed.  The command will show now results in this scenario.  
Check your CI job for the status of a recently triggered deployment.  

##### 3. Remove a version tagged for deploy

```bash
project-34567-ruby$ ./tools/deploy.sh  reset  0.0.82
Fetching origin

Updated tag '0.0.82' (was f36f358)
Enumerating objects: 1, done.
Counting objects: 100% (1/1), done.
Writing objects: 100% (1/1), 158 bytes | 39.00 KiB/s, done.
Total 1 (delta 0), reused 0 (delta 0)
To gitlab.builder.ai:devops/project-34567-ruby.git
 + f36f358...242bfaf 0.0.82 -> 0.0.82 (forced update)
```  

### Deploying to Managed Platform

The deployment in Managed Platform is currently linked to the `managed-platform` branch of my fork of the `developers.redhat.com`
Git repository. So at the minute you'll need a local copy of my repo to follow these steps.

**NOTE**: It's this way currently to support quick development on my part without concern about breaking things for other people. At
some point this will all be consolidated back to the main repo.

This structure _may_ also change once the pipeline work starts on MP.

#### Where is everything:

* Openshift Templates are in this directory. The ones of interest are:
    * [drupal-services.yml](drupal-services.yml)
    * [drupal-statefulset.yml](drupal-statefulset.yml)
* The Ansible Playbooks for bootstrapping a deployment are [here](../_docker/drupal/ansible)
* Everything that goes into Drupal can be found [here](../_docker/drupal)


#### Deploying to Managed Platform

This is a manual process for now, but hopefully we'll automate this once we get into Pipeline phase on MP:

##### Add my repo as an origin to your fork

```bash
> git remote add rb https://github.com/robpblake/developers.redhat.com.git
> git fetch rb
> git checkout --track rb/managed-platform
```

##### Login to the correct MP cluster: 

```
> oc login paas.dev.redhat.com -u <your_username>
> oc project rhdp--prototype
```

##### Build a new version of the Drupal Docker Image:

To deploy any new changes in the `managed-platform` branch, then first build a new version of the Drupal Docker image

```bash
> oc start-build drupal-docker-image
```

This will build a new Drupal Docker images from the latest version of this `managed-platform` branch. The builds on MP are
slow, but eventually your new build will be pushed to `registry.paas.redhat.com/rhdp/rhdp-drupal:latest`.


#### Deploy a new version of Drupal

To deploy a new version of Drupal, decide on a new deployment ID. Easiest way to do this currently is to see what the
latest deployment was and add one:

```bash
> oc get statefulset

> Robs-Mac-mini:developers.redhat.com Rob$ oc get statefulset
NAME                  DESIRED   CURRENT   AGE
drupal-deployment-8   3         3         2d
drupal-deployment-9   3         3         15h
 ```
 
So in this case, my deployment id will be `10`.

Then just process the openshift templates:

```bash
oc process -f drupal-services.yml DEPLOYMENT_ID=10 | oc create -f -
oc process -f drupal-statefulset.yml DEPLOYMENT_ID=10 | oc create -f -
``` 
(We can probably consolidate this into one template)

This will create the new deployment for you. You can track progress of the deployment using the [Openshift Console](https://paas.dev.redhat.com/console/project/rhdp--prototype/browse/stateful-sets/). 

Once the `StatefulSet` is deployed, then you just need to update the route into the cluster to point to your new deployment. You
can either do that via the Console, or use `oc patch` from the command line to do that:

```bash
oc patch route/current -p '{\"spec\":{\"to\":{\"name\":"drupal-https-$DEPLOYMENT_ID"}}}'
```

Replace `$DEPLOYMENT_ID` in the above with your deployment id.

That's it.

#### Making changes

To make changes, simply raise a PR on my `managed-platform` branch and I will merge that for you. Then just repeat the
above process to get your changes deployed to MP.


### Debugging

Debugging on MP can be a bit of a challenge, but the following generally works:

##### To see log output from the Drupal Server once it's running:

```bash
oc logs -f drupal-deployment-9-0
```

This will get you the logs of pod `0` within deployment `9`. Just change the pod number to see the others.


##### To debug init containers:

```bash
oc logs -f drupal-deployment-9-0 -c rhdp-data-seed
oc logs -f drupal-deployment-9-0 -c rhdp-boostrap-env
oc logs -f drupal-deployment-9-0 -c rhdp-boostrap-drupal
```

Again change the pod numbers to match your deployment id.   
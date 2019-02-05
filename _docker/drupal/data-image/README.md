### Drupal Data Image Builder

This project contains a Jenkins Pipeline definition and `docker-compose` definition to allow us to build and push the 
data images used by `dev` and `pr` environments to have a prod-like data experience.

This project is triggered by deployments on Managed Platform. Each time a successful deployment is made into production, this
pipeline will be triggered. It will pull the image of Drupal that has just been deployed onto Managed Platform an instantiate an
instance of it locally. It will then create a backup of that Drupal instance, build the data images from that backup and then
push the resulting images to `docker-registry.engineering.redhat.com`

The image of Drupal to be used is passed as a build parameter to this job. Please note that this is expected to be a SHA256 image reference
and not simply a tag.

The `docker-compose.yml` file in this directory uses the Ansible playbooks for Drupal to bootstrap a Drupal environment using
a particular version of the Drupal Docker Image deployed to Managed Platform.

This job is mapped in Jenkins [here](https://redhat-dev-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/job/Data_Image_MP/). 
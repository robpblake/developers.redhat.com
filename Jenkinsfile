def currentDeploymentId = null
def previousDeploymentId = null
def deploymentId = null

node {
   timeout(30) {

        stage("Record Deployment") {
           openshift.withCluster() {
               openshift.withProject() {
                   def configMap = openshift.selector('configmap/drupal-deployments').object()
                   currentDeploymentId = configMap.data['CURRENT_DEPLOYMENT'].toInteger()
                   previousDeploymentId = configMap.data['PREVIOUS_DEPLOYMENT'].toInteger()
                   deploymentId = configMap.data['NEXT_DEPLOYMENT'].toInteger() + 1
                   echo "The id of this deployment will be '${deploymentId}'."

                   configMap.data['NEXT_DEPLOYMENT'] = "${deploymentId}"
                   openshift.apply(configMap)
               }
           }
        }

        stage('Build Docker Image') {
            echo "Building the Docker image for this deployment. Image will be tagged as 'redhatdeveloper/rhdp-drupal:${deploymentId}'..."
                openshift.withCluster() {
                    openshift.withProject() {
                        def buildConfig = openshift.create(openshift.process(readFile(file:'openshift/docker-image-buid.yml')),'-p', "DEPLOYMENT_ID=${deploymentId}"))
                        def build = buildConfig.startBuild()
                        build.untilEach(1) {
                            echo "Waiting for build of Docker Image 'redhatdeveloper/rhdp-drupal:${deploymentId} to complete..."
                            sleep 10
                            return (it.object().status.phase == 'Complete')
                        }

                    }
                }
        }

        stage('Bootstrap Deployment') {
            echo "Bootstrapping the environment for deployment '${deploymentId}'..."
            openshift.withCluster() {
                openshift.withProject() {
                    def deployJob = openshift.create(openshift.process(readFile(file:'openshift/drupal-deployment-job.yml')),'-p', "DEPLOYMENT_ID=${deploymentId}"))
                    waitUntil() {
                        echo "Waiting for the completion of job 'drupal-deployment-job-${deploymentId}. This may take some time..."
                        sleep 15
                        openshift.raw("get job drupal-deployment-job-${deploymentId} -o jsonpath='{.status.conditions[?(@.type==\"Complete\")].status}'").out.toString().trim().toBoolean()
                    }
                }
            }
        }

        stage('Deploy Drupal') {
            echo "Deploying Drupal for deployment '${deploymentId}'..."
            openshift.withCluster() {
                openshift.withProject() {
                def deploymentConfig = openshift.create(openshift.process(readFile(file:'openshift/drupal-deployment-config')), '-p', "DEPLOYMENT_ID=${deploymentId}"));
                   deploymentConfig.rollout().status()
                }
            }
        }

        stage("Expose Endpoint") {
            echo "Exposing HTTP endpoint for Drupal deployment '${deploymentId}..."
            openshift.withCluster() {
                openshift.withProject() {
                    /*
                        This should be using openshift.verifyService(), but it's not in the plugin version installed here.
                    */
                    openshift.create(openshift.process(readFile(file:'openshift/drupal-http-service.yml')), '-p', "DEPLOYMENT_ID=${deploymentId}"));
                }
            }
        }


        stage("Update 'next' route") {
            openshift.withCluster() {
               openshift.withProject() {
                   def nextServiceName = "drupal-http-${deploymentId}"
                   echo "Updating 'next' route to send traffic to service '${nextServiceName}'.."
                   openshift.raw("patch route/next -p '{\"spec\":{\"to\":{\"name\":\"${nextServiceName}\"}}}'")
               }
            }
        }

        stage("Acceptance Tests") {
            echo "Here we run acceptance tests!"
        }

        stage("Promote To Live") {
            openshift.withCluster() {
                openshift.withProject() {

                    def previousServiceName = "drupal-http-${currentDeploymentId}"
                    def currentServiceName = "drupal-http-${deploymentId}"

                    def configMap = openshift.selector('configmap/drupal-deployments').object()
                    configMap.data['PREVIOUS_DEPLOYMENT'] = "${currentDeploymentId}"
                    configMap.data['CURRENT_DEPLOYMENT'] = "${deploymentId}"
                    openshift.apply(configMap)


                    echo "Updating 'previous' route to send traffic to service '${previousServiceName}'.."
                    openshift.raw("patch route/previous -p '{\"spec\":{\"to\":{\"name\":\"${previousServiceName}\"}}}'")

                    echo "Updating 'current' route to send traffic to service '${currentServiceName}'.."
                    openshift.raw("patch route/current -p '{\"spec\":{\"to\":{\"name\":\"${currentServiceName}\"}}}'")
                }
            }
        }
   }
}
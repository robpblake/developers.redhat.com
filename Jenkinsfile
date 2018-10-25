node {
   def deploymentId = "${env.BUILD_ID}"
   timeout(30) {

        stage('Build Docker Image') {
                openshift.withCluster() {
                    openshift.withProject() {
                        def buildConfig = openshift.create(openshift.process('drupal-docker-image-build','-p', "DEPLOYMENT_ID=${deploymentId}"))
                        def build = buildConfig.startBuild()
                        build.untilEach(1) {
                            echo "Waiting for build of Docker Image 'redhatdeveloper/rhdp-drupal:${deploymentId} to complete..."
                            sleep 10
                            return (it.object().status.phase == 'Complete')
                        }

                    }
                }
        }

        stage('Bootstrap the deployment') {
            echo "Bootstrapping the environment for deployment '${deploymentId}'..."
            openshift.withCluster() {
                openshift.withProject() {
                    def deployJob = openshift.create(openshift.process('drupal-deploy-job','-p', "DEPLOYMENT_ID=${deploymentId}"))
                    waitUntil() {
                        echo "Waiting for the completion of job 'drupal-deploy-job-${deploymentId}. This may take some time..."
                        sleep 15
                        openshift.raw("get job drupal-deploy-job-${deploymentId} -o jsonpath='{.status.conditions[?(@.type==\"Complete\")].status}'").out.toString().trim().toBoolean()
                    }
                }
            }
        }

        stage('Deploy Drupal') {
            echo "Deploying Drupal for deployment '${deploymentId}'..."
            openshift.withCluster() {
                openshift.withProject() {
                def deploymentConfig = openshift.create(openshift.process('drupal-deployment-config', '-p', "DEPLOYMENT_ID=${deploymentId}"));
                   deploymentConfig.rollout().status()
                }
            }
        }

        stage("Expose HTTP Endpoint") {
            echo "Exposing HTTP endpoint for Drupal deployment '${deploymentId}..."
            openshift.withCluster() {
                openshift.withProject() {
                    /*
                        This should be using openshift.verifyService(), but it's not in the plugin version installed here.
                    */
                    openshift.create(openshift.process('drupal-http-service', '-p', "DEPLOYMENT_ID=${deploymentId}"));
                }
            }
        }
   }
}
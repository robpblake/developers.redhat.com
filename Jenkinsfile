node {
   timeout(30) {

        stage('Build Docker Image') {
                openshift.withCluster() {
                    openshift.withProject() {
                        def buildConfig = openshift.create(openshift.process('drupal-docker-image-build','-p', "DEPLOYMENT_ID=${env.BUILD_ID}"))
                        def build = buildConfig.startBuild()
                        build.untilEach(1) {
                            echo "Waiting for build of Docker Image 'redhatdeveloper/rhdp-drupal:${env.BUILD_ID} to complete..."
                            sleep 10
                            return (it.object().status.phase == 'Complete')
                        }

                    }
                }
        }

        stage('Bootstrap the deployment') {
            openshift.withCluster() {
                openshift.withProject() {
                    def deployJob = openshift.create(openshift.process('drupal-deploy-job','-p', "DEPLOYMENT_ID=${env.BUILD_ID}"))
                    waitUntil() {
                        echo "Waiting for the completion of job 'drupal-deploy-job-${env.BUILD_ID}. This may take some time..."
                        sleep 15
                        openshift.raw("get job drupal-deploy-job-${env.BUILD_ID} -o jsonpath='{.status.conditions[?(@.type==\"Complete\")].status}'").out.toString().trim().toBoolean()
                    }
                }
            }
        }

        stage('Deploy Drupal') {
            openshift.withCluster() {
                openshift.withProject() {
                   def deploymentConfig = openshift.create(openshift.process('drupal-build-config', '-p', "DEPLOYMENT_ID=${env.BUILD_ID}"));
                   deploymentConfig.rollout.status()
                }
            }
        }
   }
}
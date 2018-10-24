node {
   timeout(60) {

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
   }
}
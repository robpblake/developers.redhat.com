def currentDeploymentId = null
def previousDeploymentId = null
def deploymentId = null
def internalDockerRegistry = null

node {
   timeout(30) {

        stage("Checkout SCM") {
            checkout scm
        }

        stage("Record Deployment") {
           openshift.withCluster() {
               openshift.withProject() {
                   def configMap = openshift.selector('configmap/drupal-deployments').object()
                   currentDeploymentId = configMap.data['CURRENT_DEPLOYMENT_ID'].toInteger()
                   previousDeploymentId = configMap.data['PREVIOUS_DEPLOYMENT_ID'].toInteger()
                   deploymentId = configMap.data['NEXT_DEPLOYMENT_ID'].toInteger() + 1
                   echo "The id of this deployment will be '${deploymentId}'."

                   configMap.data['NEXT_DEPLOYMENT_ID'] = "${deploymentId}"
                   openshift.apply(configMap)
               }
           }
        }

        stage('Build Docker Image') {
            echo "Building the Docker image for this deployment..."
                openshift.withCluster() {
                    openshift.withProject() {

                        def buildConfig = openshift.selector('bc/drupal-docker-image')
                        def build = buildConfig.startBuild()
                        build.untilEach(1) {
                            echo "Building Docker Image for this deployment..."
                            return (it.object().status.phase == 'Complete')
                        }

                        echo "Tagging built Docker Image as 'rhdp-drupal:${deploymentId}'..."
                        openshift.tag("rhdp-drupal:latest", "rhdp-drupal:${deploymentId}")
                    }
                }
        }



        stage('Deploy Drupal') {
            echo "Deploying Drupal for deployment '${deploymentId}'..."
            openshift.withCluster() {
                openshift.withProject() {
                    openshift.create(openshift.process(readFile(file:'openshift/drupal-services.yml'), '-p', "DEPLOYMENT_ID=${deploymentId}"))

                    def imageStream = openshift.selector("is/rhdp-drupal")
                    internalDockerRegistry = imageStream.object().status['dockerImageRepository'].split('/')[0] + "/${env.PROJECT_NAME}"
                    openshift.create(openshift.process(readFile(file:'openshift/drupal-statefulset.yml'), '-p', "DEPLOYMENT_ID=${deploymentId}", "IMAGE_REPOSITORY=${internalDockerRegistry}"))

                    /*
                        TODO: need to work out how to wait on a rollout of a StatefulSet
                    */
                }
            }
        }

        stage("Update 'next' route") {
            openshift.withCluster() {
               openshift.withProject() {
                   def nextServiceName = "drupal-https-${deploymentId}"
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

                    def previousServiceName = "drupal-https-${currentDeploymentId}"
                    def currentServiceName = "drupal-https-${deploymentId}"

                    def configMap = openshift.selector('configmap/drupal-deployments').object()
                    configMap.data['PREVIOUS_DEPLOYMENT_ID'] = "${currentDeploymentId}"
                    configMap.data['CURRENT_DEPLOYMENT_ID'] = "${deploymentId}"
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
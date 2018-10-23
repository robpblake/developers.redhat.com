node {
   timeout(60) {

    stage('Checkout SCM') {
           git url: 'https://github.com/robpblake/developers.redhat.com.git', branch: 'managed-platform'
    }

    stage('Prepare the environment') {
        openshift.withCluster() {
                openshift.withProject() {
                    openshift.create(openshift.process('drupal-deploy-job', '-p', 'DEPLOYMENT_ID=1'))

                    waitUntil() {
                        echo "Waiting for the completion of job 'drupal-deploy-job-1. This may take some time..."
                        sleep 15
                        openshift.raw("get job drupal-deploy-job-1 -o jsonpath='{.status.conditions[?(@.type==\"Complete\")].status}'").out.toString().trim().toBoolean()
                    }
                }
        }
    }
  }
}
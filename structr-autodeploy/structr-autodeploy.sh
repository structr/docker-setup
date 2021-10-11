#!/bin/bash

echo "Starting structr-autodeploy process.."
echo "Waiting for host: 'http://${HOST}/structr/health/ready'"
source /usr/local/bin/wait-for-url.sh "http://${HOST}/structr/health/ready" "200" "600"
echo "Host is up and ready for app deployment"
echo "Starting app deployment.."
curl -s -o /dev/null -XPOST http://structr:8082/structr/deploy -HX-User:"superadmin" -HX-Password:"${STRUCTR_SUPERADMIN_PASSWORD}" -F mode=app -F downloadUrl=${APP_ZIP_URL}
echo "App deployment done and waiting to be ready for data deployment"
source /usr/local/bin/wait-for-url.sh "http://${HOST}/structr/health/ready" "200" "600"
echo "Ready for data deployment"
echo "Starting data deployment.."
curl -s -o /dev/null -XPOST http://structr:8082/structr/deploy -HX-User:"superadmin" -HX-Password:"${STRUCTR_SUPERADMIN_PASSWORD}" -F mode=data -F downloadUrl=${DATA_ZIP_URL} -F rebuildAllIndexes=true
echo "Data deployment done and waiting for HealthCheck ready endpoint"
source /usr/local/bin/wait-for-url.sh "http://${HOST}/structr/health/ready" "200" "600"
echo "structr-autodeploy process finished!"

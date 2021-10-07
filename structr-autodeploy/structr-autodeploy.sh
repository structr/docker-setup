#!/bin/bash

echo "Starting structr-autodeploy process.."
echo "Waiting for host: ${HOST}"
source /usr/local/bin/wait-for-url.sh "${HOST}" "200" "600"
echo "Host is up and ready for app deployment"
echo "Starting app deployment.."
curl -s -o /dev/null -XPOST -HX-User:"superadmin" -HX-Password:"${STRUCTR_SUPERADMIN_PASSWORD}" http://structr:8082/structr/deploy -F mode=app -F downloadUrl=${APP_ZIP_URL}
source /usr/local/bin/wait-for-url.sh "${HOST}" "200" "600"
echo "App deployment done and ready for data deployment"
curl -s -o /dev/null -XPOST -HX-User:"superadmin" -HX-Password:"${STRUCTR_SUPERADMIN_PASSWORD}" http://structr:8082/structr/deploy -F mode=data -F downloadUrl=$DATA_ZIP_URL -F rebuildAllIndexes=true
echo "Starting data deployment.."
source /usr/local/bin/wait-for-url.sh "${HOST}" "200" "600"
echo "Data deployment done"
echo "structr-autodeploy process finished!"

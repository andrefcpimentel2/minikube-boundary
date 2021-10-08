kubectl config use-context boundary-cluster-1

export BOUNDARY_ADDR=http://127.0.0.1:9200/
export PROJECT_ID=$(boundary scopes list -recursive -format json | jq  -r '.items[] | select(.name | contains("Generated project scope")) | .id')

AUTH_METHOD_ID=$(cat boundary_login.json | jq -r .auth_method.auth_method_id) &&
PASSWORD=$(cat boundary_login.json | jq -r .auth_method.password) && \
boundary authenticate password \
         -login-name=admin \
         -password $PASSWORD \
         -auth-method-id=$AUTH_METHOD_ID

unset BOUNDARY_RECOVERY_CONFIG

boundary connect kube -target-name=k8s-api  -target-scope-id $PROJECT_ID -- get pods --all-namespaces
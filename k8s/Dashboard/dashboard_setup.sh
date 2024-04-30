#!/bin/bash
if [[ "$1" == 'install' ]]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout dashboard.key -out dashboard.crt -subj "/C=IN/CN=mydashboard"
    kubectl create namespace kubernetes-dashboard
    kubectl create secret tls dashboard-tls --key dashboard.key --cert dashboard.crt -n kubernetes-dashboard
secret/dashboard-tls created
    kubectl apply -f https://raw.githubusercontent.com/jaintpharsha/install/main/k8s/Dashboard/kubernete-dashboard.yml

    kubectl --namespace kubernetes-dashboard patch svc kubernetes-dashboard -p '{"spec": {"type": "NodePort"}}'

cat > nodeport_dashboard_patch.yaml <<EOF
spec:
  ports:
  - nodePort: 32000
    port: 443
    protocol: TCP
    targetPort: 8443
  tls:
    - secretName: dashboard-tls
EOF

    kubectl -n kubernetes-dashboard patch svc kubernetes-dashboard --patch "$(cat nodeport_dashboard_patch.yaml)"

    rm nodeport_dashboard_patch.yaml

    mkdir -p $HOME/certs

    echo '[req]
    default_bit = 4096
    distinguished_name = req_distinguished_name
    prompt = no

    [req_distinguished_name]
    countryName             = IN
    stateOrProvinceName     = Karnataka
    localityName            = Bengaluru
    organizationName        = QProfiles' > $HOME/certs/cert.cnf

    openssl genrsa -des3 -passout pass:over4chars -out tls.pass.key 2048 && openssl rsa -passin pass:over4chars -in tls.pass.key -out $HOME/certs/tls.key && rm tls.pass.key
    openssl req -new -key tls.key -out $HOME/certs/tls.csr -config $HOME/certs/cert.cnf

    openssl x509 -req -sha256 -days 365 -in $HOME/certs/tls.csr -signkey $HOME/certs/tls.key -out $HOME/certs/tls.crt
    kubectl create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs -n kubernetes-dashboard
    echo -e "\n   DASHBOARD_ENDPOINT: Shttps://<any_worker_node_ip>:32000"
    echo -e "\n   USE BELLOW TOKEN TO LOGIN K8S_DASHBOARD\n"
    kubectl describe secret -n kubernetes-dashboard kubernetes-dashboard-token | grep -i 'token:      ' | awk -F 'token:      ' '{print $NF}'
elif [[ "$1" == 'remove' ]]; then 
    kubectl delete -f https://raw.githubusercontent.com/jaintpharsha/install/main/k8s/Dashboard/kubernete-dashboard.yml
    [[ -d "$HOME/certs" ]] && rm -rf "$HOME/certs"
else 
    echo "Unknown option $1"
fi

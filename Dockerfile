FROM alpine/helm:3.1.2 as helm
FROM bitnami/kubectl:1.22-debian-10 as kubectl
FROM mikefarah/yq:3.3.2 as yq
FROM ubuntu:20.04
LABEL maintainer="Ithrael <https://github.com/Ithrael>"

COPY --from=helm /usr/bin/helm /usr/local/bin
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin
COPY --from=yq /usr/bin/yq /usr/local/bin

RUN apt-get update -y
RUN apt-get install -qy curl
RUN apt-get install -qy gnupg2
RUN apt-get install -qy lsb-release
RUN apt-get install -qy software-properties-common
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update -y && apt-get install terraform
RUN mkdir -p /root/terraformk8s
COPY . /root/terraformk8s
RUN cd /root/terraformk8s/k8s && terraform init
WORKDIR /root

RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.13.4 sh -
RUN cd istio-1.13.4 && export PATH=$PWD/bin:$PATH
WORKDIR istio-1.13.4

# ## 依赖kubectl配置好config
# RUN istioctl install --set profile=demo -y
# RUN kubectl label namespace default istio-injection=enabled
# RUN kubectl get po
# RUN kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -s productpage:9080/productpage | grep -o "<title>.*</title>"
# RUN kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
# RUN istioctl analyze

# RUN export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
# RUN export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
# RUN export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
# RUN export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
# RUN echo "http://$GATEWAY_URL/productpage"
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
RUN apt-get install -qy vim
RUN apt-get install -qy gnupg2
RUN apt-get install -qy lsb-release
RUN apt-get install -qy software-properties-common
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update -y && apt-get install terraform
RUN mkdir -p /root/terraformk8s
RUN mkdir -p /root/.kube
COPY . /root/terraformk8s
RUN cd /root/terraformk8s/k8s && terraform init
WORKDIR /root

RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.13.4 sh -
COPY istio_install.sh /root/istio-1.13.4
WORKDIR /root/terraformk8s/k8s

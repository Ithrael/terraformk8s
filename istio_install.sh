# 依赖kubectl配置好config
RUN istioctl install --set profile=demo -y
RUN kubectl label namespace default istio-injection=enabled
RUN kubectl get po
RUN kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -s productpage:9080/productpage | grep -o "<title>.*</title>"
RUN kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
RUN istioctl analyze

RUN export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
RUN export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
RUN export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
RUN export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
RUN echo "http://$GATEWAY_URL/productpage"
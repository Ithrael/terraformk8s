# terraformk8s

## 年轻人的第一个k8s集群

阿里云ack pro托管版集群

k8s version 1.22.3

worker 2台 ecs.c7.xlarge ESSD 40G

已安装istio

按量付费:2.92元/时+流量费
![image](https://ithrael-image.oss-cn-hangzhou.aliyuncs.com/github/aliyun_cost.jpg)

## 使用

### 创建集群

已经build好docker image，可以直接使用，也可以git clone项目后自己build

***建议直接使用build好的image，自己在本地build的话，terraform init和安装istio这两步会比较慢。可以借助gitlab action来build***

```bash
docker pull registry.cn-hangzhou.aliyuncs.com/ithrael123/k8sclient:v1.0
docker run -it registry.cn-hangzhou.aliyuncs.com/ithrael123/k8sclient:v1.0 bash
```

使用vim修改variables.tf中的access_key和secret_key为自己阿里云的key和secret

在build docker时已经init过了，所以此处可以不需要terraform init

```bash
terraform plan
terraform apply
```

会要求我们输入 yes
输入后会显示如下信息
![image](https://ithrael-image.oss-cn-hangzhou.aliyuncs.com/github/apply.jpg)
等待一会(大约10分钟左右),看到如下结果表示集群创建成功
![image](https://ithrael-image.oss-cn-hangzhou.aliyuncs.com/github/result.jpg)

### 配置kubectl

登录aliyun，打开k8s集群后台 https://cs.console.aliyun.com/#/k8s/cluster/list

找到刚我们创建好集群的连接信息
![image](https://ithrael-image.oss-cn-hangzhou.aliyuncs.com/github/k8s_console.jpg)
将公网访问里的内容复制到 /root/.kube/config文件里

然后验证一下,执行

```bash
kubectl get ns
```

有如下图所示信息则表明kubectl配置成功
![image](https://ithrael-image.oss-cn-hangzhou.aliyuncs.com/github/k_get_ns.jpg)

### 配置istio

```bash
cd /root/istio-1.13.4/
sh istio_install.sh
```

有下图所示信息则表明istio配置成功，并部署好了demo服务
![image](https://ithrael-image.oss-cn-hangzhou.aliyuncs.com/github/istio.jpg)
等pod变成running状态，即可在浏览器打开输出的url进行访问

```bash
kubectl get po 
```

![image](https://ithrael-image.oss-cn-hangzhou.aliyuncs.com/github/k_get_po.jpg)
![image](https://ithrael-image.oss-cn-hangzhou.aliyuncs.com/github/istio_demo.jpg)

## Next

接下来你可能想了解的一些知识

### k8s

k8s doc v1.22: https://v1-22.docs.kubernetes.io/zh/docs/concepts/

### istio

getting-started:https://istio.io/latest/docs/setup/getting-started/

### terraform

Download: https://www.terraform.io/downloads

Aliyun Provider:https://registry.terraform.io/providers/aliyun/alicloud/latest/docs

variable "access_key" {
  default = "xxxxxx"
}

variable "secret_key" {
  default = "xxxxxx"
}

variable "vpc_name_prefix" {
  default = "test-vpc"
}

variable "region" {
  default = "cn-hangzhou"
}


variable "cidr_blocks" {
  type = map(string)

  default = {
    az0 = "192.168.0.0/24"
    az1 = "192.168.1.0/24"
    az2 = "192.168.2.0/24"
  }
}


variable "terway_cidr_blocks" {
  type = map(string)

  default = {
    az0 = "192.168.3.0/24"
    az1 = "192.168.4.0/24"
    az2 = "192.168.5.0/24"
  }
}


variable "k8s_number" {
  description = "The number of kubernetes cluster."
  default     =  1
}

variable "k8s_name" {
  description = "The name of kubernetes cluster."
  default     =  "test_ack_k8s"
}

variable "availability_zone" {
    description = "The availability zones of vswitches."
    default = ["cn-hangzhou-k"]
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  default     = "192.168.0.0/16"
}


variable "vswitch_cidrs" {
  description = "List of cidr blocks used to create several new vswitches when 'vswitch_ids' is not specified."
  type        = list(string)
  default     = ["192.168.0.0/24","192.168.2.0/24","192.168.1.0/24"]
}

variable "terway_vswitch_cirds" {
  description = "List of cidr blocks used to create several new vswitches when 'vswitch_ids' is not specified."
  type        = list(string)
  default     = ["192.168.3.0/24","192.168.4.0/24","192.168.5.0/24"]
}


variable "worker_instance_types" {
  description = "The ecs instance types used to launch worker nodes."
  default     = ["ecs.c7.xlarge"]
}

# options: between 24-28
variable "node_cidr_mask" {
    description = "The node cidr block to specific how many pods can run on single node."
    default = 24
}

variable "enable_ssh" {
    description = "Enable login to the node through SSH."
    default = true
}

variable "install_cloud_monitor" {
    description = "Install cloud monitor agent on ECS."
    default = false
}

variable "worker_disk_category" {
    description = "The system disk category of worker node. Its valid value are cloud, cloud_ssd, cloud_essd and cloud_efficiency. Default to cloud_efficiency."
    default = "cloud_essd"
}


# options: none|static
variable "cpu_policy" {
    description = "kubelet cpu policy.default: none."
    default = "none"
}

# options: ipvs|iptables
variable "proxy_mode" {
    description = "Proxy mode is option of kube-proxy."
    default = "ipvs"
}

variable "k8s_password" {
  description = "The password of k8s instance."
  default     = "TESTes2022"
}

variable "worker_number" {
  description = "The number of worker nodes in kubernetes cluster."
  default     = 2
}

# k8s_pod_cidr is only for flannel network
variable "pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them."
  default     = "10.204.0.0/16"
}

variable "service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them."
  default     = "172.16.0.0/16"
}

variable "cluster_addons" {
  type = list(object({
    name      = string
    config    = string
  }))

  default = [
    {
      "name"     = "terway-eniip",
      "config"   = "",
    },
    {
      "name"     = "csi-plugin",
      "config"   = "",
    },
    {
      "name"     = "csi-provisioner",
      "config"   = "",
    }
  ]
}


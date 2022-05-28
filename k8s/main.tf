resource "random_uuid" "this" {}



resource "alicloud_vpc" "vpc" {
  vpc_name       = substr(join("-", [var.vpc_name_prefix, random_uuid.this.result]), 0, 63)
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "vswitches" {
  vpc_id            = alicloud_vpc.vpc.id
  count             = length(var.cidr_blocks)
  cidr_block        = var.cidr_blocks["az${count.index}"]
  zone_id = element(var.availability_zone, count.index)

  depends_on = [alicloud_vpc.vpc]
}


resource "alicloud_vswitch" "terway_vswitches" {
  vpc_id            = alicloud_vpc.vpc.id
  count             = length(var.terway_cidr_blocks)
  cidr_block        = var.terway_cidr_blocks["az${count.index}"]
  zone_id = element(var.availability_zone, count.index)

  depends_on = [alicloud_vpc.vpc]
}

resource "alicloud_cs_managed_kubernetes" "k8s" {
  name                  = var.k8s_name
  count                 = var.k8s_number
  worker_vswitch_ids    = alicloud_vswitch.vswitches.*.id
  pod_vswitch_ids       = alicloud_vswitch.terway_vswitches.*.id
  worker_instance_types = var.worker_instance_types
  worker_number         = var.worker_number
  node_cidr_mask        = var.node_cidr_mask
  enable_ssh            = var.enable_ssh
  install_cloud_monitor = var.install_cloud_monitor
  cpu_policy            = var.cpu_policy
  proxy_mode            = var.proxy_mode
  password              = var.k8s_password
  worker_disk_category  = var.worker_disk_category
  # pod_cidr              = var.pod_cidr
  service_cidr          = var.service_cidr
  slb_internet_enabled  = true
  is_enterprise_security_group = true

  # version can not be defined in variables.tf. Options: 1.16.6-aliyun.1|1.18.8-aliyun.1
  version               = "1.22.3-aliyun.1"

  dynamic "addons" {
      for_each = var.cluster_addons
      content {
        name                    = lookup(addons.value, "name", var.cluster_addons)
        config                  = lookup(addons.value, "config", var.cluster_addons)
      }
  }
  runtime = {
    name    = "docker"
    version = "19.03.5"
  }
}


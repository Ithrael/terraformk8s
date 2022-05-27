terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.168.0"
    }
  }
}
provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  # 填入想创建的 Region
  region     = "cn-hangzhou"
}
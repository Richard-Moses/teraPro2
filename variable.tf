#my tenancity_vpc
variable "Region" {
  default     = "eu-west-2"
  description = "aws region"
}
variable "Vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "vpc cidr"

}

variable "Prod-pub-sub1" {
  default     = "10.0.5.0/24"
  description = "Prod-pub-sub1"

}
variable "Prod-pub-sub2" {
  default     = "10.0.6.0/24"
  description = "Prod-pub-sub2"
}
variable "Prod-priv-sub1" {
  default     = "10.0.7.0/24"
  description = "Prod-priv-sub1"
}
variable "Prod-priv-sub2" {
  default     = "10.0.8.0/24"
  description = "Prod-priv-sub2"
}
variable "instance_tenancy" {
  default     = "default"
  description = "instance tenancy"
}
variable "igw-cidr_block" {
  default     = "0.0.0.0/0"
  description = "internet gateway"
}
variable "Instance_type" {
  default     = "t2.nano"
  description = "Instance type"
}
variable "ami"{
  default ="ami-0ad97c80f2dfe623b"
  description = "AMI"
}


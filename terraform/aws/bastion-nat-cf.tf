provider "aws" {
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region = "${var.aws_region}"
}

module "vpc" {
  source = "github.com/cloudfoundry-community/terraform-aws-vpc"
  network = "${var.network}"
  aws_key_name = "${var.aws_key_name}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"
  aws_key_path = "${var.aws_key_path}"
}

output "aws_vpc_id" {
  value = "${module.vpc.aws_vpc_id}"
}

output "aws_internet_gateway_id" {
  value = "${module.vpc.aws_internet_gateway_id}"
}

output "aws_route_table_public_id" {
  value = "${module.vpc.aws_route_table_public_id}"
}

output "aws_route_table_private_id" {
  value = "${module.vpc.aws_route_table_private_id}"
}

output "aws_subnet_bastion" {
  value = "${module.vpc.bastion_subnet}"
}

output "aws_subnet_bastion_az" {
  value = "${module.vpc.aws_subnet_bastion_availability_zone}"
}

output "cf_admin_pass" {
  value = "${var.cf.admin_pass}"
}

output "cf_pass" {
  value = "${var.cf.pass}"
}

output "aws_key_path" {
	value = "${var.aws_key_path}"
}

module "cf-net" {
  source = "github.com/cloudfoundry-community/terraform-aws-cf-net"
  network = "${var.network}"
  aws_key_name = "${var.aws_key_name}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"
  aws_key_path = "${var.aws_key_path}"
  aws_vpc_id = "${module.vpc.aws_vpc_id}"
  aws_internet_gateway_id = "${module.vpc.aws_internet_gateway_id}"
  aws_route_table_public_id = "${module.vpc.aws_route_table_public_id}"
  aws_route_table_private_id = "${module.vpc.aws_route_table_private_id}"
  aws_subnet_cfruntime-2a_availability_zone = "${lookup(var.cf1_az, var.aws_region)}"
  aws_subnet_cfruntime-2b_availability_zone = "${lookup(var.cf2_az, var.aws_region)}"
}

output "cf_api" {
	value = "api.run.${module.cf-net.aws_eip_cf_public_ip}.xip.io"
}

output "aws_subnet_docker_id" {
  value = "${module.cf-net.aws_subnet_docker_id}"
}

/*
resource "template_file" "bosh_yml" {
  template = "${file("${path.module}/../../config/aws/bosh.yml")}"
  vars {
    bosh-version = "${var.bosh.version}"
    bosh-sha1 = "${var.bosh.sha1}"
    bosh-aws_cpi_version = "${var.bosh.aws_cpi_version}"
    bosh-aws_cpi_sha1 = "${var.bosh.aws_cpi_sha1}"
    bosh-director_vm_size = "${var.bosh.director_vm_size}"
    bosh-subnet = "${module.vpc.aws_subnet_microbosh_id}"
    bosh-az = "${module.vpc.aws_subnet_bastion_availability_zone}"
    network = "${var.network}"
    centos_stemcell_version = "${var.centos_stemcell_version}"
    centos_stemcell_sha1 = "${var.centos_stemcell_sha1}"
    aws-access_key = "${var.aws_access_key}"
    aws-secret_key = "${var.aws_secret_key}"
    aws-region = "${var.aws_region}"
    aws-public-ip = "${module.cf-net.aws_eip_cf_public_ip}"
    aws-security-group = "${module.cf-net.aws_security_group_cf_id}"
  }
}
*/

resource "aws_instance" "bastion" {
  ami = "${lookup(var.aws_centos_ami, var.aws_region)}"
  instance_type = "t2.small"
  key_name = "${var.aws_key_name}"
  associate_public_ip_address = true
  security_groups = ["${module.vpc.aws_security_group_bastion_id}"]
  subnet_id = "${module.vpc.bastion_subnet}"

	ebs_block_device {
		device_name = "xvdc"
		volume_size = "40"
	}

  tags {
   Name = "bastion"
  }

  connection {
    user = "centos"
    key_file = "${var.aws_key_path}"
  }

  provisioner "file" {
    source = "${path.module}/../../sshkeys"
    destination = "/home/centos/"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${HOME}/{.ssh,bin,config,deployments}",
      "chmod 0600 ${HOME}/.ssh/bosh.pem",
    ]
  }
}

output "bastion_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "centos_stemcell_version" {
 value = "${var.centos_stemcell_version}"
}

output "centos_stemcell_sha1" {
 value = "${var.centos_stemcell_sha1}"
}

output "bosh_sha1" {
  value = "${var.bosh.sha1}"
}

output "bosh_aws_cpi_version" {
  value = "${var.bosh.aws_cpi_version}"
}

output "bosh_aws_cpi_sha1" {
  value = "${var.bosh.aws_cpi_sha1}"
}

output "bosh_type" {
  value = "${var.bosh.bosh_type}"
}

output "bosh_director_vm_size" {
  value = "${var.bosh.director_vm_size}"
}

output "bosh_init_version" {
  value = "${var.bosh.init_version}"
}

output "cf_domain" {
  value = "${var.cf.domain}"
}

output "cf_run_subdomain" {
  value = "${var.cf.run_subdomain}"
}

output "cf_apps_subdomain" {
  value = "${var.cf.apps_subdomain}"
}

output "cf_etcd_version" {
  value = "${var.cf.etcd_version}"
}

output "cf_haproxy_version" {
  value = "${var.cf.haproxy_version}"
}

resource "aws_security_group_rule" "nat" {
	source_security_group_id = "${module.cf-net.aws_security_group_cf_id}"
	security_group_id = "${module.vpc.aws_security_group_nat_id}"
 from_port = -1
 to_port = -1
 protocol = "-1"
 type = "ingress"
}

output "aws_access_key" {
	value = "${var.aws_access_key}"
}

output "aws_secret_key" {
	value = "${var.aws_secret_key}"
}

output "aws_key_name" {
	value = "${var.aws_key_name}"
}

output "aws_region" {
	value = "${var.aws_region}"
}

output "bosh_subnet" {
  value = "${module.vpc.aws_subnet_microbosh_id}"
}

output "bosh_type" {
	value = "${var.bosh.type}"
}

output "bosh_init_version" {
	value = "${var.bosh.init_version}"
}

output "bosh_version" {
	value = "${var.bosh.version}"
}

output "network" {
	value = "${var.network}"
}

output "cf_api_ip" {
	value = "${module.cf-net.aws_eip_cf_public_ip}"
}

output "cf_subnet1" {
  value = "${module.cf-net.aws_subnet_cfruntime-2a_id}"
}

output "cf_subnet1_az" {
	value = "${module.cf-net.aws_subnet_cfruntime-2a_availability_zone}"
}

output "cf_subnet2" {
	value = "${module.cf-net.aws_subnet_cfruntime-2b_id}"
}

output "cf_subnet2_az" {
	value = "${module.cf-net.aws_subnet_cfruntime-2b_availability_zone}"
}

output "bastion_az" {
	value = "${aws_instance.bastion.availability_zone}"
}

output "bastion_id" {
	value = "${aws_instance.bastion.id}"
}

output "lb_subnet1" {
	value = "${module.cf-net.aws_subnet_lb_id}"
}

output "cf_sg" {
	value = "${module.cf-net.aws_security_group_cf_name}"
}

output "cf_sg_id" {
	value = "${module.cf-net.aws_security_group_cf_id}"
}

output "cf_size" {
	value = "${var.cf.size}"
}

output "docker_subnet" {
	value = "${module.cf-net.aws_subnet_docker_id}"
}

output "install_docker_services" {
	value = "${var.install_docker_services}"
}

output "cf_release_version" {
	value = "${var.cf.release_version}"
}

output "cf_private_domains" {
	value = "${var.cf.private_domains}"
}

output "debug" {
	value = "${var.debug}"
}

output "backbone_z1_count" { value = "${lookup(var.backbone_z1_count, var.deployment_size)}" }
output "api_z1_count"      { value = "${lookup(var.api_z1_count,      var.deployment_size)}" }
output "services_z1_count" { value = "${lookup(var.services_z1_count, var.deployment_size)}" }
output "health_z1_count"   { value = "${lookup(var.health_z1_count,   var.deployment_size)}" }
output "runner_z1_count"   { value = "${lookup(var.runner_z1_count,   var.deployment_size)}" }
output "backbone_z2_count" { value = "${lookup(var.backbone_z2_count, var.deployment_size)}" }
output "api_z2_count"      { value = "${lookup(var.api_z2_count,      var.deployment_size)}" }
output "services_z2_count" { value = "${lookup(var.services_z2_count, var.deployment_size)}" }
output "health_z2_count"   { value = "${lookup(var.health_z2_count,   var.deployment_size)}" }
output "runner_z2_count"   { value = "${lookup(var.runner_z2_count,   var.deployment_size)}" }

output "additional_cf_sg_allows" {
  value = "${var.additional_cf_sg_allow_1},${var.additional_cf_sg_allow_2},${var.additional_cf_sg_allow_3},${var.additional_cf_sg_allow_4},${var.additional_cf_sg_allow_5},${module.cf-net.aws_cf_a_cidr},${module.cf-net.aws_cf_b_cidr},${module.cf-net.aws_lb_cidr},${module.cf-net.aws_docker_cidr},${module.cf-net.aws_eip_cf_public_ip}"
}

output "backbone_resource_pool"        { value = "${var.backbone_resource_pool}" }
output "data_resource_pool"            { value = "${var.data_resource_pool}" }
output "public_haproxy_resource_pool"  { value = "${var.public_haproxy_resource_pool}" }
output "private_haproxy_resource_pool" { value = "${var.private_haproxy_resource_pool}" }
output "api_resource_pool"             { value = "${var.api_resource_pool}" }
output "services_resource_pool"        { value = "${var.services_resource_pool}" }
output "health_resource_pool"          { value = "${var.health_resource_pool}" }
output "runner_resource_pool"          { value = "${var.runner_resource_pool}" }


# RDS for uua and a few other things

resource "aws_db_subnet_group" "uua-cc" {
    name = "uua-cc"
    description = "uua-cc subnet groups"
    subnet_ids = ["${module.vpc.bastion_subnet}", "${module.vpc.aws_subnet_microbosh_id}", "${module.cf-net.aws_subnet_cfruntime-2a_id}", 
                  "${module.cf-net.aws_subnet_cfruntime-2b_id}"]
    tags {
        Name = "UUA-CC rdb subnet group"
    }
}

resource "aws_db_instance" "uua-cc" {
  allocated_storage    = 10
  engine               = "postgres"
  instance_class       = "db.t1.micro"
  name                 = "uuacc" # no dashes allowed in name
  username             = "ccadmin"
  password             = "${var.cf.pass}"
  db_subnet_group_name = "uua-cc"
  depends_on           = ["aws_db_subnet_group.uua-cc"]
}

output "uuacc_db_address" { value = "${aws_db_instance.uua-cc.address}" }
output "uuacc_db_endpoint" { value = "${aws_db_instance.uua-cc.endpoint}" }

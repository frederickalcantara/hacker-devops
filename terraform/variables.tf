variable "linode_api_token" {
	description = "Linode API Token"
	type = string
	sensitive = true
}

variable "root_pass" {
	description = "Root Password for this instance"
	type = string
	sensitive = true
}

variable "ssh_privkey" {
	description = "SSH Private Key"
	type = string
}

variable "ssh_pubkey" {
	description = "SSH Public Key"
	type = string
}

variable "ssh_devops_privkey" {
	description = "Devops SSH Private Key"
	type = string
}

variable "ssh_devops_pubkey" {
	description = "Devops SSH Public Key"
	type = string
}
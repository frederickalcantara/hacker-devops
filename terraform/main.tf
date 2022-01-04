resource "linode_sshkey" "devops_key" {
	label = "devops-key"
	ssh_key = chomp(file(var.ssh_devops_pubkey))
}

resource "linode_sshkey" "root_key" {
	label = "root-key"
	ssh_key = chomp(file(var.ssh_pubkey))
}

resource "linode_instance" "web" {
	label 			= "haxor"
	image 			= "linode/ubuntu20.04"
	region 			= "us-southeast"
	type 			= "g6-standard-1"
	authorized_keys = [linode_sshkey.root_key.ssh_key]
	root_pass 		= var.root_pass
	private_ip 		= true

	connection {
		host 		= self.ip_address
		user 		= "root"
		password 	= var.root_pass
		type 		= "ssh"
		agent 		= true
		timeout 	= "3m"
		private_key = chomp(file(var.ssh_devops_privkey))
	}

	provisioner "remote-exec" {
		inline = [
			"export PATH=$PATH:/usr/bin",
			"sudo apt-get update",
			"sudo adduser --disabled-password --gecos '' ansible",
			"sudo mkdir -p /home/ansible/.ssh",
			"sudo touch /home/ansible/.ssh/authorized_keys",
			"sudo echo '${chomp(file(var.ssh_devops_pubkey))}' > authorized_keys",
			"sudo mv authorized_keys /home/ansible/.ssh",
			"sudo chown -R ansible:ansible /home/ansible/.ssh",
			"sudo chmod 700 /home/ansible/.ssh",
			"sudo chmod 600 /home/ansible/.ssh/authorized_keys",
			"sudo usermod -aG sudo ansible",
			"sudo echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
		]
	}
}

# resource "linode_firewall" "haxor_firewall" {
# 	linodes = [ linode_instance.web.id ]

# 	label = "haxor_firewall"

# 	inbound_policy = "DROP"

# 	inbound {
# 		label    = "allow-http"
# 		action   = "ACCEPT"
# 		protocol = "TCP"
# 		ports    = "80"
# 		ipv4     = ["0.0.0.0/0"]
# 		ipv6     = ["::/0"]
#   	}

#   	inbound {
# 		label    = "allow-https"
# 		action   = "ACCEPT"
# 		protocol = "TCP"
# 		ports    = "443"
# 		ipv4     = ["0.0.0.0/0"]
# 		ipv6     = ["::/0"]
#   	}
	
# 	outbound_policy = "ACCEPT"

# 	outbound {
# 		label    = "allow-TCP"
# 		action   = "ACCEPT"
# 		protocol = "TCP"
# 		ports    = "1-65535"
# 		ipv4     = ["0.0.0.0/0"]
# 		ipv6     = ["::/0"]
# 	}

# 	outbound {
# 		label    = "allow-UDP"
# 		action   = "ACCEPT"
# 		protocol = "UDP"
# 		ports    = "1-65535"
# 		ipv4     = ["0.0.0.0/0"]
# 		ipv6     = ["::/0"]
# 	}
	
# }

# This Terraform configuration creates a Linux VM in Azure with a public IP address.
resource "azurerm_public_ip" "bastion_pip" {
  name                = "${local.resource_name_prefix}-bastion-pip"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  sku = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${local.resource_name_prefix}-bastion-pip"
  tags = local.common_tags
}

# Create a Linux VM in Azure with a public IP address and a network interface
resource "azurerm_network_interface" "bastion_nic" {
  name                = "${local.resource_name_prefix}-bastion-nic"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name

  tags                = local.common_tags
  ip_configuration {
    name                          = "${local.resource_name_prefix}-bastion-ipconfig"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_pip.id
  }
}

 resource "azurerm_network_security_group" "bastion_vmnic_nsg" {
  name                = "${azurerm_network_interface.bastion_nic.name}-nsg"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  tags = local.common_tags
}

resource "azurerm_network_interface_security_group_association" "bastion_nic_nsg_association" {
  depends_on = [ azurerm_network_security_rule.bastion_nic_nsg_rule ]
  network_interface_id      = azurerm_network_interface.bastion_nic.id
  network_security_group_id = azurerm_network_security_group.bastion_vmnic_nsg.id
}

locals {
  bastion_nic_inbound_ports = {
    "100" :  "22"
    "110" : "80"
    "120" : "443"
  }
}
# when starting a map with number make sure to use colon (:) instead of equals (=)
resource "azurerm_network_security_rule" "bastion_nic_nsg_rule" {
  for_each = local.bastion_nic_inbound_ports
  name                        = "Allow-${each.value}-Inbound"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.my_resource_group.name
  network_security_group_name = azurerm_network_security_group.bastion_vmnic_nsg.name
}

resource "azurerm_linux_virtual_machine" "bastion_vm" {
  name                = "${local.resource_name_prefix}-bastion-vm"
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  tags                = local.common_tags
  size                = "Standard_D21_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.bastion_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "null_resource" "ssh_key_bastion" {
  depends_on = [ azurerm_linux_virtual_machine.bastion_vm ]
   connection {
    type        = "ssh"
    host        = azurerm_public_ip.bastion_pip.ip_address
    user        = azurerm_linux_virtual_machine.bastion_vm.admin_username
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source = "~/.ssh/id_rsa.pub"
    destination = "/tmp/authorized_keys"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh",
      "cat /tmp/authorized_keys >> ~/.ssh/authorized_keys",
      "chmod 600 ~/.ssh/authorized_keys",
      "rm /tmp/authorized_keys"
    ]
    
  }
}



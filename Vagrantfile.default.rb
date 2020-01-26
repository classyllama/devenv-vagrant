print "\n"

# Environment Configs
$dev_machine_name = 'example.lan'
$dev_additional_hostnames = %w(store1.example.lan store2.example.lan)

# System Configs
$dev_vm_cpus = 2
$dev_vm_ram = 4096
$dev_mysql_root_pw = 'CHANGEME'
$ssh_private_key = '~/.ssh/id_rsa'
$ssh_public_key_paths = ['~/.ssh/id_rsa.pub']

$persistent_disks = [
  # {
  #   "description" => "data",
  #   "persistDiskPath" => "data_disk.vmdk",
  #   "persistDiskSizeGb" => 50
  # },
  # {
  #   "description" => "datadb",
  #   "persistDiskPath" => "datadb_disk.vmdk",
  #   "persistDiskSizeGb" => 50
  # }
]

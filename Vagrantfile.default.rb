print "\n"

# Environment Configs
$dev_machine_name = 'example.lan'
$dev_additional_hostnames = %w(store1.example.lan store2.example.lan)

# System Configs
$vagrant_base_box = 'bento/centos-8'
$dev_vm_cpus = 2
$dev_vm_ram = 4096
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

$use_provider = "virtualbox" # possible values ["virtualbox", "digitalocean"]

$digital_ocean_api_token = 'CHANGEME'

# To crate a volume
# ----------------------------------
# export DO_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx
# export DO_VOL_GB=50
# export DO_VOL_NAME="xxxxxxxxxx_data"
# export DO_VOL_REGION=xxxxxxx
# curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${DO_TOKEN}" -d "{\"size_gigabytes\":${DO_VOL_GB}, \"name\": \"${DO_VOL_NAME}\", \"region\": \"${DO_VOL_REGION}\"}" "https://api.digitalocean.com/v2/volumes" | jq .

# To List existing volumes
# ----------------------------------
# export DO_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx
# curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DO_TOKEN}" "https://api.digitalocean.com/v2/volumes" | jq .

# Volume must exist before creating the droplet
$digital_ocean_block_volume_id = [] # ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
$digital_ocean_ssh_key_name = ''
$digital_ocean_tags = []

# To List droplet size slugs
# ----------------------------------
# export DO_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx
# curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DO_TOKEN}" "https://api.digitalocean.com/v2/sizes" | jq .
$digital_ocean_droplet_size = 's-2vcpu-4gb'
$digital_ocean_region = 'nyc1'

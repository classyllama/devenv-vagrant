set -eu

# TODO: Legacy piece may be from old devenv and no longer used
# Before things were converted to using ansible playbooks to create certs

########################################
# Init default script vars

sites_dir=/var/www/data/projects
certs_dir=/etc/nginx/ssl

########################################
# re-execute with root priviledges
if [[ "$(id -u)" != 0 ]]; then
    sudo $0 "$@"
    exit
fi

function generate_cert {
    local hostname="$1"

    if [[ -f $certs_dir/$hostname.crt.pem ]]; then
        return
    fi
    echo "   + signing cert $hostname.crt.pem"

    SAN="DNS.1:*.$hostname,DNS.2:$hostname" openssl req -new -sha256 \
        -key $certs_dir/local.key.pem \
        -out $certs_dir/$hostname.csr.pem \
        -config /etc/openssl/vhost.conf \
        -subj "/C=US/CN=$hostname"

    yes | openssl ca -config /etc/openssl/rootca.conf -extensions server_cert -days 375 -notext -md sha256 \
        -in $certs_dir/$hostname.csr.pem \
        -out $certs_dir/$hostname.crt.pem
}

function process_site {
    local site_name="$1"
    local site_path="$2"
    local site_hosts[0]="$site_name" # todo: multi domain support

    for hostname in ${site_hosts[@]}; do
        echo Processing hostname $hostname at path $site_path

        generate_cert $hostname 2> /dev/null
        # @todo: generate nginx SSL + backend config for $hostname
    done
}

function main {

    echo "==> Removing pre-existing configuration"
    rm -f /etc/{nginx}/conf.d/*.{conf,vcl}
    rm -f $certs_dir/*.c??.pem

    sites_list=$(find $sites_dir -mindepth 1 -maxdepth 1 \( -type l -o -type d \))

    echo "==> Generating site configuration"
    for site_path in $sites_list; do
        site_name="$(basename $site_path)"

        site_msg=$(process_site $site_name $site_path)
        [[ -n $site_msg ]] && echo $site_msg    # only list if process_site emitted output
    done

    
    service nginx reload
}; main "$@"

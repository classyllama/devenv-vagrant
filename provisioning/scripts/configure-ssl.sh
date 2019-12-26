cd 

# create local ssl private key
[[ ! -d $SSL_DIR ]] && mkdir -p $SSL_DIR
if [[ ! -f $SSL_DIR/local.key.pem ]]; then
    openssl genrsa -out $SSL_DIR/local.key.pem 2048
fi


# prep root ca directories
mkdir -p $SSL_DIR/rootca/{certs,crl,newcerts,private}
touch $SSL_DIR/rootca/index.txt
echo 1000 > $SSL_DIR/rootca/serial

# @todo: sync local/rootca/*/ca.*.pem to $SSL_DIR/rootca

# add local CA root to the trusted key-store and enable Shared System Certificates
cp $SSL_DIR/rootca/certs/ca.cert.pem /etc/pki/ca-trust/source/anchors/local-ca.key.pem

update-ca-trust
update-ca-trust enable

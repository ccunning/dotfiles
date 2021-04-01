#!/bin/bash

openssl genrsa -out "$1".key 2048

if [ ! -f ssl.cnf ]; then
cat > ssl.cnf << EOF
[ req ]
prompt             = no
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext

[ req_distinguished_name ]
countryName         = US
stateOrProvinceName = Ohio
localityName        = Columbus
organizationName    = WidePoint Corporation
commonName          = $1
emailAddress        = it@widepoint.com

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
DNS.1 = $1
EOF
fi

openssl req -new -sha256 -key "$1".key -out "$1".csr -config ssl.cnf

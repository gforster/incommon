#!/bin/sh -x
# Change the line below and possible add DNS for subjectAltNames
WEBSITE='example'
openssl genrsa -out $WEBSITE.key 2048

cat >.mkcert.cfg <<__EOF__
[ req ]
default_bits                    = 2048
distinguished_name              = req_DN
req_extensions			= req_ext
[ req_DN ]
countryName                     = "1. Country Name             (2 letter code)"
countryName_default             = US
countryName_min                 = 2
countryName_max                 = 2
stateOrProvinceName             = "2. State or Province Name   (full name)    "
stateOrProvinceName_default     = 
localityName                    = "3. Locality Name            (eg, city)     "
localityName_default            =  
0.organizationName              = "4. Organization Name        (eg, company)  "
0.organizationName_default      = 
organizationalUnitName          = "5. Organizational Unit Name (eg, dept)     "
organizationalUnitName_default  = 
commonName                      = "6. Common Name              (eg, FQDN)     "
commonName_max                  = 64
commonName_default              = $WEBSITE.domain.edu
emailAddress                    = "7. Email Address            (eg, name@FQDN)"
emailAddress_max                = 40
emailAddress_default            = 
[req_ext]
subjectAltName = @alt_names
[alt_names]
DNS.1 = $WEBSITE.example2.edu
# DNS.2 = example3.edu 
# DNS.3 = example4.edu 
__EOF__

# Uncomment for a self-signed cert (very bad!)
# openssl req -config .mkcert.cfg \
# -new -x509 -days 365 -key $WEBSITE.key -out $WEBSITE.self.crt
openssl req -config .mkcert.cfg -new -key $WEBSITE.key -out $WEBSITE.csr

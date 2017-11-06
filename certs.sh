#!/bin/bash

CA_KEY="ca.key"
CA_PEM="ca.pem"

SERVER_KEY="server.key"
SERVER_REQ="server.csr"
SERVER_CERT="server.crt"

CLIENT_KEY="client.key"
CLIENT_REQ="client.csr"
CLIENT_CERT="client.crt"

SUBJ1="/emailAddress=ca.ca@ca.fi/C=FI/ST=Uusimaa/L=Helsinki/O=Super Certs/OU=CA Unit/CN=ca"
SUBJ2="/emailAddress=server.server@server.fi/C=FI/ST=Uusimaa/L=Helsinki/O=Server Farm/OU=Maintenance Unit/CN=localhost"
SUBJ3="/emailAddress=client.client@client.fi/C=FI/ST=Uusimaa/L=Helsinki/O=Client Swarm/OU=Connections Unit/CN=client"

echo "Generate CA key" 
openssl genrsa -des3 -out ${CA_KEY} 4096

echo "Self-sign CA cert"
openssl req -new -x509 -nodes -key ${CA_KEY} -sha512 -days 1024 -out ${CA_PEM} -subj "$SUBJ1"

echo "Generate server cert request"
openssl req -newkey rsa:4096 -nodes -keyout ${SERVER_KEY} -out ${SERVER_REQ} -subj "$SUBJ2"

echo "Generate server cert"
openssl x509 -req -in ${SERVER_REQ} -CA ${CA_PEM} -CAkey ${CA_KEY} -CAcreateserial -out ${SERVER_CERT} -days 512 -sha512

echo "Generate client cert request"
openssl req -newkey rsa:4096 -nodes -keyout ${CLIENT_KEY} -out ${CLIENT_REQ} -subj "$SUBJ3"

echo "Generate client cert"
openssl x509 -req -in ${CLIENT_REQ} -CA ${CA_PEM} -CAkey ${CA_KEY} -CAcreateserial -out ${CLIENT_CERT} -days 512 -sha512

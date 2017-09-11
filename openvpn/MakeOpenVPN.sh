#!/bin/sh

# Default Variable Declarations
DEFAULT="Default.txt"
FILEEXT=".ovpn"
CRT=".crt"
KEY=".3des.key"
NODES_KEY=".key"
CA="ca.crt"
TA="ta.key"
NAME="${1}"

if [ -z "${NAME}" ]; then
  # Ask for a Client name
  echo "Please enter an existing Client Name:"
  read NAME
fi


#1st Verify that client's Public Key Exists
if [ ! -f $NAME$CRT ]; then
  echo "[ERROR]: Client Public Key Certificate not found: $NAME$CRT"
  exit
fi
echo "Client's cert found: $NAME$CR"


#Then, verify that there is a private key for that client
if [ ! -f $NAME$KEY ]; then
  echo "[INFO]: Client 3des Private Key not found: $NAME$KEY"
  KEY="${NODES_KEY}"
fi
if [ ! -f $NAME$KEY ]; then
  echo "[ERROR]: Client Private Key not found: $NAME$KEY"
  exit
fi
echo "Client's Private Key found: $NAME$KEY"

#Confirm the CA public key exists
if [ ! -f $CA ]; then
  echo "[ERROR]: CA Public Key not found: $CA"
  exit
fi
echo "CA public Key found: $CA"

#Confirm the tls-auth ta key file exists
if [ ! -f $TA ]; then
  echo "[ERROR]: tls-auth Key not found: $TA"
  exit
fi
echo "tls-auth Private Key found: $TA"

#Ready to make a new .opvn file - Start by populating with the default file
cat $DEFAULT > $NAME$FILEEXT

#Now, append the CA Public Cert
echo "<ca>" >> $NAME$FILEEXT
cat $CA >> $NAME$FILEEXT
echo "</ca>" >> $NAME$FILEEXT

#Next append the client Public Cert
echo "<cert>" >> $NAME$FILEEXT
cat $NAME$CRT | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' >> $NAME$FILEEXT
echo "</cert>" >> $NAME$FILEEXT

#Then, append the client Private Key
echo "<key>" >> $NAME$FILEEXT
cat $NAME$KEY >> $NAME$FILEEXT
echo "</key>" >> $NAME$FILEEXT

#Finally, append the TA Private Key
echo "<tls-auth>" >> $NAME$FILEEXT
cat $TA >> $NAME$FILEEXT
echo "</tls-auth>" >> $NAME$FILEEXT

echo "Done! $NAME$FILEEXT Successfully Created."

#Script written by Eric Jodoin

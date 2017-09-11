# OpenVPN for LEDE
`openvpn` package to be installed inside chroot environment.
Each file from that package, linked (ln -s) outside chroot, in base system with same paths, simulating openvpn installed.
Files in this folder:
`openvpn`: OpenVPN config file.
`MakeOpenVPN.sh`: Script to create OpenVPN client config files. To be stored in /etc/easy-rsa/keys
`Default.txt`: Config that will be added to each client config created with MakeOpenVPN.sh. To be stored in /etc/easy-rsa/keys
### Creating a new user
```
cd /etc/easy-rsa
source vars
cd keys
build-key-pkcs12 <NAME>
<...cert inputs...>
./MakeOpenVPN.sh <NAME>
```
The file <NAME>.ovpn will be created in this folder (/etc/easy-rsa/keys) to be used as OpenVPN client config.

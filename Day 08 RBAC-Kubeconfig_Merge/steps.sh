# Copy keys for cluster creation.
# .ssh/ && private key too 


---
Create NS  development and Production.
---
~
copy keys from master to management server - ca.crt - ca.key
---

Create User user1 

openssl genrsa -out saikiran.key 2048
openssl req -new -key saikiran.key -out saikiran.csr -subj "/CN=saikiran/O=clusteradmin"
openssl x509 -req -in saikiran.csr -CA ca.crt -CAkey ca.key  -CAcreateserial -out saikiran.crt -days 365
# Here we are sigining the key with Certificate Authority 
---
Create User user2

openssl genrsa -out user2.key 2048
openssl req -new -key user2.key -out user2.csr -subj "/CN=user2/O=production"
openssl x509 -req -in user2.csr -CA ca.crt -CAkey ca.key  -CAcreateserial -out user2.crt -days 365

# Here we are sigining the key with Certificate Authority 
---

Now copy all .crt and .key to master root location safely. 
---

create config file for both user on master
export KUBECONFIG=/root/USER1-CONFIG
---

create role for both and deploy 
---
Bindings 



ClusterRolebbinding 



--------
openssl genrsa -out saikiran.key 2048
openssl req -new -key saikiran.key -out saikiran.csr -subj "/CN=saikiran/O=development"
openssl x509 -req -in saikiran.csr -CA ca.crt -CAkey ca.key  -CAcreateserial -out saikiran.crt -days 365


Now copy all .crt and .key to master root location safely. 

create config file for adminstrator.
export kubeconfig=/root/saikiran-CONFIG


---
ConfigFile_Management:
  
 KUBECONFIG=USER1-CONFIG:USER2-CONFIG:SAIKIRAN-CONFIG kubectl config view --merge --flatten > mixed-config.txt

# Docker.NGINX-Kerberos
Docker container for running NGINX as a reverse proxy with Kerberos Authentication

# Prereqiets
> Domain Name \
> The name for your ngnix docker (dockerAccount) \


# Active Directory configuration
## Steps according to [Linux To AD]
### Create a new user on the AD
Use the linux machine name as the user name
## Create the SPNs associated with this account
Open command prompt as administrator
* replace the <> with your values
```shell
C:\Windows\System32> setspn -A hosts/<dockerAccount>.<domain> <dockerAccount>
C:\Windows\System32> setspn -A HTTP/<dockerAccount>.<domain> <dockerAccount>
C:\Windows\System32> ktpass -princ hosts/<dockerAccount>.<domain>@<DOMAIN> -pass <password> -mapuser <dockerAccount> -pType KRB5_NT_PRINCIPAL -out c:\temp\<dockerAccount>.host.keytab
C:\Windows\System32> ktpass -princ HTTP/<dockerAccount>.<domain>@<DOMAIN> -pass <password> -mapuser <dockerAccount> -pType KRB5_NT_PRINCIPAL -out c:\temp\<dockerAccount>.HTTP.keytab
```
## Copy the keytab files to the docker directory

## Build the docker
```bash
$ docke build . -t <dockerName>
```

## Run The docker using 
```bash
$ docker run -e domain='' -e dc='' -e dcip='' -e localhost='<dockerAccount>' -e remoteip='' -e remoteport='' -e username='' -e password='' -e kvno=1 -p 80:80 <dockerName> 
```

## Remarks
 When connecting to nginx you shold use DNS name and not ip in order for the web browser user kerberso and not NTLM\
 The  user will be in the basic authorization header

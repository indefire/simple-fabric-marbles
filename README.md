# simple-fabric-marbles
This is a simplified implementation of **IBM's Fabric Marbles** that utilizes [Fabric 1.0.6](http://hyperledger-fabric.readthedocs.io/en/release-1.0/), a local fabric network, and [IBM Marbles v4](https://github.com/IBM-Blockchain/marbles/tree/v4.0). This project was created to consolidate some of the omitted steps (from my perspective) and the extra steps that confuse the setup process a little from the Marbles project . It was originally created in an AWS environment but should work on any x86 Linux environment. There are two paths that can be taken for this project, one is running the simple scripts in the correct order included in the scripts folder, the other is to follow along in the second path which essentially does the same thing the scripts do.
***
# Path 1 (Easy) - Run shell scripts from the provided scripts directory

### 1. Run the given scripts in this order (preferably from the user's home directory) 
1.  `$ scripts/.installgolang.sh`
1.  `$ scripts/.installnodejs.sh`
1.  `$ scripts/.installdocker.sh`
1. logoff and logon (This is so the user is added to the docker group)
1. `$ scripts/.installmarbles.sh`
1. `$ scripts/.installchaincode.sh`
1. `$ scripts/.installgulp.sh`
1. `$ scripts/.gulpconfig.sh`

***
# Path 2 - Step By Step Instructions

### Install GoLang
Go is used as the programming language for chaincode, it is also what Fabric is written in. If you are installing on your aws environment you can follow the instructions below, otherwise, install instructions can be found here: https://golang.org/dl/
1. From your aws instance that you have a shell in copy and paste the below command which downloads GoLang version 1.9.4 for Linux.
`$ curl -O https://dl.google.com/go/go1.9.4.linux-amd64.tar.gz`
1. Install Go with the below command which will unzip and extract it to /usr/local
 `$ tar –C /usr/local –xzf go1.9.4.linux-amd64.tar.gz`
1. Add Go to your path by editing your ~/.profile
`$ vi ~/.profile`
1. Move to the end of the file with `Shift Key + g` and type:
`export PATH=$PATH:/usr/local/go/bin`
1. Save the File by typing `shift + :` then `wq Enter`
1. You will have to either logout to reload your profile or type:
`$ source ~/.profile`
1. Verify go is installed properly by typing:
`$ go version`
1. If installed properly you will see the Go version displayed

### Install NodeJS version 6.x
1. Download NodeJS
`$ curl –O https://deb.nodesource.com/setup_6.x`
1.	Change permissions on the file
`$ chmod +x setup_6.x`
1. Run the script
`$ sudo –E ./setup_6.x`
1. Install
`$ apt-get install –y nodejs`
1. Verify install worked by typing
`$ node –version`
1. If all went well you should see the version such as: v6.13.0


### Install Docker and docker-compose
Fabric is heavily reliant on docker, combined with docker-compose it simplifies the process of setting up multiple machines
1.	First install docker
`$ sudo apt install docker.io`
1. Then download and install docker-compose
``$ sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose``
1.	Make the download executable
`$ chmod +x /usr/local/bin/docker-compose`
1.	Verify docker-compose is functional
`$ docker-compose –version`
1.	Add the ubuntu user to the docker group or else you’ll have to use sudo each time to run docker
`$ sudo usermod –aG docker ubuntu`
1.	Logout and log back into your aws instance which will reload ubuntu’s groups
`$ logout`
1.	After logging back into your AWS instance, verify sudo no longer needs to be prepended to the docker command:
`$ docker run hello-world`

### Clone Marbles Repository
This will be quick and the easiest step, just clone the marbles repository to your instance. Clone it to ubuntu’s home directory to keep it simple:
`$ git clone https://github.com/IBM-Blockchain/marbles.git --depth 1`

***
### This is a good stopping point if needed before starting up fabric
***

### Hyperledger Fabric Samples
We will be leveraging the hyperledger fabric samples for our network so we won’t need to do as many customizations. We will first download the fabric samples from github, download and install the fabric images and binaries, install the node dependencies for the fabcar example application, test the fabcar example, and view the peer logs we interacted with.

1.	Clone the fabric-samples project in github to home your directory
`$ git clone https://github.com/hyperledger/fabric-samples.git`
1.	Download the fabric setup script
`$ curl -sSL https://goo.gl/kFFqh5 | bash -s 1.0.6`
1.	Download the docker images and fabric binaries utilizing the setup script
`$ sudo bash setup_script.sh`
1.	Once that step has completed, which may take some time, be sure to add the bin folder to your path, example
`$ export PATH=$PWD/bin;$PATH`
1.	Try starting the network because if it doesn’t start, you’ll need to troubleshoot.
`$ cd fabcar`
`$ ./startFabric.sh`
1.	We should now verify all 6 containers started up
`$ docker ps`
1.	If all 6 are listed from the previous command, then move on to next step. If not view the logs of the container that failed with $ `docker logs <container name>`
1.	You should still be in the fabcar directory of the samples. Install the dependencies for the fabcar node application
`$ sudo npm install`
1.	If all went well and no errors were received proceed to next step, if not see Appendix for [fixing node-gyp](#appendix-a) or pkcs11 error
1.	Next run three tests
```
$ node enrollAdmin.js
$ node registerUser.js
$ node query.js
```
If you received an error on the first test relating to grpc see Appendix fix node grpc error

### Install and Instantiate Marbles Chaincode
We are going to install the node dependencies for marbles, and then install and instantiate the chaincode (code that runs on the blockchain) that the marbles application will use.
1.	In your shell navigate to the marbles director and run
`$ npm install`
You may encounter deprecation warnings which are fine, just so no errors occur
1.	Navigate to the marbles/scripts directory and run the node install chaincode script. This step will copy the chaincode to the fabric peer’s file system
`$ node install_chaincode.js`
1.	Now will the chaincode installed, we can instantiate it. 
`$ node instantiate_chaincode.js`

### Run Marbles application 
This is the moment we’ve been waiting for. Actually running the nodejs Marbles application to transfer marbles to/from users.
There is a slight issue with Marbles as the keystore is hardcoded [here](https://github.com/IBM-Blockchain/marbles/blob/a0b55dda42edee2564cde2a2fa7064e4fff48bd1/config/blockchain_creds_local.json#L9), so we have to copy keys to your $HOME directory first. 
1. `cd $HOME`
1. `cp fabric-samples/fabcar/hfc-key-store $HOME`
1. `sed -i 's#/fabric-samples/fabcar/#/.#' marbles/config/connection_profile_local.json`
1. `cd marbles`
1. Start Marbles
`gulp marbles_local`
1.	You should see a Server up message and below the informational box an additional message will be displayed that says to open your browser and navigated to http://localhost:3001 to initiate setup. This is where we branch slightly from the instructions from IBM. Since your server is running in aws, you will need to change the hostname from localhost to the hostname (or public ip) in aws similar to 54.243.7.206:3001  in your local browser.
1.	Go to the url with the port number specified, no need to enter a password and leave the prefilled admin username.
1. The Marbles application will do some verifications before the next screen, when it is finished with its verifications the Marbles application will walk you through the remaining steps creating Owners and Marbles.





### Appendix A
- Fix node-gyp or pkcs11 error when isntalling node dependencies. If the error occurred in the npm install step of fabcar, run the below commands from the fabric-samples/fabcar directory
```
$ sudo apt install -node-gyp
$ sudo npm install
```
- Fix node grpcs error. Run the below command from the fabric-samples/fabcar directory
`$ npm rebuild`

### Appendix B Useful Docker commands
```
docker-compose start – Starts existing docker containers
docker-compose stop – Gracefully shutsdown docker containers so the previous command can be run
docker-compose up – Recreates docker containers
docker-compose down – Stops docker containers and removes containers
docker logs <container_name> - View logs of specified container name (docker logs cli)
```

### Appendix C - Fabric Scripts
- Stop Network (Does not kill containers) - `fabric-samples/basic-network/stop.sh`
- Start network (First kills the containers then starts so be cautious) - `fabric-samples/basic-network/start.sh`
- Start all over - `fabric-samples/basic-network/teardown.sh`

### Resources
- IBM Marbles install instructions - https://github.com/IBM-Blockchain/marbles/tree/v4.0
- Local Hyperledger Network - https://github.com/IBM-Blockchain/marbles/blob/v4.0/docs/use_local_hyperledger.md
- Install NodeJS - https://www.metachris.com/2017/01/how-to-install-nodejs-6-lts-on-ubuntu-and-centos/
- Install and Instantiate Chaincode (needed for marbles) - https://github.com/IBM-Blockchain/marbles/blob/v4.0/docs/install_chaincode_locally.md
- Clone Marbles Repository - ¬https://github.com/IBM-Blockchain/marbles/blob/v4.0/docs/use_local_hyperledger.md
- Host Marbles locally - https://github.com/IBM-Blockchain/marbles/blob/v4.0/docs/host_marbles_locally.md
- Verify marbles crypto and config - https://github.com/IBM-Blockchain/marbles/blob/v4.0/docs/config_file.md
- Setup xrdp on Ubuntu –This is incredibly useful if you want to modify the chaincode or the marbles application https://aws.amazon.com/premiumsupport/knowledge-center/connect-to-ubuntu-1604-windows/
- Official Hyperledger Fabric 1.0 documentation - http://hyperledger-fabric.readthedocs.io/en/release-1.0/

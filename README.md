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
1 Verify go is installed properly by typing:
`$ go version`
1.If installed properly you will see the Go version displayed

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



# simple-fabric-marbles
This is a simplified implementation of **IBM's Fabric Marbles** that utilizes [Fabric 1.0.6](http://hyperledger-fabric.readthedocs.io/en/release-1.0/), a local fabric network, and [IBM Marbles v4](https://github.com/IBM-Blockchain/marbles/tree/v4.0). This project was created to consolidate some of the omitted steps (from my perspective) and the extra steps that confuse the setup process a little from the Marbles project . It was originally created in an AWS environment but should work on any x86 Linux environment. There are two paths that can be taken for this project, one is running the simple scripts in the correct order included in the scripts folder, the other is to follow along in the second path which essentially does the same thing the scripts do.
***
# Path 1 (Easy) - Run Scripts from scripts directory

### 1. Run the given scripts in this order (preferably from the user's home directory) 
1.  `$ scripts/.installgolang.sh`
1.  `$ scripts/.installnodejs.sh`
1.  `$ scripts/.installdocker.sh`

logoff and logon (This is so the user is added to the docker group)

1. `$ scripts/.installmarbles.sh`
1. `$ scripts/.installchaincode.sh`
1. `$ scripts/.installgulp.sh`
1. `$ scripts/.gulpconfig.sh`

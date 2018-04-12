git clone https://github.com/IBM-Blockchain/marbles.git --depth 1
git clone https://github.com/hyperledger/fabric-samples.git
curl -sSL https://goo.gl/kFFqh5 | bash -s 1.0.6
cd fabric-samples/fabcar
./startFabric.sh
docker ps
echo 'you should see 6 processes running'
sudo npm install
sudo apt install node-gyp
sudo npm install
sudo npm rebuild
node enrollAdmin.js
node registerUser.js
node query.js


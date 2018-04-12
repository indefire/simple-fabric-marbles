cd $HOME
cp fabric-samples/fabcar/hfc-key-store $HOME
sed -i 's#/fabric-samples/fabcar/#/.#' marbles/config/connection_profile_local.json
cd marbles
gulp marbles_local

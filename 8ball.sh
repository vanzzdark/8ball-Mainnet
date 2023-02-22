#!/bin/bash

echo -e "\033[0;40m"
echo " :'######::'##:::'##:'##:::'##:'##::: ##:'########:'########:  ";
echo " '##... ##: ##::'##::. ##:'##:: ###:: ##: ##.....::... ##..::  ";
echo "  ##:::..:: ##:'##::::. ####::: ####: ##: ##:::::::::: ##::::  ";
echo " :. ######:: #####::::::.##:::: ## ## ##: ######:::::: ##::::  ";
echo " '##::: ##: ##:. ##::::: ##:::: ##:. ###: ##:::::::::: ##::::  ";
echo " . ######:: ##::. ##:::: ##:::: ##::. ##: ########:::: ##::::  ";
echo " CREDIT : VANZZDARK SKYNET | SPECIAL THANKS TO : MAMAD PINROCK ";
echo -e "\e[0m"

sleep 2

# set vars
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export EIGHTBALL_CHAIN_ID=eightball-1" >> $HOME/.bash_profile
echo "export EIGHTBALL_PORT=${EIGHTBALL_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

# install go
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/sxlmnwb/8ball.git
cd 8ball
git checkout v0.34.24
go build -o 8ball ./cmd/eightballd
sudo mv 8ball /usr/bin/


# config
8ball config chain-id $EIGHTBALL_CHAIN_ID
8ball config keyring-backend test
8ball config node tcp://localhost:18657

# init
8ball init $NODENAME --chain-id $EIGHTBALL_CHAIN_ID

# download configuration
cd $HOME
curl -Ls https://raw.githubusercontent.com/konsortech/Node/main/Mainnet/8ball/genesis.json > $HOME/.8ball/config/genesis.json
curl -Ls https://raw.githubusercontent.com/konsortech/Node/main/Mainnet/8ball/addrbook.json > $HOME/.8ball/config/addrbook.json

# set peers and seeds
sed -i -e "s|^seeds *=.*|seeds = \"fca96d0a1d7357afb226a49c4c7d9126118c37e9@one.8ball.info:26656,aa918e17c8066cd3b031f490f0019c1a95afe7e3@two.8ball.info:26656,98b49fea92b266ed8cfb0154028c79f81d16a825@three.8ball.info:26656\"|" $HOME/.8ball/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.8ball/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.8ball/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.8ball/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.8ball/config/app.toml

# set minimum gas price and timeout commit
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025uebl\"|" $HOME/.8ball/config/app.toml

# Disable Indexer
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.8ball/config/config.toml

# create service
sudo tee /etc/systemd/system/8ball.service > /dev/null <<EOF
[Unit]
Description=eightball
After=network-online.target

[Service]
User=$USER
ExecStart=$(which 8ball) start --home $HOME/.8ball
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable 8ball
sudo systemctl restart 8ball && sudo journalctl -u 8ball -f -o cat

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32msudo journalctl -u 8ball -f -o cat\e[0m'

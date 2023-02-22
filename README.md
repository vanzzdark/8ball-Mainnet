# FULLNODE SETUP
```
wget -O 8ball.sh https://raw.githubusercontent.com/vanzzdark/8ball-Mainnet/main/8ball.sh && chmod +x 8ball.sh && ./8ball.sh
```

## Post installation
```
source $HOME/.bash_profile
```

# Create validator
To create your validator run command below
```
8ball tx staking create-validator \
--amount=99000000uebl \
--pubkey=$(8ball tendermint show-validator) \
--moniker="YourNodeName" \
--chain-id=eightball-1 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=yourwalletname \
--fees=5000uebl
```

# Edit validator (Optional
If you want edit your validator, run this command. 
```
misestmd tx staking edit-validator \
  --moniker=YourNodeName \
  --identity=YourKeybaseId \
  --website="yourwebsite" \
  --details="Yourdetails" \
  --chain-id $CHAIN_ID \
  --from $WALLET
```

# WALLET

Add new wallet
```
8ball keys add $WALLET
```

Recover wallet using seed phrase
```
8ball keys add $WALLET --recover
```

# Usefull commands
Check logs
```
journalctl -fu 8ball -o cat
```

Start service
```
sudo systemctl start 8ball
```

Stop service
```
sudo systemctl stop 8ball
```

Restart service
```
sudo systemctl restart 8ball
```

# Node info
Synchronization info
```
8ball status 2>&1 | jq .SyncInfo
```

Validator info
```
8ball status 2>&1 | jq .ValidatorInfo
```

Node info
```
8ball status 2>&1 | jq .NodeInfo
```

Show node id
```
8ball tendermint show-node-id
```

# Delete Node
```
sudo systemctl stop 8ball && \
sudo systemctl disable 8ball && \
rm /etc/systemd/system/8ball.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf 8ball && \
rm -rf 8ball.sh && \
rm -rf .8ball && \
rm -rf $(which 8ball)
````

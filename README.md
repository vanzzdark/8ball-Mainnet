# FULLNODE SETUP
```
wget -O 8ball.sh https://raw.githubusercontent.com/vanzzdark/misestm/main/8ball.sh && chmod +x 8ball.sh && ./8ball.sh
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

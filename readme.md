# Network State Genesis

# [`0x3ef61d25b2bf303de52efdd5e50698bed8f9eb8d`](https://etherscan.io/address/0x3ef61d25b2bf303de52efdd5e50698bed8f9eb8d#code)

A few transactions:
* Deployment: https://etherscan.io/tx/0x7dc335524956bbf72b52682de79f319d5bbd8e047c2c44d079515e2e133fd81b
* Set **GENESIS** (the PDF on IPFS that contains the address): https://etherscan.io/tx/0xd4251e54e5be8539ae7370a84ab26c23f87b352770e0faa93b97d7176ef5fba0
* Set TokenURI: https://etherscan.io/tx/0xc18e30fe78a698d798fad7c9291e17f252d109f4aa202db469511d3ff1f29888
* Purchased passport for myself, sanity check, dogfooding: https://etherscan.io/tx/0x30de35f02cccfde67ec990bf3f5bd18c402763fe8ddaa614caa259cfefff135c

![Etherscan transaction list](etherscan-transactions-list.png)

* Use 200,000 gas limit (otherwise will run out of gas)
* Use wallet that you control (don't send directly from an exchange)
* MetaMask should be OK, but you'll not see tokens, see this [help page](https://metamask.zendesk.com/hc/en-us/articles/360058238591-NFT-tokens-in-MetaMask-wallet)

### GENESIS

* ipfs://QmYLhBxgdUCCygX5GBB764PwUUQknFBjERmPKu22DfqmFS
* https://gateway.pinata.cloud/ipfs/QmYLhBxgdUCCygX5GBB764PwUUQknFBjERmPKu22DfqmFS

### TokenURI

* ipfs://QmVTbit5XrcnCHbg1XFLdCd9fVJGUrUnmRSGWFWGYKEtga
* https://gateway.pinata.cloud/ipfs/QmVTbit5XrcnCHbg1XFLdCd9fVJGUrUnmRSGWFWGYKEtga

# Code / Audits / Testing

* Using OpenZeppelin as a base
* The custom code is relatively simple
* Automated test: `truffle test`

# Preserving historical value

YouTube video of Mars talking throughout the deployment: https://youtu.be/7MlUj2zU2p4

[![YouTube cover image](https://img.youtube.com/vi/7MlUj2zU2p4/0.jpg)](https://www.youtube.com/watch?v=7MlUj2zU2p4)

![Deployment checklist](deployment-checklist.jpg)
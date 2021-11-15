# ERC House  

[ERC House](https://erchouse.com) is an open-source, decentralized exchange for new custom ERC token projects.  

Think of it as the Ebay of crypto tokens.  

Gone are the days of expensive ICOs and token listings. As a token project creator, simply pay a small registration fee to whitelist your token on our site, and then list your token for sale.  

As a buyer you can use our platform to find brand new, hot token projects, and become an early investor.  

This repository contains the Solidity smart contract running ERC House. To see the website repository, please visit [https://github.com/CheyenneAtapour/CheyenneAtapour.github.io-erchouse](https://github.com/CheyenneAtapour/CheyenneAtapour.github.io-erchouse). You may also visit the website at [https://erchouse.com](https://erchouse.com)

The contract is deployed on rinkeby here: [https://rinkeby.etherscan.io/address/0x7902968b285ad994844c0ddfa22bfe86f906b359](https://rinkeby.etherscan.io/address/0x7902968b285ad994844c0ddfa22bfe86f906b359)

## Local Deployment

To compile the project, run  
brownie compile  

To deploy the project, run  
brownie console  
accounts[0].deploy(ERCHouse, accounts[0].address)  

## Links

YouTube presentation: [https://www.youtube.com/watch?v=pu0ZFIcBLg8](https://www.youtube.com/watch?v=pu0ZFIcBLg8)  
Detailed Slide Deck: [https://docs.google.com/presentation/d/1icF9cJr5_YZYrprvK6sSC_8GkHU7Ad55HEE6LR5uB3g/edit#slide=id.p](https://docs.google.com/presentation/d/1icF9cJr5_YZYrprvK6sSC_8GkHU7Ad55HEE6LR5uB3g/edit#slide=id.p)
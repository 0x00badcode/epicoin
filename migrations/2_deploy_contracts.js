// migrations/2_deploy_contracts.js

const EpiCoin = artifacts.require('EpiCoin');
const Betting = artifacts.require('Betting');

module.exports = async function (deployer, network, accounts) {
    // Deploy EpiCoin contract
    await deployer.deploy(EpiCoin);
    const epiCoinInstance = await EpiCoin.deployed();

    // Assign tokens to the first account
    await epiCoinInstance.mint(accounts[0], 1000);

    // Deploy Betting contract with the EpiCoin contract address
    await deployer.deploy(Betting, epiCoinInstance.address);

    const bettingInstance = await Betting.deployed();

    // Transfer tokens to the Betting contract
    await epiCoinInstance.transfer(bettingInstance.address, 500, { from: accounts[0] });
};

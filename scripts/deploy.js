// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers } = require("hardhat");

async function main() {
  // const Charity = await ethers.getContractFactory("Charity");
  // const charity = await Charity.deploy();

  // await charity.deployed();

  // console.log(
  //   `deployed to ${charity.address}`
  // );

  const NFT = await hre.ethers.getContractFactory("NFT");
    const Token = await hre.ethers.getContractFactory("MyToken");
    const Staking = await hre.ethers.getContractFactory("StakeNFT");
    // const nft1 = await NFT.deploy('0x4696F32B4F26476e0d6071d99f196929Df56575b', 'NFT1', 'NFT1')
    // await nft1.deployed();
    // const nft2 = await NFT.deploy('0x4696F32B4F26476e0d6071d99f196929Df56575b', 'NFT2', 'NFT2')
    // await nft2.deployed();
    const token = await Token.deploy();
    await token.deployed();
    // const staking = await Staking.deploy(token.address);
    // await staking.deployed();

    console.log("Token deployed to:", token.address);
    // console.log("NFT deployed to:", nft1.address, nft2.address);
    // console.log("Staking deployed to:", staking.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers } = require("hardhat");

async function main() {
  
  let name = "Zetachain domain";
  let symbol = "zeta";
  // let recipient = "0x4696F32B4F26476e0d6071d99f196929Df56575b";

  // const Post = await hre.ethers.getContractFactory("Post");
  // const post = await Post.deploy(name, symbol, recipient)
  // console.log("Post deployed to:", post.address);
  
  // await hre.run("verify:verify", {
  //   address: post.address,
  //   constructorArguments: [name, symbol, recipient],
  // });

  const Domain = await hre.ethers.getContractFactory("Domain");
  const domain = await Domain.deploy(name, symbol, recipient)
  console.log("Post deployed to:", domain.address);
  
  await hre.run("verify:verify", {
    address: post.address,
    constructorArguments: [name, symbol, recipient],
  });

  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

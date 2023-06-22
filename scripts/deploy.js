// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers } = require("hardhat");

async function main() {
  
  let name = "Post NFT";
  let symbol = "Post";
  let recipient = "0x4696F32B4F26476e0d6071d99f196929Df56575b";

  const Post = await hre.ethers.getContractFactory("Post");
  const PostFactory = await hre.ethers.getContractFactory("PostFactory");
  const post = await Post.deploy(name, symbol, recipient)
  const postFactory = await PostFactory.deploy();
  
  console.log("Post deployed to:", post.address);
  console.log("PostFactory deployed to:", postFactory.address);

  await hre.run("verify:verify", {
    address: post.address,
    constructorArguments: [name, symbol, recipient],
  });

  await hre.run("verify:verify", {
    address: postFactory.address,
    // constructorArguments: [name, symbol, recipient],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

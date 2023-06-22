const {
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("PostFactory", function () {

  let postFactory, owner, otherAccount;
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  before("deploy", async function () {
    
    // Contracts are deployed using the first signer/account by default
    [owner, otherAccount] = await ethers.getSigners();

    const PostFactory = await ethers.getContractFactory("PostFactory");
    postFactory = await PostFactory.deploy();

  })

  it("Should be the same nft name", async function () {

    let name = "Post NFT";
    let symbol = "Post";
    let recipient = "0x4696F32B4F26476e0d6071d99f196929Df56575b";
    const _postFactory = await postFactory.createCollection(name, symbol, recipient);
    console.log(_postFactory);

    let _name = await postFactory.name();
    expect(_name).to.equal(name);
  });


});

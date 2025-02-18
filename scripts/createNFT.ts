import { ethers } from "hardhat";

// Factory contract address, replace with your own
const factoryAddress = "0x0A0f70b019497De7865716E363922D58Fe91B9F3";

async function main() {
  // Contract params
  const params = {
    name: "FlipTest",
    symbol: "FLIPTEST",
    initialPrice: ethers.parseEther("0.001"),
    maxSupply: 10000n,
    creatorFeePercent: ethers.parseEther("0.05"),  // 5%
    imageUrl: "",
    description: "FLIP NFT is an NFT standard constructed using the Bonding Curve algorithm, representing FLIP platform's first attempt at this mechanism. With a total supply of 10,000, its Mint Price/Buy Price/Sell Price increases as the supply increases."
  };

  // Get Factory contract instance
  const Factory = await ethers.getContractFactory("Factory");
  const factory = Factory.attach(factoryAddress);

  // create a nft collection
  console.log("Creating new nft collection...");
  const tx = await factory.createFLIP(
    params.name,
    params.symbol,
    params.initialPrice,
    params.maxSupply,
    params.creatorFeePercent,
    params.imageUrl,
    params.description
  );

  console.log("Transaction hash:", tx.hash);
  
  const receipt = await tx.wait();
  
  const event = receipt?.logs.find(
    (log: { topics: any[]; }) => log.topics[0] === factory.interface.getEvent("FLIPCreated")?.topicHash
  );

  if (event) {
    const decodedEvent = factory.interface.parseLog({
      topics: event.topics,
      data: event.data
    });
    console.log("New FLIP created at:", decodedEvent?.args[1]);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
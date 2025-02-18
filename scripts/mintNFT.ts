import { ethers } from "hardhat";

const flipAddress = "0xF34b329e5e41A68bd4b3fD4333a2330f9d0B78d3";

async function main() {
  const FLIP = await ethers.getContractFactory("Trade");
  const flip = FLIP.attach(flipAddress);

  console.log("Start Minting FLIP token...");
  
  try {
    const [signer] = await ethers.getSigners();
    const signerAddress = await signer.getAddress();
        
    const balance = await ethers.provider.getBalance(signerAddress);
    console.log(`Current account address: ${signerAddress}`);
    console.log(`Account balance: ${ethers.formatEther(balance)} ETH`);

    const buyPrice = await flip.getBuyPriceAfterFee();
    console.log(`Mint Price: ${ethers.formatEther(buyPrice)} ETH`);

    if (balance < buyPrice) {
      console.log("Insufficient balance to mint");
      return;
    }

    console.log("Minting NFT...");
    const tx = await flip.mint({
      value: buyPrice,
      gasLimit: 300000
    });

    console.log("Transaction hash:", tx.hash);
    
    const receipt = await tx.wait();
    
    const event = receipt?.logs.find(
      (log: any) => log.topics[0] === flip.interface.getEvent("TokenMinted")?.topicHash
    );

    if (event) {
      const decodedEvent = flip.interface.parseLog({
        topics: event.topics,
        data: event.data
      });
      console.log("Minting successful! TokenID:", decodedEvent?.args[1].toString());
      console.log("Payment amount:", ethers.formatEther(decodedEvent?.args[2]), "ETH");
      console.log("Creator fee:", ethers.formatEther(decodedEvent?.args[3]), "ETH");
    }
  } catch (error) {
    console.error("Minting failed:", error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
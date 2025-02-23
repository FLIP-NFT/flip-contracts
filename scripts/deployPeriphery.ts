import { ethers } from "hardhat";

async function main() {
  const periphery = await ethers.deployContract("FlipPeriphery");
  await periphery.waitForDeployment();

  console.log("Periphery deployed to:", await periphery.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
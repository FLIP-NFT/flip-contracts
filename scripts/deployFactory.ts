import { ethers } from "hardhat"; 

async function main() {
  const Registry = await ethers.getContractFactory("Registry");
  const registry = await Registry.deploy();
  await registry.waitForDeployment();

  const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory.deploy(await registry.getAddress());
  await factory.waitForDeployment();

  console.log("Registry deployed to:", await registry.getAddress());
  console.log("Factory deployed to:", await factory.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
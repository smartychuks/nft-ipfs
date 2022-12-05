const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
  const metadataURL = "ipfs://QmWk4szxUeTSuZY6npbJYNuLJMpGYjmMv8DTr5hpHW83Zx/";

  const contract = await ethers.getContractFactory("Dpunks");
  const deployedContract = await contract.deploy(metadataURL);
  await deployedContract.deployed(); 

  console.log("Dpunks contract Address:", deployedContract.address);
}

// To handle errors
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
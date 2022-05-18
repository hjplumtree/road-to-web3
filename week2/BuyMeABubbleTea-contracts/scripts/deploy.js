const hre = require("hardhat");

async function main() {
  // 컨트랙트 가져오기 & 배포(Deploy)
  const BuyMeABubbleTea = await hre.ethers.getContractFactory(
    "BuyMeABubbleTea",
  );
  const buyMeABubbleTea = await BuyMeABubbleTea.deploy();
  // 배포 되는 것 기다려서 log 찍기
  await buyMeABubbleTea.deployed();
  console.log("BuyMeABubbleTea deployed to ", buyMeABubbleTea.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

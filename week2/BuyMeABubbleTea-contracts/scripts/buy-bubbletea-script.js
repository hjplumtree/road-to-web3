// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

/**
 * 헬퍼 함수 3개: getBalance, printBalances, printMemos
 */

// 주소로 Ethere 밸런스 리턴
async function getBalance(address) {
  // Hardhat 이용해서 Big Int 값으로 이더리움 가져오기
  const balnceBigInt = await hre.waffle.provider.getBalance(address);
  // Hardhat 이용해서 사람이 읽기 좋게 포맷
  return hre.ethers.utils.formatEther(balnceBigInt);
}

// 주소들의 Ether 밸런스 보여주는 로그
async function printBalances(addresses) {
  let idx = 0;
  for (const address of addresses) {
    console.log(`Address ${idx} balance: `, await getBalance(address));
    idx++;
  }
}

// 버블티 산 사람들의 메모 로그
async function printMemos(memos) {
  for (const memo of memos) {
    const timestamp = memo.timestamp;
    const tipper = memo.name;
    const tipperAddress = memo.from;
    const message = memo.message;
    console.log(
      `At ${timestamp}, ${tipper}, (${tipperAddress}) said: "${message}`,
    );
  }
}

async function main() {
  // 테스트 계정 가져오기
  const [owner, tipper, tipper2, tipper3] = await hre.ethers.getSigners();

  // 컨트랙트 가져오기 & 배포(Deploy)
  const BuyMeABubbleTea = await hre.ethers.getContractFactory(
    "BuyMeABubbleTea",
  );
  const buyMeABubbleTea = await BuyMeABubbleTea.deploy();
  // 배포 되는 것 기다려서 log 찍기
  await buyMeABubbleTea.deployed();
  console.log("BuyMeABubbleTea deployed to ", buyMeABubbleTea.address);

  // 버블티 구매 전에 밸런스 확인
  const addresses = [owner.address, tipper.address, buyMeABubbleTea.address];
  console.log("== start ==");
  await printBalances(addresses);

  // 오너한테 버블티 선물
  const tip = { value: hre.ethers.utils.parseEther("1") };
  await buyMeABubbleTea
    .connect(tipper)
    .buyBubbleTea("KEEDAE", "You're the best!", tip);
  await buyMeABubbleTea
    .connect(tipper2)
    .buyBubbleTea("MISUK", "What a beautiful day", tip);
  await buyMeABubbleTea
    .connect(tipper3)
    .buyBubbleTea("INJAE", "Let's go!!", tip);

  // 버블티 구매 후 밸런스 확인
  console.log("== Bought bubble tea ==");
  await printBalances(addresses);

  // 밸런스 인출(Withdraw)
  await buyMeABubbleTea.connect(owner).withdrawTips();

  // 인출 후 밸런스 확인
  console.log("== withdraw Tips ==");
  await printBalances(addresses);

  // 오너한테 남긴 모든 메모 확인
  console.log("== memos ==");
  const memos = await buyMeABubbleTea.getMemos();
  printMemos(memos);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

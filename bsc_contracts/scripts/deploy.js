//  npx hardhat run --network localhost ./scripts/deploy.js
// npx hardhat run --network ropsten ./scripts/deploy.js

const testdata = require("../data/jsonHeaders.json");

async function main() {
    const bscRelayContractFactory = await ethers.getContractFactory(
        "BSCRelay"
    );
    const bscrelay = await bscRelayContractFactory.deploy(testdata.VS_block200, 0);
    console.log("BSCRelay deployed to:", bscrelay.address);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
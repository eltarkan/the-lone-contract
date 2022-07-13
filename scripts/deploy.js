async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Game = await ethers.getContractFactory("Game");
    const game = await Game.deploy();

    console.log("Game contract address:", game.address);


    const Coin = await ethers.getContractFactory("Coin");
    const coin = await Coin.deploy(9900000000000000000000000000000);

    console.log("Coin contract address:", coin.address);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
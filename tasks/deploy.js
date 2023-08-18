task("deploy", "Deploy GeoParametricInsurance contract")
    .addPositionalParam("name", "The name of the contract that you want to deploy")
    .addPositionalParam("chainId", "Set the chain_id to be passed while deployment")
    .setAction(async(taskArgs) => {
        const contractName = taskArgs.name
        const chain_id = taskArgs.chainId

        const networkName = network.name

        console.log(contractName)

        console.log(chain_id)

        console.log(`Deploying ${contractName} to ${networkName} network`)

        const geoParametricInsuranceContractFactory = await ethers.getContractFactory(contractName)

        const geoParametricInsuranceContract = await geoParametricInsuranceContractFactory.deploy(chain_id);

        await geoParametricInsuranceContract.waitForDeployment();

        const address = await geoParametricInsuranceContract.getAddress()

        console.log(`${contractName} deployed to ${address} on ${networkName} network.`)

    })

module.exports = {}
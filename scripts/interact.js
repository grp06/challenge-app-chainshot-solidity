require("@nomiclabs/hardhat-ethers");

var fs = require('fs');
const util = require('util');
var ethers = require('ethers')
const fsPromises = fs.promises;
const INFURA_API_KEY = "0353c672db7841d9a58cde88dfbce1f6";

const ABI_FILE_PATH = 'artifacts/contracts/Greeter.sol/Greeter.json';

async function getAbi(){
  const data = await fsPromises.readFile(ABI_FILE_PATH, 'utf8');
  const abi = JSON.parse(data)['abi'];
  return abi;
}

async function main() {
  const {INFURA_PROJECT_ID}  = process.env;
  
    const KOVAN_PRIVATE_KEY = "5f9a26937a48e1d6659c13f2115159886318545a405b33e9658e8188609cd80b";
    let provider = new ethers.providers.InfuraProvider('kovan',{projectId: INFURA_PROJECT_ID})
    let signer = new ethers.Wallet(KOVAN_PRIVATE_KEY, provider);

    const abi = await getAbi()
    var DEPLOYED_CONTRACT_ADDRESS = '0x609ee7E72721E5836B4681d772aC27099f9b736e';
    
    // let contract = new ethers.Contract(DEPLOYED_CONTRACT_ADDRESS, abi, signer);
    let contract = new ethers.Contract(DEPLOYED_CONTRACT_ADDRESS, abi, signer);
    // const daiBalance = await contract.getDaiBalance();
    // console.log('daiBalance ', daiBalance);

    // const contractDaiBalance = await contract.getContractsDaiBalance();
    // console.log('contractDaiBalance ', ethers.utils.formatEther(contractDaiBalance));

    const transferTx = await contract.transferDaiToContract({gasLimit: 9000000});
    console.log("🚀 ~ main ~ transferTx", transferTx)
    await transferTx.wait()
    const contractDaiBalanceAfter = await contract.getContractsDaiBalance();
    console.log('contractDaiBalanceAfter ', ethers.utils.formatEther(contractDaiBalanceAfter));
    
    
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
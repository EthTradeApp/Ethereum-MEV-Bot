const Web3 = require("web3")
const HDWalletProvider =require("@truffle/hdwallet-provider")
const IRouter = require('@uniswap/v2-periphery/build/IUniswapV2Router02.json')
const IFactory = require('../build/contracts/IUniswapV2Factory.json')
const contractAddress= "0x6Df0E5E592029fEf046FFA03cc93f79C1589634f"
const privateKey = "5b884004eed1c51ca80a9b8ed26ad2c0ba2b6ec6c3cc9ab36297b9d97442489c"
const ArbContract=require("../build/contracts/ArbitrageBot.json")
const erc20min=require("../build/contracts/IERC20.json")
const publicAddress="0xeA55260DA2091B592E9FD7A41e22205618A48E9E"
const wss_provider = new HDWalletProvider(
    privateKey,
    "wss://mainnet.infura.io/ws/v3/85fc7c4c61664a96808975adbb581787"
     )
const addrToken0="0x6B175474E89094C44Da98b954EedeAC495271d0F"
const addrToken1="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2" 
const web3 = new Web3(wss_provider)


const arbContract=new web3.eth.Contract(
  ArbContract,
  contractAddress
)







const  swapUniToSushi=async()=>{
    try{
        const res=await arbContract.methods.UniswapToSushiwapTrade(addrToken0,addrToken1).send({
            from:publicAddress
           
           })
            console.log(res)
            console.log(res.transactionHash)
            return res.transactionHash
    }catch(e){
        console.log(e)
        console.log("Transaction failed")
        
    }
   
        
    
    }

    
const  swapSushiToUni=async()=>{
    try{
        const res=await arbContract.methods.SushiwapToUniswapTrade(addrToken0,addrToken1).send({
            from:publicAddress
           
           })
            console.log(res)
            console.log(res.transactionHash)
            return res.transactionHash
    }catch(e){
        console.log(e)
        console.log("Transaction failed")
        
    }
   
        
    
    }

module.exports={swapUniToSushi,swapSushiToUni}
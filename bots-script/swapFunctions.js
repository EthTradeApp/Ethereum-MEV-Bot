const Web3 = require("web3")
const HDWalletProvider =require("@truffle/hdwallet-provider")
const IRouter = require('@uniswap/v2-periphery/build/IUniswapV2Router02.json')
const IFactory = require('../build/contracts/IUniswapV2Factory.json')
const contractAddress= "0x3E7Cee87CD88b39e415dE10161167F4dF453f13a"
const privateKey = "5b884004eed1c51ca80a9b8ed26ad2c0ba2b6ec6c3cc9ab36297b9d97442489c"
const ArbContract=require("../build/contracts/ArbitrageBot.json")
const erc20min=require("../build/contracts/IERC20.json")
const publicAddress="0xeA55260DA2091B592E9FD7A41e22205618A48E9E"
const wss_provider = new HDWalletProvider(
    privateKey,
    "wss://ropsten.infura.io/ws/v3/85fc7c4c61664a96808975adbb581787"
     )
const addrToken0="0xaD6D458402F60fD3Bd25163575031ACDce07538D"
const addrToken1="0xc778417E063141139Fce010982780140Aa0cD5Ab" 
const web3 = new Web3(wss_provider)


const arbContract=new web3.eth.Contract(
  ArbContract.abi,
  contractAddress
)







const  swapUniToSushi=async()=>{
    try{
        const res=await arbContract.methods.UniswapToSushiwapTrade(addrToken0,addrToken1).send({
            from:publicAddress})
            console.log(res)
            console.log(res.transactionHash)
            return res.transactionHash
    }catch(e){
        console.log(e)
    }
   
        
    
    }

module.exports={swapUniToSushi}
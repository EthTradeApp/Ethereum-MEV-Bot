
const app=require("./app")
const http = require('http')
const port = process.env.PORT || 3000
const httpserver = http.createServer(app)
const { Server } = require("socket.io");

const {arbTrade} =require("./bots-script/arbitrageBot")
 const {swapUniToSushi,swapSushiToUni}=require("./bots-script/swapFunctions")


console.log(`${port } running`)
  
arbTrade()

//swapUniToSushi()
 //swapSushiToUni()
try{
  httpserver.listen(port)
}catch(e){
    console.log(e.message)
}


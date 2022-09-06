
const app=require("./app")
const http = require('http')
const port = process.env.PORT || 3000
const httpserver = http.createServer(app)
const { Server } = require("socket.io");

const {arbTrade} =require("./bots-script/arbitrageBot")
//const {txMonitor}=require("./txMonitor")


console.log(`${port } running`)
  
arbTrade()


try{
  httpserver.listen(port)
}catch(e){
    console.log(e.message)
}


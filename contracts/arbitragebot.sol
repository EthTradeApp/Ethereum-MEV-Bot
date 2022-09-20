//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;
pragma abicoder v2;


import "@uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolImmutables.sol";
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import  '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
import "@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";

contract ArbitrageBot {
  string public name;
  ISwapRouter public swapRouter;
  address public Router2;
 


    uint constant deadline = 20 minutes; // transaction deadline
   
    string base;
    string assest;
    address public owner;
    uint profit;

    
  // For this example, we will set the pool fee to 0.3%.
  uint24 public constant poolFee = 3000;

  
     event TradeSucces(
          string assest,
          string base,
          uint profit,
          bool success
     );


      mapping(address => uint) _balance;
      
     


  constructor( ISwapRouter _Router1, address _Router2) {
      swapRouter = _Router1;
      Router2 = _Router2;
      name="Arbitrage Bot";
     
      owner=msg.sender;

  }
   modifier onlyOwner(){
      require(msg.sender==owner,"");
          _;
     }

   function getAmountOutMin( address _router,address _token1, address _token2, uint256 _amount)  public view returns (uint256) {
	      	address[] memory path;
	      	path = new address[](2);
	      	path[0] = _token1;
	      	path[1] = _token2;
	      	uint256[] memory amountOutMins = IUniswapV2Router02(address(_router)).getAmountsOut(_amount, path);
	      	
            return  amountOutMins[path.length -1];
             
      }

  function getSushiswapReserve(address _pairAddress) public view returns(uint, uint, uint){
      (uint reserve1,uint reserve2,uint time)=IUniswapV2Pair(address(_pairAddress)).getReserves();
     
      return (reserve1,reserve2,time);

  }

     // for uniswap
  function swapExactInputSingle(ISwapRouter _swapRouter,address _tokenIn, address _tokenOut,uint256 _amountIn) internal returns (uint256 amountOut) {
      

      // Transfer the specified amount of DAI to this contract.
     // TransferHelper.safeTransferFrom(_tokenIn, msg.sender, address(this), _amountIn);

      // Approve the router to spend DAI.
      TransferHelper.safeApprove(_tokenIn, address(_swapRouter), _amountIn);
        IERC20Minimal(_tokenIn).allowance(address(this), address(_swapRouter));
      // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
      // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
      ISwapRouter.ExactInputSingleParams memory params =
          ISwapRouter.ExactInputSingleParams({
              tokenIn: _tokenIn,
              tokenOut: _tokenOut,
              fee: poolFee,
              recipient: address(this),
              deadline: block.timestamp + deadline,
              amountIn:_amountIn,
              amountOutMinimum:0,
              sqrtPriceLimitX96: 0
          });

      // The call to `exactInputSingle` executes the swap.
      amountOut = _swapRouter.exactInputSingle(params);
  }
      // for sushiswap
  
	function SushiswapToken(address _router, address _tokenIn, address _tokenOut, uint256 _amountIn) private {
	   TransferHelper.safeApprove(_tokenIn, address(_router), _amountIn);
        IERC20Minimal(_tokenIn).allowance(address(this), address(_router));
		address[] memory path;
		path = new address[](2);
		path[0] = _tokenIn;
		path[1] = _tokenOut;
      
	
		IUniswapV2Router02(_router).swapExactTokensForETH(_amountIn,0, path, address(this), block.timestamp + deadline);
	}
    function swapToken(address _router, address _tokenIn, address _tokenOut, uint256 _amountIn) private {
		IERC20Minimal(_tokenIn).approve(_router, _amountIn);
		address[] memory path;
		path = new address[](2);
		path[0] = _tokenIn;
		path[1] = _tokenOut;
	
		IUniswapV2Router02(_router).swapExactTokensForTokens(_amountIn, getAmountOutMin(_router,_tokenIn,_tokenOut,_amountIn), path, address(this), block.timestamp + deadline);
	}

   function UniswapToSushiwapTrade(address _token1, address _token2) external onlyOwner {
        uint startBalance = IERC20Minimal(_token1).balanceOf(address(this));
        uint token2InitialBalance = IERC20Minimal(_token2).balanceOf(address(this));
        
        swapExactInputSingle(swapRouter,_token1, _token2,startBalance);
        uint token2Balance = IERC20Minimal(_token2).balanceOf(address(this));
        uint tradeableAmount = token2Balance - token2InitialBalance;
        swapToken(Router2,_token2, _token1,tradeableAmount);
        uint endBalance = IERC20Minimal(_token1).balanceOf(address(this));
      // require(endBalance > startBalance, "Trade Reverted, No Profit Made");
       profit= endBalance -startBalance;
       emit TradeSucces(assest,base,profit,true);
   }
    function SushiwapToUniswapTrade(address _token1, address _token2) external onlyOwner {
        uint startBalance = IERC20Minimal(_token1).balanceOf(address(this));
        uint token2InitialBalance = IERC20Minimal(_token2).balanceOf(address(this));
        
          swapToken(Router2,_token1, _token2, startBalance);
        uint token2Balance = IERC20Minimal(_token2).balanceOf(address(this));
        uint tradeableAmount = token2Balance - token2InitialBalance;
       swapExactInputSingle(swapRouter,_token2, _token1,tradeableAmount);
        uint endBalance = IERC20Minimal(_token1).balanceOf(address(this));
      // require(endBalance > startBalance, "Trade Reverted, No Profit Made");
       profit= endBalance -startBalance;
       emit TradeSucces(assest,base,profit,true);
   }

     function getBalance (address _tokenContractAddress) external view  returns (uint256) {
		uint balance = IERC20Minimal(_tokenContractAddress).balanceOf(address(this));
		return balance;
	}
		function recoverEth() external onlyOwner {
		payable(msg.sender).transfer(address(this).balance);
	}
    
    
	function recoverTokens(address tokenAddress) external onlyOwner {
	     IERC20Minimal token = IERC20Minimal(tokenAddress);
		token.transfer(msg.sender, token.balanceOf(address(this)));
     	}
   
     receive ()  payable external{
      _balance[msg.sender] += msg.value;

    }



}
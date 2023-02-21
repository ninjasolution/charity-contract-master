// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Charity is Ownable {

    using SafeMath for uint256;

    address public carityAddress;
    uint256 public divisor = 10000;
    address public sponsorAddress;
    uint256 public burnPercent;
    address public bnbToUsdAddress = 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE;
    AggregatorV3Interface internal priceFeed;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    

    address public DBME;

    mapping(uint256 => int256) public products;

    event AddProduct(uint256 index, int256 amount);
    event BuyProduct(address buyer, uint256 index);

    constructor() {
        priceFeed = AggregatorV3Interface(
            bnbToUsdAddress
        );

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(DBME, _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;
        
    }

    function addProduct(uint256 index, int256 amount) public onlyOwner {
        emit AddProduct(index, amount);
        products[index] = amount;
    }

    function setDBME(address _dbme) public onlyOwner {
        DBME = _dbme;
    }

    function buyProduct(uint256 index) public {
        uint256 balanceInUSD = address(msg.sender).balance * uint256(getLatestPrice());

        require(balanceInUSD >= products[index], "Insufficient balance");

        uint256 amountInEth = products[index] / getLatestPrice();

        uint256 sponsorAmount = amountInEth.mul(2);

    }

    function swapETHForTokens(uint256 amount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = address(this);

      // make the swap
      try   uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
            0, // accept any amount of Tokens
            path,
            deadAddress, // Burn address
            block.timestamp
        ){
        emit SwapETHForTokens(amount, path);

        }catch{}
        
    }
    

    /**
     * Returns the latest price.
     */
    function getLatestPrice() public view returns (int256) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }
}

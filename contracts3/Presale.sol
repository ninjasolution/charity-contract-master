// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;
        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require(b == 0 || c / b == a);
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256);
        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Presale {
    using SafeMath for uint256;

   
    IERC20 public token;
    bool public paused;
    uint256 public minDeposit = 50000000000000000000; // 50$
    address public owner;
    address public feeReceiver;
    uint256 public perDollarPrice;
    uint256 public totalSold;
    mapping(address => uint256) public userBuy;
    mapping(uint => address) public buyTokenByIndex;
    address[] public buyers;
    mapping(address => mapping(address => bool)) public referral;

    modifier onlyOwner() {
        require(owner == msg.sender, "Caller must be the owner");
        _;
    }

    constructor(
        uint256 _price,
        address _presaleToken,
        address _feeReceiver
    ) {
        owner = msg.sender;
        perDollarPrice = _price;
        token = IERC20(_presaleToken);
        feeReceiver = _feeReceiver;

        //testnet
        buyTokenByIndex[0] = 0x3CEBe03595E53A3CEB67A88a4f7E15eE9868c9f9;
        buyTokenByIndex[1] = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee;
        buyTokenByIndex[2] = 0x64544969ed7EBf5f083679233325356EbE738930;

        //mainnet
        // buyTokenByIndex[0] = 0x3CEBe03595E53A3CEB67A88a4f7E15eE9868c9f9;
        // buyTokenByIndex[1] = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
        // buyTokenByIndex[2] = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    }

    function allBuyers() public view returns (uint256) {
        return buyers.length;
    }

    function likeBalance(address _user) public view returns (uint256) {
        return token.balanceOf(_user);
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function remainingToken() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setTokenPrice(uint256 _price) public onlyOwner {
        perDollarPrice = _price;
    }

    function setPause(bool _value) public onlyOwner {
        paused = _value;
    }

    function setToken(address _token) public onlyOwner {
        token = IERC20(_token);
    }

    function setBuyToken(uint index, address _token) public onlyOwner {
        buyTokenByIndex[index] = _token;
    }

    function buyFromToken(
        uint256 _pid,
        address payable _ref,
        uint256 _amount
    ) external {
        require(!paused, "Presale is paused");
        uint256 check = 1;

        if (
            _ref == address(0) ||
            _ref == msg.sender ||
            referral[msg.sender][_ref]
        ) {} else {
            referral[msg.sender][_ref] = true;
            check = 2;
        }

        if (_pid < 4) {

            if (check == 1) {
                uint256 per5 = _amount.mul(5).div(100);
                uint256 per95 = _amount.sub(per5);
                IERC20(buyTokenByIndex[_pid]).transferFrom(msg.sender, _ref, per5);
                IERC20(buyTokenByIndex[_pid]).transferFrom(msg.sender, owner, per95);
            } else {
                IERC20(buyTokenByIndex[_pid]).transferFrom(msg.sender, owner, _amount);
            }

            uint256 temp = _amount;
            uint256 multiplier = perDollarPrice.mul(temp).div(10**18);

            if (userBuy[msg.sender] == 0) {
                buyers.push(msg.sender);
            }

            userBuy[msg.sender] = userBuy[msg.sender].add(multiplier);
            totalSold += _amount;
        } else {
            revert("Invalid token selection");
        }
    }

    function releaseToken(address _receiver) public onlyOwner {
        require(userBuy[_receiver] > 0, "Receiver has not bought any tokens");
        uint256 amount = userBuy[_receiver];
        userBuy[_receiver] = 0;
        token.transfer(msg.sender, amount);
    }

    function getTotalSold() public view returns (uint256) {
        return totalSold;
    }

    function rescueTokens(
        IERC20 _add,
        uint256 _amount,
        address _recipient
    ) public onlyOwner {
        _add.transfer(_recipient, _amount);
        totalSold = totalSold.add(_amount);
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function changeFeeReceiver(address _newReceiver) public onlyOwner {
        feeReceiver = _newReceiver;
    }
}
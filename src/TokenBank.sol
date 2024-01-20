// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";


contract TokenBank {
    using SafeERC20 for IERC20;
    address private owner;
     
    mapping(address => mapping(address => uint)) public balances;

    constructor(address _owner){
        owner = _owner;
    }

    function deposite(address token, uint256 amount) external {
        IERC20(token).safeTransferFrom(msg.sender,address(this),amount);
        balances[token][msg.sender] += amount;
    }

    function withdraw(address token, uint amount) external {
        if(msg.sender == owner){
            require(amount < balances[token][address(this)],"go away");
            balances[token][address(this)] -= amount;
            IERC20(token).transfer(msg.sender , amount);
        }else{
            require(amount < balances[token][msg.sender],"go away");
            balances[token][msg.sender] -= amount;
            IERC20(token).transfer(msg.sender , amount);
        }

    }

    function balance_token(address token) external view returns (uint) {
        return balances[token][msg.sender];
    }

    function tokensReceived(
        address from,
        address sender,
        uint amount,
        address token) external returns(bool){
       balances[token][sender] += amount;
       return true;
    }
}
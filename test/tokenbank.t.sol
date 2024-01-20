// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

import "src/TokenBank.sol";
import {MyERC20} from "src/MyERC20.sol";
contract tokenbankTest is Test {
    using SafeERC20 for IERC20;
    MyERC20 public mytoken;
    TokenBank public tokenbank;
    address admin = makeAddr("admin");
    address tokenAddress = makeAddr("mytoken");
    address userAddress = makeAddr("user1");

    function setup() public {
        vm.startPrank(admin);
        {
            mytoken = new MyERC20("hh", "hh");
            mytoken.mint(10000);
            payable(userAddress).transfer(2000);
            mytoken.approve(address(tokenbank), 1000);
        }
        vm.stopPrank();
        vm.startPrank(userAddress);
        {
            mytoken.approve(address(tokenbank),1500);
            mytoken.transferFrom(msg.sender, address(this), 1000);
        }
    }

    function test_deposote(uint amount) public {
        vm.startPrank(admin);
        {
            vm.assume(amount > 1 && amount <= 1000);
            mytoken.transferFrom(msg.sender, address(this), amount);
            assertTrue(mytoken.balanceOf == 10000 - amount, "erorr balance");
        }
        vm.stopPrank();
    }

    function test_admin_withdraw (uint amount) public {
        vm.startPrank(admin);
        {
         vm.assume(amount > 1 && amount <1000);
         tokenbank.withdraw(tokenAddress,amount);
         assertTrue(mytoken.balanceOf == 8000 - amount, "erorr balance");

        }
        vm.stopPrank();
    }

    function test_user_withdraw (uint amount) public {
        vm.startPrank(userAddress);
        {
         vm.assume(amount > 1 && amount <1000);
         tokenbank.withdraw(tokenAddress,amount);
         assertTrue(mytoken.balanceOf == 1000 + amount, "erorr balance");
        }
        vm.stopPrank();
    }
}

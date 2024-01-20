// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MyERC721} from "src/MyNFT.sol";
import {ERC20} from "src/ERC20.sol";
import {NFTMarket} from "src/NFTMarket.sol";

contract NFTMarketTest is Test {
    NFTMarket public NFTMarkettest;
    address admin = makeAddr("admin");
    address tokenAddress = makeAddr("mytoken");
    address nftAddress = makeAddr("nft");
    address buyerAddress = makeAddr("buyer");
 
    MyERC721 public nft;
    ERC20 public mytoken;
  function setUp() public {
    vm.startPrank(admin);{
        mytoken = new ERC20("hh","hh");
        mytoken.mint(1000000);
        payable(buyerAddress).transfer(1000);
        nft = new MyERC721();
        nft.mint(admin,"haha");
        nft.mint(admin,"hahaha");
        nft.approve(address(NFTMarkettest),0);
        nft.approve(address(NFTMarkettest),1);
    }
    vm.stopPrank();

    vm.startPrank(buyerAddress);{
        mytoken.transferFrom(admin,address(NFTMarkettest),200);
    }
  }
  
//   function test_sell() public{
//     vm.startPrank(admin);{
//         NFTMarkettest.addNFT(0,100);
//         NFTMarkettest.addNFT(1,100);
//     }
//     vm.stopPrank();

//     assertTrue(NFTMarkettest.sells[0]);
//   }

     function test_buynft() public {
       vm.startPrank(admin);{
           NFTMarkettest.addNFT(0,100);
           NFTMarkettest.addNFT(1,100);
       }
       vm.stopPrank();
       vm.startPrank(buyerAddress);
        {
        NFTMarkettest.buyNFT(0, 100);
        NFTMarkettest.buyNFT(1, 100);
        console.log("token.balanceOf(admin)==",mytoken.balanceOf(admin));
        console.log("token.balanceOf(buyerAddress)==",mytoken.balanceOf(buyerAddress));
        assertTrue(mytoken.balanceOf(admin)== 999200, "admin error balance");  
        assertTrue(mytoken.balanceOf(buyerAddress)== 800, "buyer error balance");  
        }
        vm.stopPrank();
     }
}

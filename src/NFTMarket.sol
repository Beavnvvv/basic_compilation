// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
using SafeERC20 for IERC20;

interface IERC721{
    function transferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}
contract NFTMarket {
    address private token = address(0xBf5Cfc6A505C51d7086A2DCCA36B2b5e137dcaF9);
    address private nft = address(0x7574f999a452746Fcdf796a1BDf8D091C3580Da3);
    mapping(uint => uint) lists;
    mapping(uint => bool) sells;

    function addNFT(uint tokenID, uint amount) external {
        if(IERC721(nft).ownerOf(tokenID) == msg.sender){
            lists[tokenID] = amount;
            sells[tokenID] = true;
        }
        else{
            revert();
        }
    }
    
    function buyNFT(uint tokenID, uint amount) external {
        require(sells[tokenID] = true, "go away");
        amount = lists[tokenID];
        IERC20(token).safeTransferFrom(msg.sender,address(this),amount);
        IERC721(nft).transferFrom(address(this), msg.sender,tokenID);
        sells[tokenID] = false;
    }

    function tokensReceived(
        address from,
        address to,
        uint amount,
        uint tokenID)external{
            require(sells[tokenID] = true, "go away");
            require(msg.sender == token, "go away");
            amount = lists[tokenID];
            IERC20(token).safeTransferFrom(msg.sender,address(this),amount);
            IERC721(nft).transferFrom(address(this), msg.sender,tokenID);
            sells[tokenID] = false;
        }
}
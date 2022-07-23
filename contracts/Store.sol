// contracts/Pet.sol
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./Pet.sol";
import "./Paw.sol";

contract Store {
  Paw public token;
  Pet public NFT;

  event Sold(uint256 nftId, uint256 price, address buyer);
  event OnSale(uint256 nftId, uint256 price, address seller);

  // DONE: Keep record to track if a token ID is for sale or not.
  mapping(uint256 => bool) private tokenIdForSale;

  // DONE: Keep record to linking a token's ID to their buyers.
  mapping(uint256 => address) private tokenOwners;

  constructor(Paw pawaddr, Pet petaddr) {
    token = pawaddr;
    NFT = petaddr;
  }

  function isOnSale(uint256 _tokenId) public view returns (bool) {
    return tokenIdForSale[_tokenId];
  }

  function tokenPrice(uint256 tokenId) public view returns (uint256 price) {
    price = NFT.tokenPrice(tokenId);
  }

  // DONE: Create the nftSale function.
  function nftSale(uint256 _tokenId, uint256 price) external {
    // DONE: Require that the person connected to the contract is the NFT owner.
    require(msg.sender == tokenOwners[_tokenId], "NFT sale requires that you be the owner of the token");

    // DONE: Set a boolean in a record to indicate that the NFT is for sale.
    tokenIdForSale[_tokenId] = true;

    // DONE: Set the NFT token price using a function in Pet.sol.
    NFT.setTokenPrice(_tokenId, price);

    // DONE: Emit an onSale Event using the token ID, the price, and the address connected to the contract.
    emit OnSale(_tokenId, price, msg.sender);
  }
  
  // DONE: Complete nftMintBuy.
  function nftMintBuy(uint256 price, string memory tokenURI) external {
    // DONE: Require that only the NFT contract owner can call this function.  Use NFT.owner().
    require(msg.sender == NFT.owner(), "Only the  NFT contract owner can call nftMintBuy");

    // DONE: Use require to check for insufficient allowance compared to price.  See allowance() in ERC20.sol.
    // Hint: allowance() asks how much money can a spender spend on behalf of an owner.
    // The "owner" is the person interacting with the contract, and the contract itself is the "spender".
    require(token.allowance(msg.sender, address(this)) >= price, "The allowance for this contract is too low to purchase this token");

    // DONE: Use require to check for insufficient balance compared to price.  See balanceOf() in ERC20.sol.
    require(token.balanceOf(msg.sender) >= price, "Insufficient balance to purchase token");

    // DONE: Mint a token to the buyer.
    NFT.mintTo(msg.sender, tokenURI, price);

    // DONE: Set the price of the token.
    uint256 tokenId = NFT.currentTokenId() + 1;
    NFT.setTokenPrice(tokenId, price);

    // DONE: Transfer that same number of tokens from the buyer to this contract's address.
    token.transferFrom(msg.sender, address(this), price);

    // DONE: Set the new owner of the token to be the address connected to the contract.
    tokenOwners[tokenId] = msg.sender;
    
    // DONE: Set that the token is no longer for sale.
    tokenIdForSale[tokenId] = false;

    // DONE: Emit a Sold Event using the token ID, price, and the buyer's address.
    emit Sold(tokenId, price, msg.sender);
  }

  // DONE: Complete nftBuy.
  function nftBuy(uint256 tokenId) public {
    // DONE: Require that the tokenId is on sale.
    require(tokenIdForSale[tokenId] == true, "NFT must be on sale to purchase");

    // DONE: Get the token's current price.
    uint256 tokenSalePrice = tokenPrice(tokenId);

    // DONE: Use require to check for both insufficient allowance or insufficient balance.
    require(token.allowance(msg.sender, address(this)) >= tokenSalePrice, "The allowance for this contract is too low to purchase this token");
    require(token.balanceOf(msg.sender) >= tokenSalePrice, "Insufficient balance to purchase token");

    // DONE: Transfer Paw tokens from msg.sender to the owner of the NFT based on the token's price.
    // See ownerOf() in ERC721.sol.
    token.transferFrom(msg.sender, NFT.ownerOf(tokenId), tokenSalePrice);

    // DONE: Transfer the NFT from its original owner to the buyer (i.e., msg.sender).
    NFT.transferFrom(NFT.ownerOf(tokenId), msg.sender, tokenId);

    // DONE: Set the new owner of the token to be the address connected to the contract.
    tokenOwners[tokenId] = msg.sender;
    
    // DONE: Set that the token is no longer for sale.
    tokenIdForSale[tokenId] = false;

    // DONE: Emit a Sold Event using the token ID, price, and the buyer's address.
    emit Sold(tokenId, tokenSalePrice, msg.sender);
  }
}

/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// TODO: Create a contract named "Paw" that inherits from ERC20 and Ownable.
// See Pet.sol for syntax.

abstract contract Paw is ERC20, Ownable {
  // TODO: Set the private air drop amount at any number.
  uint public airDropAmount = 20;


  // TODO: Write the constructor for the PAW token and _mint() to msg.sender any number of tokens.
  constructor() {
    _mint(msg.sender, airDropAmount);
  }
  
  // TODO: Write a public function requestAirdrop() that calls airdropTo() 
  // and transfer the air drop amount of tokens to the account connected to the contract.
  function requestAirdrop(address recipientAddress) view public {
    
  }
  

  // TODO: Write a private function airdropTo() that takes in a recipient address and an amount 
  // and _transfer() that amount of tokens from the contract owner (see owner()) to the recipient.
  function airdropTo(address recipientAddress, uint16 amount) private {
    
  }
}

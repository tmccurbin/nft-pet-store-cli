// contracts/Pet.sol
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Pet is ERC721URIStorage, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Keep record of token value
    mapping(uint256 => uint256) public tokenIdToValue;

    // DONE: declare the event of minting the NFTs including the ID, price, and string token URI.
    event Minted(uint256 indexed _id, uint256 indexed _price, string _uri);

    constructor() ERC721("Pet", "PET") {}

    function exists(uint256 tokenId) view public returns (bool) {
        return _exists(tokenId);
    }
    
    // DONE: Implement currentTokenId() to return the id of the last created token.
    // Note that _tokenIds.current() will return the id of the token that will be created next.
    // Use require or revert to throw an error if no tokens have been created yet.
    function currentTokenId() view public returns (uint256) {
        require(_tokenIds.current() > 0, "No tokens have been created yet");
        uint256 nextTokenId = _tokenIds.current();
        uint256 lastTokenId = nextTokenId - 1;
        return lastTokenId;
    }
    
    // DONE: Implement setTokenURI() to link the tokenID to a string URI.
    function setTokenURI(uint256 tokenId, string memory _tokenURI)
        public
        returns (bool)
    {
        // DONE: Require that the account connected to the contract isn't the zero address.
        require(msg.sender != address(0), "Not allowed to set token URI with the zero address");

        // DONE: Require that the tokenId exists.
        require(tokenId <= currentTokenId(), "Cannot set token URI because token ID does not exist");

        // DONE: Call _setTokenURI to link the URI to the token.  See ERC721URIStorage.sol.
        _setTokenURI(tokenId, _tokenURI);
        
        return true;
    }
    
    // DONE: Write your minting function:
    function mintTo(address recipient, string memory _tokenURI, uint256 _nftPrice)
        public
        returns (uint256)
    {
        // DONE: Require that the account connected to the contract isn't the zero address.
        require(msg.sender != address(0), "Cannot mint to the zero address");

        // DONE: Get the id of the token that will be created next.
        uint256 nextTokenId = _tokenIds.current();

        // DONE: Set the NFT Price in the record.
        tokenIdToValue[nextTokenId] = _nftPrice;

        // DONE: Use _mint() to create a token and send it to the recipient.  See ERC721.sol.
        _mint(recipient, nextTokenId);

        // DONE: Use _setTokenURI() to link the token's id with the proper token URI.
        _setTokenURI(nextTokenId, _tokenURI);

        // DONE: Increment _tokenIds.
        _tokenIds.increment();

        // DONE: Emit a Minted event with the NFT's id, price, and URI.
        emit Minted(nextTokenId, _nftPrice, _tokenURI);

        // DONE: Return the NFT's id.
        return nextTokenId;
    }

    function tokenPrice(uint256 _tokenId) public view returns (uint256) {
        return tokenIdToValue[_tokenId];
    }

    function setTokenPrice(uint256 _tokenId, uint256 price) public {
        tokenIdToValue[_tokenId] = price;
    }

    // DONE: Use the super keyword to call inherited versions of these functions from parent contracts.
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function tokenURI(uint256 tokenId) view public override(ERC721, ERC721URIStorage) returns (string memory) {        
        return super.tokenURI(tokenId);
    }
    
    // If an error in VSCode saying "Function needs to specify overridden contracts...", ignore it.
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        // DONE: Call _beforeTokenTransfer() before using super.transferFrom().
        _beforeTokenTransfer(from, to, tokenId);
        super.transferFrom(from, to, tokenId);
    }
}

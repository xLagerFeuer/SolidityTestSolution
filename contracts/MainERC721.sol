// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/IERC998ERC721TopDown.sol";


contract MainERC721 is ERC721URIStorage, Ownable  {
    using Counters for Counters.Counter;
    Counters.Counter private _idGenerator;

    mapping(uint256=>address) public tokenOwnerOf;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}
    event Minted(uint256 tokenId, string tokenURI, address owner);

    function mintNFT(string memory _tokenURI)
        public onlyOwner
        returns (uint256)
    {
        _idGenerator.increment();

        uint256 newID = _idGenerator.current();
        _mint(_msgSender(), newID);
        _setTokenURI(newID, _tokenURI);

        tokenOwnerOf[newID] = _msgSender();

        emit Minted(newID, _tokenURI, _msgSender());
        return newID;
    }
    
    function mintNFT(address _recipient, string memory _tokenURI)
        public onlyOwner
        returns (uint256)
    {
        _idGenerator.increment();
        
        uint256 newID = _idGenerator.current();

        _mint(_recipient, newID);
        _setTokenURI(newID, _tokenURI);

        tokenOwnerOf[newID] = _recipient;

        emit Minted(newID, _tokenURI, _msgSender());
        return newID;
    }

}
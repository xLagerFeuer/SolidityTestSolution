// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IERC998ERC721TopDown.sol";
import "./MainERC721.sol";

// TODO: aprroved address, ERC adress: call method from IERC721 (?),

contract ERC998ERC721TopDown is IERC998ERC721TopDown, Ownable, MainERC721  {
    constructor() MainERC721("TESTparent", "TEST") {}

    address private _contractOwner = owner();
 
    mapping(uint256=>uint256[]) public prnt2chld;
    mapping(uint256=>uint256) public chld2prnt;
    mapping(uint256=>address) public tokenOwnerOf;

    uint256 constant public ERC998_MAGIC = uint256(0xcd740db5); // TODO: maybe cast it to bytes4
    bytes4 constant public ERC721_MAGIC = 0x150b7a02;
    // address constant public CURRENT_ERC = address(this); // misscode
    
    
    function _bytes2address(bytes32 x) private pure returns (address addr) {
        assembly { addr := mload(add(x,32)) }
    }

    function _toBytes(uint256 x) private pure returns (bytes32 b) {
        assembly { mstore(add(b, 32), x) }
    }

    function _address2uint(address x) private pure returns (uint256) {
        return uint256(uint160(x));
    }

    // here ERC998 is a structure, not a graph
    // one descendant have one ancestor, one ancestor have many descendants
    // therefore, if tokenid don't have parents => he is a root token

    // Problem: how use _childContract

    function rootOwnerOf(uint256 _tokenId) public override view returns (bytes32) {
        return rootOwnerOfChild(address(0), _tokenId);
    }

    function rootOwnerOfChild(
        address _childContract, // TODO: rewrite _childContract
        uint256 _childTokenId 
    )
    public override view returns (bytes32) {
        uint256 _parentTokenID = chld2prnt[_childTokenId];
        uint256 _parentOwner = _address2uint(tokenOwnerOf[_parentTokenID]);

        if (_parentOwner == 0) return _toBytes(ERC998_MAGIC | _parentOwner); // TODO: right shift _parentOwner on x bits 
        else return rootOwnerOfChild(_childContract, _parentTokenID);
        // require(_parentOwner != 0, "No parents");
    }

    function ownerOfChild( 
        address _childContract, 
        uint256 _childTokenId 
    ) 
    external override view returns (
        bytes32, uint256
    ) {
        // TODO: wrap it to function
        uint256 _parentTokenID = chld2prnt[_childTokenId];
        uint256 _parentOwner = _address2uint(tokenOwnerOf[_parentTokenID]);

        return (_toBytes(ERC998_MAGIC | _parentOwner), _parentTokenID); // TODO: right shift _parentOwner on x bits 
        // require(_tokenOwner != 0, "No parents");
    }
    
    function onERC721Received(
        address _operator, 
        address _from, 
        uint256 _childTokenId, 
        bytes memory _data
    ) 
    external override 
    returns(bytes4) {
        return ERC721_MAGIC;
    }

    function transferChild(
    uint256 _fromTokenId,
    address _to, 
    address _childContract, 
    uint256 _childTokenId
    ) 
    external override {
        // emit TransferChild(_fromTokenId, _to, _childContract, _childTokenId);

    } 


    function safeTransferChild(
    uint256 _fromTokenId,
    address _to, 
    address _childContract, 
    uint256 _childTokenId, 
    bytes calldata _data
  ) 
    external override {
        // require();
        // disconnectChild()
        // connectChild()
    }

    function safeTransferChild(
    uint256 _fromTokenId,
    address _to, 
    address _childContract, 
    uint256 _childTokenId
  ) 
    external override {
        // require();
        // this.safeTransferChild( // maybe ERROR: why need this. declaration?
        //     _fromTokenId, _to, _childContract, _childTokenId, bytes(0)
        // );

    }

    

    // not required, because ERC721 bottom-up implementation does not exist
    function transferChildToParent(
    uint256 _fromTokenId, 
    address _toContract, 
    uint256 _toTokenId, 
    address _childContract, 
    uint256 _childTokenId, 
    bytes calldata _data
  ) 
    external override {
        // nothing
    }

    // not required
    function getChild(
        address _from, 
        uint256 _tokenId, 
        address _childContract, 
        uint256 _childTokenId
    ) 
    external override {
        // nothing
    }

    function connectChild(
        uint256 childId,
        uint256 parentId
    ) 
    public onlyOwner {
        prnt2chld[parentId].push(childId);
    }

}
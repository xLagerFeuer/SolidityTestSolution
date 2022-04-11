// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IERC998ERC721TopDown.sol";
import "./MainERC721.sol";

contract ERC998ERC721TopDown is IERC998ERC721TopDown, Ownable, MainERC721  {
    constructor() MainERC721("TESTparent", "TEST") {}
 
    mapping(uint256=>uint256[]) public prnt2chld;
    mapping(uint256=>uint256) public chld2prnt;
    mapping(uint256=>address) public tokenOwnerOf;

    uint256 constant public ERC998_MAGIC = uint256(0xcd740db5);
    
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

    function rootOwnerOf(uint256 _tokenId) public override view returns (bytes32) {
        return rootOwnerOfChild(tokenOwnerOf[_tokenId], _tokenId);
    }

    function rootOwnerOfChild(
        address _childContract, // HELP: maybe childOwner?
        uint256 _childTokenId 
    )
    public override view returns (bytes32) {
        uint256 _parentTokenID = chld2prnt[_childTokenId];
        uint256 _parentOwner = _address2uint(tokenOwnerOf[_parentTokenID]);
        if (_parentOwner == 0) return _toBytes(ERC998_MAGIC | _address2uint(_childContract)); // TODO: right shift _parentOwner on x bits 
        else return rootOwnerOfChild(_bytes2address(_toBytes(_parentOwner)), _parentTokenID);
        // require(_parentOwner != 0, "No parents");
    }

    function ownerOfChild( 
        address _childContract, 
        uint256 _childTokenId 
    ) 
    external override view returns (
      bytes32, 
      uint256 parentTokenId
    ) {
        parentTokenId = chld2prnt[_childTokenId];
        uint256 _tokenOwner = uint256(uint160(tokenOwnerOf[parentTokenId]));
        // require(_tokenOwner != 0, "No parents");
        return (_toBytes(ERC998_MAGIC | _tokenOwner), parentTokenId); // TODO: right shift _parentOwner on x bits 
    }
    
//     function onERC721Received(
//     address _operator, 
//     address _from, 
//     uint256 _childTokenId, 
//     bytes memory _data
//   ) 
//     external 
//     returns(bytes4) {

//     }

//     unction transferChild(
//     uint256 _fromTokenId,
//     address _to, 
//     address _childContract, 
//     uint256 _childTokenId
//   ) 
//     external;

//     function safeTransferChild(
//     uint256 _fromTokenId,
//     address _to, 
//     address _childContract, 
//     uint256 _childTokenId
//   ) 
//     external;

//     function safeTransferChild(
//     uint256 _fromTokenId,
//     address _to, 
//     address _childContract, 
//     uint256 _childTokenId, 
//     bytes calldata _data
//   ) 
//     external;

//     function transferChildToParent(
//     uint256 _fromTokenId, 
//     address _toContract, 
//     uint256 _toTokenId, 
//     address _childContract, 
//     uint256 _childTokenId, 
//     bytes calldata _data
//   ) 
//     external;

//     function getChild(
//     address _from, 
//     uint256 _tokenId, 
//     address _childContract, 
//     uint256 _childTokenId
//   ) 
//     external;

    // function connectToParent(uint256) {

    // }

    // function childConnectTo() {

    // }

}
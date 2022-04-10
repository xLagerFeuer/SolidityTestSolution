// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IERC998ERC721TopDown.sol";
import "./MainERC721.sol";

contract ERC998ERC721TopDown is IERC998ERC721TopDown, Ownable, MainERC721  {
    constructor() MainERC721("TESTparent", "TEST") {}
 
    mapping(address=>address[]) public childsOf;
    mapping(address=>address) public parentOf;

    // address rootOwner = owner();
    // address root = address(0);
    // address parentOwner;
    
    // function rootOwnerOf(uint256 _tokenId) public override view returns (bytes32) {
    //     require(rootOwner != address(0), "No parents");
    //     return bytes32(uint256(uint160(rootOwner)) << 96);
    // }

    // function rootOwnerOfChild (address _childContract, uint256 _childTokenId )
    // public override view returns (bytes32) {
    //     require(rootOwner != address(0), "No parents");
    //     return bytes32(uint256(uint160(rootOwner)) << 96);
    // }


//     function ownerOfChild( 
//         address _childContract, 
//         uint256 _childTokenId 
//     ) 
//     external override view returns (
//       bytes32 parentTokenOwner, 
//       uint256 parentTokenId
//     ) {
        
//     }
    
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

}
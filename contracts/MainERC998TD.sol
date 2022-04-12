// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "./interfaces/IERC998ERC721TopDown.sol";
import "./MainERC721.sol";

// TODO: aprroved address, ERC adress: call method from IERC721 (?),

contract ERC998ERC721TopDown is IERC998ERC721TopDown, Ownable, MainERC721  {
    // later
    // using EnumerableSet for EnumerableSet.AddressSet;

    // struct Set {
    //     uint256[] values;
    //     mapping (uint256 => bool) is_in;
    // }

    // Set my_set;

    // function add(uint a) public {
    //     if (!my_set.is_in[a]) {
    //         my_set.values.push(a);
    //         my_set.is_in[a] = true;
    //     }
    // }
    
    constructor() MainERC721("TESTparent", "TEST") {}

    address private _contractOwner = owner();
 
    mapping(uint256=>uint256[]) public prnt2chld;
    mapping(uint256=>uint256) public chld2prnt;

    uint256 constant public ERC998_MAGIC = uint256(0xcd740db5); // TODO: maybe cast it to bytes4
    bytes4 constant public ERC721_MAGIC = 0x150b7a02;
    // address constant public CURRENT_ERC = address(this); // misscode

    event Connected(uint256 childId, uint256 parentId);
    
    function _exist(address x) private returns (bool) {
        return x != address(0);
    }
    
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
        address _childContract,
        uint256 _childTokenId 
    )
    public override view returns (bytes32) {
        uint256 _parentTokenID = chld2prnt[_childTokenId];
        uint256 _parentOwner = _address2uint(tokenOwnerOf[_parentTokenID]);

        if (_parentOwner == 0) return _toBytes(ERC998_MAGIC | _address2uint(tokenOwnerOf[_childTokenId])); // TODO: right shift _parentOwner on x bits 
        else return rootOwnerOfChild(_childContract, _parentTokenID);
        
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
        require(_parentOwner != 0, "No parents");

        // ERROR: bytes are empty
        return (_toBytes(ERC998_MAGIC | _parentOwner), _parentTokenID); // TODO: right shift _parentOwner on x bits 
    }
    

    function connectChild(
        uint256 childId,
        uint256 parentId
    ) 
    public onlyOwner {
        require(tokenOwnerOf[childId] != address(0) && tokenOwnerOf[parentId] != address(0), "Child or parent token does not exist");
        require(chld2prnt[childId] != parentId, "Token already connected");
        prnt2chld[parentId].push(childId);
        chld2prnt[childId] = parentId;
        emit Connected(childId, parentId);
    }


    // later
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
        // emit TransferChild(_fromTokenId, _to, _childContract, _childTokenId); ??

    } 


    // later
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


    // later
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
}
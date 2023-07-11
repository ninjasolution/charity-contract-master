// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Post.sol";

interface IPostFactory {
    function isPost(address _address) external view returns (bool);
    function getOwnCollections() external view returns (address[] memory);
}

contract PostFactory is IPostFactory {

    address[] public posts;

    mapping(address => bool) private _postStatus;

    event CreatedPostCollection(
        address creator,
        address post
    );

    function importCollection(address _collection) external {
        posts.push(_collection);
        _postStatus[_collection] = true;
        emit CreatedPostCollection(msg.sender, _collection);
    }

    function createCollection(string calldata name, string calldata symbol, address feeRecipient) external returns (address _collection) {
        
        bytes memory bytecode = type(Post).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(name, symbol, feeRecipient));
        assembly {
            _collection := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        posts.push(address(_collection));
        _postStatus[_collection] = true;
        
        emit CreatedPostCollection(msg.sender, _collection);
    }


    function getOwnCollections() external view returns (address[] memory) {
        return posts;
    }

    function isPost(address _address) external view returns (bool) {
        return _postStatus[_address];
    }
}




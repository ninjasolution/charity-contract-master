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

    function importCollection(address _address) external {
        posts.push(_address);
        _postStatus[_address] = true;
        emit CreatedPostCollection(msg.sender, _address);
    }

    function createCollection(string memory name, string memory symbol, address feeRecipient) external returns (address collection) {
        
        bytes memory bytecode = type(Post).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(name, symbol, feeRecipient));
        assembly {
            collection := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        posts.push(address(collection));
        _postStatus[collection] = true;
        emit CreatedPostCollection(msg.sender, collection);
    }


    function getOwnCollections() external view returns (address[] memory) {
        return posts;
    }

    function isPost(address _address) external view returns (bool) {
        return _postStatus[_address];
    }
}




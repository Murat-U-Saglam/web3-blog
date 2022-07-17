// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Blog {
    string public name;
    address public owner;
    
    using Counters for Counters.Counter;
    Counters.Counter private _postIds;

    struct Post {
        uint id;
        string title;
        string content;
        bool published;
    }

    mapping(uint => Post) private idToPost;
    mapping(string => Post) private hashToPost;

    event PostCreated(uint id, string title, string hash);
    event PostUpdate(uint id, string title, string hash, bool published);

    constructor(string memory _name){
        console.log("Deploying Blog with name: ", _name);
        name = _name;
        owner = msg.sender;
    }

    function updateNmae(string memory _name) public {
        require(msg.sender == owner);
        name = _name;
    }

    function transferOwnership(address newOwner) public onlyOwner{
        require(msg.sender == owner);
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function fetchPost(string memory hash) public view returns (Post memory post) {
        post = hashToPost[hash];
        return post;
    }

    function createPost(string memory title, string memory hash) public onlyOwner {         //Private blog
        _postIds.increment();
        uint postId = _postIds.current();
        Post storage post = idToPost[postId];
        post.id = postId;
        post.title = title;
        post.published = true;
        post.content = hash;
        hashToPost[hash] = post;
        emit PostCreated (postId, title, hash)
        
    }

    
}

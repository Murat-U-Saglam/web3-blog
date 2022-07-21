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
        uint256 id;
        string title;
        string content;
        bool published;
    }

    mapping(uint256 => Post) private idToPost;
    mapping(string => Post) private hashToPost;

    event PostCreated(uint256 id, string title, string hash);
    event PostUpdate(uint256 id, string title, string hash, bool published);

    constructor(string memory _name) {
        console.log("Deploying Blog with name: ", _name);
        name = _name;
        owner = msg.sender;
    }

    function updateName(string memory _name) public {
        require(msg.sender == owner);
        name = _name;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(msg.sender == owner);
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function fetchPost(string memory hash)
        public
        view
        returns (Post memory post)
    {
        post = hashToPost[hash];
        return post;
    }

    //Private blog due to onlyOwner modifier
    function createPost(string memory title, string memory hash)
        public
        onlyOwner
    {
        _postIds.increment();
        uint256 postId = _postIds.current();
        Post storage post = idToPost[postId];
        post.id = postId;
        post.title = title;
        post.published = true;
        post.content = hash;
        hashToPost[hash] = post;
        emit PostCreated(postId, title, hash);
    }

    function updatePost(
        uint256 postId,
        string memory title,
        string memory hash,
        bool published
    ) public onlyOwner {
        Post storage post = idToPost[postId];
        post.title = title;
        post.published = published;
        post.content = hash;
        idToPost[postId] = post;
        hashToPost[hash] = post;
        emit PostUpdate(postId, title, hash, post.published);
    }

    function fetchPosts() public view returns (Post[] memory) {
        uint256 itemCount = _postIds.current();

        Post[] memory posts = new Post[](itemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            uint256 currentId = i + 1;
            Post storage currentItem = idToPost[currentId];
            posts[i] = currentItem;
        }
        return posts;
    }
}

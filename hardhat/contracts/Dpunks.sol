// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Dpunks is ERC721Enumerable, Ownable {
    using Strings for uint256;
    string _baseTokenURI;
    uint256 public _price = 0.01 ether;//Price of NFT
    bool public _paused; // to pause contract in case of emergency
    uint256 public maxTokenIds = 10; // Max number of NFTs
    uint256 public tokenIds; // number of NFTs minted

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract is currently paused");
        _;
    }

    constructor (string memory baseURI) ERC721("Dpunks", "DPK") {
        _baseTokenURI = baseURI;
    }

    // Function to mint and allows user mint one NFT per transaction
    function mint() public payable onlyWhenNotPaused {
        require(tokenIds < maxTokenIds, "Exceed Maximum Dpunks supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    // function to return the base uri
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }   

    //function that returns URI that enables to extract metadate
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    // function to mark the contract as paused
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    //function to withdraw all ether to the owner of contract
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // function to recieve ether if msg.data is empty
    receive() external payable {}

    // function to receive ether if msg.data is not empty
    fallback() external payable {}

}
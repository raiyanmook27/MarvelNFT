// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarvelNft is ERC721,Ownable{
    using Strings for uint256;
    uint256 private _tokenIds;
    uint256 constant private _maxTokens=5;
    string constant  _baseExtension=".json";

    constructor() ERC721("MarvelNFT","MNFT"){}

    function _baseURI() internal view virtual  override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmW8sBdA9s78Ew1HWxQs37SHRJCu9judGNjhi3TGKAbDNL/";
    }
    
     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        super.tokenURI(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),_baseExtension)) : "";
    }

    function MintNFT() public  payable returns (uint256){
        require(msg.value!=0,"Not enough eth");
        require(_tokenIds<_maxTokens,"All nfts minted");
        _tokenIds+=1;
        _mint(msg.sender, _tokenIds);
        return _tokenIds;
    }

    function withdraw() external onlyOwner {
        require(msg.sender!=address(0),"Address invalid");
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}

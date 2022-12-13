// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
import  "https://github.com/nounsDAO/nouns-monorepo/blob/master/packages/nouns-contracts/contracts/NounsToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
contract Game {
    using SafeMath for uint256;

    struct round {
       uint start;
       uint end ;
    }

    address player;
    mapping (address=>uint) public playerId;
    uint[] public activeplayers;
    bool gameRunning;
   uint tokenid;
   modifier onlyowner() {
    require (msg.sender = owner);
    _;
   }
    constructor(uint _tokenid ) {
     owner = msg.sender; 
     round.start = block.timestamp;
     round.end = round.start + 86400;
     tokenid = _tokenid;
    }

    function registerId(uint id) public returns(uint) {
      playerId[msg.sender] = id;
    }

    function startGame() onlyowner returns (bool gameRunning){
      bool gameRunning = round.end > now;
      return gameRunning;
    }
  
  function enterGame() public payable {
    require(gameRunning);
    bool success = _transfer(msg.sender,address(this),tokenid);
    require(success, "failed to transfer NFT to our contract");
    activeplayers += playerId[msg.sender] ; 
    round.end = now + 86400;
  }    

  function distributereward() onlyowner {
    require(!gameRunning);
    winner = [activeplayers.length - 1];

    _transfer(playerId[winner],balanceof(address(this)));
    timer = 86400;
    delete playerId;
  }

}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint totalWaves;
  uint private seed;
  
  event NewWave(address indexed from, uint timestamp, string message);

  struct Wave {
    address waver;
    string message;
    uint timestamp;
  }

  Wave[] waves;

  mapping(address => uint) public lastWavedAt;

  constructor() payable {
    console.log("Hello World, I'm a Smart Contract");
  }

  function wave(string memory _message) public {

    require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "Wait 15 minutes");

    lastWavedAt[msg.sender] = block.timestamp;

    totalWaves += 1;
    console.log("%s waved w/ message %s", msg.sender, _message);
    
    waves.push(Wave(msg.sender, _message, block.timestamp));

    emit NewWave(msg.sender, block.timestamp, _message);

    uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
    console.log("Random # generated: %s", randomNumber);

    seed = randomNumber;

    if(randomNumber < 50) {
      console.log("%s won!", msg.sender);
    uint prizeAmount = 0.0001 ether;
    require(prizeAmount <= address(this).balance, "Trying to send more money than the contract has.");
    (bool success,) = (msg.sender).call{value: prizeAmount}("");
    require(success, "Failed to send money from contract.");
    }
  }

  function getAllWaves() view public returns (Wave[] memory) {
    return waves;
  }

  function getTotalWaves() view public returns (uint) {
    console.log("We have %d total waves", totalWaves);
    return totalWaves;
  }
}
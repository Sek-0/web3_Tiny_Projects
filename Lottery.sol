// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title A simple solidity lottery
/// @author Sek0


contract Lottery {
    address public manager;
    address[] public players; // make a dynamic array called players

    constructor(){
        manager = msg.sender;
    }

    ///@notice need 1 ether to enter the lottery and then add the address to the players array
    function enterLottery() public payable {
        require(msg.value == 1 ether);
        players.push(msg.sender);
    }

    ///@notice this function is used to print all the addresses in the players array
    function listPlayers() onlyManager() public view returns(address[] memory) {
        return players;
    }

    ///@dev This doesn't use chainlink oracle to implement randomness so this is absolutely not random
    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    ///@notice This function is only usable by the manager, choose a winner and send all the balance funds to the winner then delete the players array
    function pickWinner() onlyManager() public {
        uint winner = random() % players.length;
        payable(players[winner]).transfer(address(this).balance);
        delete players;
    }

    modifier onlyManager {
      require(msg.sender == manager);
      _;
   }
}

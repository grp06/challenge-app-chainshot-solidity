// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

function stringsAreEqual(string memory a, string memory b) view returns (bool) {
    return (keccak256(abi.encodePacked((a))) ==
        keccak256(abi.encodePacked((b))));
}

contract MeditationChallenge {
    constructor(
        string memory name,
        string memory description,
        uint256 numWeeks
    ) {
        owner = msg.sender;
    }

    address owner;

    struct ChallengeStruct {
        string name;
        string description;
        uint256 numWeeks;
        bool started;
        bool ended;
        bool exists;
        uint256[] participantAddresses;
    }

    mapping(string => ChallengeStruct) public challengeStructs;

    string[] challengeIndex;

    struct ParticipantStruct {
        string name;
        uint256 originalDeposit;
    }

    mapping(address => ParticipantStruct) participantStructs;

    address[] participantIndex;

    function createChallenge(
        string memory name,
        uint256 numWeeks,
        bool exists,
        string description
    ) external {
        challengeStructs[name].description = description;
        challengeStructs[name].numWeeks = numWeeks;
        challengeStructs[name].exists = true;
        challengeIndex.push(name);
    }

    function isOwner() public view returns (bool) {
        if (msg.sender == owner) {
            return true;
        }
        return false;
    }

    function getChallengeCount() public view returns (uint256) {
        return challengeIndex.length;
    }

    function getParticpantCount() public view returns (uint256) {
        return participantIndex.length;
    }

    function joinChallenge(
        string memory participantName,
        string memory challengeName
    ) public payable {
        // wouldn't need this is we could just check for existence of the struct.. not sure how to though.
        require(
            challengeStructs[challengeName].exists,
            "challenge doesnt exist"
        );
        participantStructs[msg.sender].name = participantName;
        participantStructs[msg.sender].originalDeposit = msg.value;
        participantIndex.push(msg.sender);
        challengeStructs[challengeName].participantAddresses.push(msg.sender);
    }

    function startChallenge(string memory name) public {
        require(
            challengeStructs[name].exists,
            "challenge doesnt exist. Create it before starting"
        );
        challengeStructs[name].started = true;
    }

    function endChallenge(string memory name) public {
        require(
            challengeStructs[name].exists,
            "challenge doesnt exist. Create it before ending the challenge"
        );
        challengeStructs[name].ended = true;
    }

    function getParticipant(address participantAddress)
        public
        view
        returns (ParticipantStruct memory)
    {
        return participantStructs[participantAddress];
    }

    function getChallenge(string memory challengeName)
        public
        view
        returns (ChallengeStruct memory)
    {}
}

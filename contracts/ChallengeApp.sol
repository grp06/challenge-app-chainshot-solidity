// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract ChallengeApp {
    constructor() {
        owner = msg.sender;
    }

    event ReceivedEth(uint256);

    address owner;

    uint256 challengeIds = 0;

    struct ChallengeStruct {
        address owner;
        string ownerName;
        string challengeName;
        string description;
        uint256 numWeeks;
        bool started;
        bool ended;
        bool exists;
        string zoomLink;
        string weeklyMeetingTime;
        uint256 challengeId;
        address[] participantAddresses;
        string[] participantNames;
    }

    mapping(string => ChallengeStruct) challengeStructs;

    mapping(string => uint256) public challengeBalances;

    function createChallenge(
        string memory challengeName,
        string memory ownerName,
        uint256 numWeeks,
        string memory description,
        string memory zoomLink,
        string memory weeklyMeetingTime
    ) external payable returns (bool) {
        address[] memory participantAddresses;
        string[] memory participantNames;
        require(
            !challengeStructs[challengeName].exists,
            "Challenge already exists, pick a new name"
        );
        ChallengeStruct memory newChallenge = ChallengeStruct({
            owner: msg.sender,
            ownerName: ownerName,
            challengeName: challengeName,
            description: description,
            numWeeks: numWeeks,
            started: false,
            ended: false,
            exists: true,
            zoomLink: zoomLink,
            weeklyMeetingTime: weeklyMeetingTime,
            challengeId: challengeIds += 1,
            participantAddresses: participantAddresses,
            participantNames: participantNames
        });
        challengeIds++;
        challengeStructs[challengeName] = newChallenge;
        joinChallenge(challengeName, ownerName);
        return true;
    }

    function getTotalEthDeposited(string memory challengeName)
        internal
        view
        returns (uint256)
    {
        return challengeBalances[challengeName];
    }

    function deposit(uint256 amount) public payable {
        require(msg.value == amount);
    }

    function joinChallenge(string memory challengeName, string memory name)
        public
        payable
    {
        deposit(msg.value);
        challengeStructs[challengeName].participantAddresses.push(msg.sender);
        challengeStructs[challengeName].participantNames.push(name);
        challengeBalances[challengeName] += msg.value;
    }

    function getContractBalance() internal view returns (uint256) {
        return address(this).balance;
    }

    // from the frontend we will pass in an array of addresses and and array of amounts
    // loop through the addresses and pay out the amount
    // in the future we should handle this after each week
    function distributeEth(address[] memory addresses, uint256[] memory amounts)
        external
    {
        for (uint256 i = 0; i < addresses.length; i++) {
            payable(addresses[i]).transfer(amounts[i]);
        }
    }

    function startChallenge(string memory challengeName) public {
        require(
            challengeStructs[challengeName].exists,
            "challenge doesnt exist. Create it before starting"
        );
        require(
            challengeStructs[challengeName].owner == msg.sender,
            "you must be the owner to start this challenge"
        );
        challengeStructs[challengeName].started = true;
    }

    function endChallenge(string memory challengeName) public {
        require(
            challengeStructs[challengeName].exists,
            "challenge doesnt exist. Create it before ending the challenge"
        );
        require(
            challengeStructs[challengeName].owner == msg.sender,
            "you must be the owner to end this challenge"
        );
        challengeStructs[challengeName].ended = true;
    }

    function getChallenge(string memory challengeName)
        public
        view
        returns (
            ChallengeStruct memory,
            uint256,
            uint256
        )
    {
        return (
            challengeStructs[challengeName],
            getContractBalance(),
            getTotalEthDeposited((challengeName))
        );
    }
}

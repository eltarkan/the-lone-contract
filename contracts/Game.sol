pragma solidity ^0.8.0;

contract Game {

    uint stash = 0;
    uint[] answers = [0,0,0,0];
    string[] questions;

    function createQuestion(string memory question) public {
        stash += answers[0];
        stash += answers[1];
        stash += answers[2];
        stash += answers[3];

        answers = [0,0,0,0];
        questions.push(question);
    }

    function totalStash() public view returns (uint){
        // this is an unneccessary function
        return stash;
    }

    function lastQuestion() public view returns (string memory){
        return questions[questions.length - 1];
    }
    function allQuestions() public view returns (string[] memory){
        return questions;
    }

    function voteAnOption(string memory option, uint _voteCount) public {
        if (keccak256(abi.encodePacked("A")) == keccak256(abi.encodePacked(option))) {
            answers[0] = answers[0] + _voteCount;
        }
        if (keccak256(abi.encodePacked("B")) == keccak256(abi.encodePacked(option))) {
            answers[1] = answers[1] + _voteCount;
        }

        if (keccak256(abi.encodePacked("C")) == keccak256(abi.encodePacked(option))) {
            answers[2] = answers[2] + _voteCount;
        }

        if (keccak256(abi.encodePacked("D")) == keccak256(abi.encodePacked(option))) {
            answers[3] = answers[3] + _voteCount;
        }
    }

    function getVotes() public view returns (uint[] memory){
        return answers;
    }
}

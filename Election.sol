pragma solidity ^0.5.2;

contract Election{
    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint candidatesCount;

    struct Candidate{
        string name;
        string partie;
        address owner;
        uint ID;
        uint votes;
    }

    function addCandidates(string memory _name, string memory _partie) public {
        require(bytes(_name).length != 0 || bytes(_partie).length != 0);
        candidates[candidatesCount] = Candidate(_name, _partie, msg.sender, candidatesCount, 0);
        candidatesCount++;
    }

    function isCandidate(uint256 _ID) public view returns(bool){
        if (_ID>= candidatesCount){
            return false;
        }
        else {
            return true;
        }
    }

    modifier voteOnlyOnce(){
        require(voters[msg.sender] == false);
        _;
    }
    
    modifier onlyCandidate(uint256 _ID){
        require (candidates[_ID].owner == msg.sender);
        _;
    }
    
    modifier cost(uint _amount){
        require(msg.value >= _amount, "Not enough Ether provided");
        _;
    }
    
    event voted(uint _ID);

    function vote(uint _ID) external payable voteOnlyOnce() cost(0.01 ether){
        require(isCandidate(_ID), "This ID isn't linked to a candidate");
        candidates[_ID].votes++;
        emit voted(_ID);
        voters[msg.sender] = true;
    }
    
    function modifyPartie(uint _ID, string memory _partie) public onlyCandidate(_ID){
        candidates[_ID].partie = _partie;
    }
}
